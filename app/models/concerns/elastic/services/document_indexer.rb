module Elastic
  module Services
    class DocumentIndexer
      def index_document(operation, record)
        case operation.to_s
        when /index/

          Elasticsearch::Model.client.index(
            index: record.__elasticsearch__.index_name,
            type: record.__elasticsearch__.document_type,
            id: record.id,
            body: record.__elasticsearch__.as_indexed_json)
        when /delete/
          Elasticsearch::Model.client.delete(index: record.__elasticsearch__.index_name,
                                type: record.__elasticsearch__.document_type,
                                id: record.id)
        else
          raise ArgumentError, "Unknown operation '#{operation.to_s}'"
        end
      end
    end
  end
end

