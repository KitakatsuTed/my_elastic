class IndexImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :elasticsearch, retry: false

  def perform(klass, target_index, batch_size)
    Rails.logger.debug "#{target_index}のデータ同期開始"
    # 開始の通知 slackとかで良さげ
    begin
      Object.const_get(klass).__elasticsearch__.import(index: target_index, batch_size: batch_size)
    rescue => e
      p e.message
      Rails.logger.debug "#{target_index}のデータ同期中にエラー発生 #{e.message}"
    end
    Rails.logger.debug "#{target_index}のデータ同期開始"
    # 終了の通知
  end
end
