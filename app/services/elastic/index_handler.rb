class Elastic::IndexHandler

  def initialize(klass)
    @klass = klass
  end

  # インデックスを作成 デフォルトは クラス名の小文字_環境名
  def create_index
    get_client.indices.create index: @klass.index_name, body: { settings: @klass.settings.to_hash, mappings: @klass.mapping.to_hash }
  end

  def delete_index(target_index)
    get_client.indices.delete index: target_index rescue false
  end

  # DBの内容をESのインデックスに同期する
  # レコード量が多いと時間がかかるのでこれだけは非同期実行
  def import_all_record(target_index: ,batch_size: 100)
    IndexImportWorker.perform_async(@klass, target_index, batch_size)
  end

  # ダウンタイムなしでインデックスを切り替える
  # https://techlife.cookpad.com/entry/2015/09/25/170000
  def switch_alias(alias_name:, new_index_name:)
    actions = [{ add: { index: new_index_name, alias: alias_name } }]
    old_indexes = @klass.get_aliases(alias_name: alias_name).keys
    old_indexes.each { |old_index| actions << { remove: { index: old_index, alias: alias_name } } }
    p actions

    get_client.indices.update_aliases(body: { actions: actions })
  end

  private
  def get_client
    @klass.__elasticsearch__.client
  end
end
