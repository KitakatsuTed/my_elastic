class Elastic::IndexHandler

  def initialize(klass)
    @klass = klass
  end

  # インデックスを作成 デフォルトは クラス名の小文字_環境名
  def create_index(new_index_name)
    get_client.indices.create index: new_index_name, body: { settings: @klass.settings.to_hash, mappings: @klass.mapping.to_hash }
  end

  def delete_index(target_index)
    raise 'エイリアス指定中に削除できません' if target_index == @klass.target_alias

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
    raise 'すでにエイリアス指定中です' if new_index_name == @klass.target_alias

    actions = [{ add: { index: new_index_name, alias: alias_name } }]
    old_indexes = @klass.get_aliases.keys
    old_indexes.each { |old_index| actions << { remove: { index: old_index, alias: alias_name } } }

    get_client.indices.update_aliases(body: { actions: actions })
  end

  private
  def get_client
    @klass.__elasticsearch__.client
  end
end
