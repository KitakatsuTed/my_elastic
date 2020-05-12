class Artists::IndexWorker
  include Sidekiq::Worker
  sidekiq_options queue: :elasticsearch, retry: false

  def perform(arg_hash)
    operation = arg_hash["operation"].to_sym
    artist = Artist.find(arg_hash["record_id"])

    Rails.logger.debug [operation, "ID: #{artist.id}"]

    Elastic::Indexer.new.index_document(operation, artist)
  end

  def execute(arg_hash)
    self.class.perform_async(arg_hash)
  end
end
