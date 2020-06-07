module Elastic
  module Worker
    class IndexWorker
      include Sidekiq::Worker
      include Elastic::Services
      sidekiq_options queue: :elasticsearch, retry: false

      def perform(klass, operation, record_id)
        record = Object.const_get(klass).find(record_id)

        Rails.logger.debug [operation, "#{record.class} ID: #{record.id}"]

        Elastic::Services::DocumentIndexer.new.index_document(operation, record)
      end
    end
  end
end
