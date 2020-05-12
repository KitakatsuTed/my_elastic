module Elastic::ArtistSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name "artists_#{Rails.env}" # 接続するindex名

    # after_commitでRDBを操作した時にESのインデックスも同期させる
    # アプリのサーバーに負荷をかけ無いように非同期で実行させる
    after_commit on: [:create] do
      IndexBaseWorker.new(Artists::IndexWorker.new).perform({ operation: :index, record_id: id })
      # Artists::IndexWorker.perform_async(:index, id)
    end

    after_commit on: [:update] do
      Artists::IndexWorker.perform_async(:index, id)
    end

    after_commit on: [:destroy] do
      Artists::IndexWorker.perform_async(:delete, id)
    end

    settings index: { number_of_shards: 1 } do
      # ES6からStringが使えないのでtextかkeywordにする。
      mappings dynamic: 'false' do
        indexes :id, type: 'integer'
        indexes :name, type: 'text'
        indexes :age, type: 'integer'
        indexes :birth, type: 'date'
        indexes :gender, type: 'text' # enumを使用している場合は文字列(text)でドキュメント保存にする

        # indexes :name, type: 'nested' do
        #   indexes :name, analyzer: 'ngram_analyzer', type: 'string'
        #   indexes :id, type: 'integer'
        # end
      end
    end

    # オーバーライド
    def as_indexed_json(_options = {})
      attributes.symbolize_keys.slice(:id, :name, :birth, :age, :gender)
    end
  end

  module ClassMethods
    # インデックスを作成 クラス名_日時刻
    def create_index(options = {})
      client = __elasticsearch__.client
      client.indices.delete index: index_name rescue nil if options[:force]
      client.indices.create index: index_name, body: { settings: settings.to_hash, mappings: mapping.to_hash }
    end

    # DBの内容をESのインデックスに同期する
    def import_all_data
      __elasticsearch__.import(index: index_name)
    end

    def switch_alias!(option = {})
    end
  end
end
