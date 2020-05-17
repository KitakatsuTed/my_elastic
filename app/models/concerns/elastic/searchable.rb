module Elastic::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    index_name "#{self.to_s.downcase.pluralize}_#{Rails.env}_#{Time.zone.now.strftime('%Y%m%d%H%M')}"

    # after_commitでRDBを操作した時にESのインデックスも同期させる
    # アプリのサーバーに負荷をかけ無いように非同期で実行させる
    after_commit on: [:create] do
      IndexBaseWorker.new(Object.const_get("#{self.class.to_s.pluralize}::IndexWorker").new).perform({ operation: :index, record_id: id })
    end

    after_commit on: [:update] do
      IndexBaseWorker.new(Object.const_get("#{self.class.to_s.pluralize}::IndexWorker").new).perform({ operation: :index, record_id: id })
    end

    after_commit on: [:destroy] do
      IndexBaseWorker.new(Object.const_get("#{self.class.to_s.pluralize}::IndexWorker").new).perform({ operation: :delete, record_id: id })
    end

    # オーバーライド
    def as_indexed_json(_options = {})
      attributes.symbolize_keys.select { |key, _| self.class.mapping_list_keys.include?(key) }
    end
  end

  module ClassMethods
    # インデックスを作成 デフォルトは クラス名の小文字_環境名
    def create_index
      Elastic::IndexHandler.new(self).create_index
    end

    def delete_index(target_index)
      Elastic::IndexHandler.new(self).delete_index(target_index)
    end

    # DBの内容をESのインデックスに同期する
    def import_all_record(target_index: ,batch_size: 100)
      Elastic::IndexHandler.new(self).delete_index(target_index: target_index, batch_size: batch_size)
      # __elasticsearch__.import(index: target_index, batch_size: batch_size)
    end

    # ダウンタイムなしでインデックスを切り替える
    # https://techlife.cookpad.com/entry/2015/09/25/170000
    def switch_alias(alias_name:, new_index_name:)
      Elastic::IndexHandler.new(self).switch_alias(alias_name: alias_name, new_index_name: new_index_name)

      # actions = [{ add: { index: new_index_name, alias: alias_name } }]
      # old_indexes = get_aliases(alias_name: alias_name).keys
      # old_indexes.each { |old_index| actions << { remove: { index: old_index, alias: alias_name } } }
      #
      # __elasticsearch__.client.indices.update_aliases(body: { actions: actions })
    end

    def index_config(dynamic: 'false', number_of_shards: 1, attr_mappings:)
      settings index: { number_of_shards: number_of_shards } do
        # ES6からStringが使えないのでtextかkeywordにする。
        mappings dynamic: dynamic do
          attr_mappings.each do |key, value|
            indexes key, type: value
          end
        end
      end
    end

    def mapping_list_keys
      mappings.to_hash[:_doc][:properties].keys
    end

    def get_aliases(alias_name: '')
      begin
        __elasticsearch__.client.indices.get_alias(index: alias_name)
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        raise Elasticsearch::Transport::Transport::Errors::NotFound, "インデックスがありません alias_name: #{alias_name}"
      end
    end
  end
end
