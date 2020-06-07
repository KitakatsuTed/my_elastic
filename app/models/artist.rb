class Artist < ApplicationRecord
  include Elastic::Syncable
  enum gender: { man: 2, woman: 3 }
  # must define index_config otherwise mapping is not mapped
  # you can set argument to index_config to customize mapping
  index_config #attr_mappings: { id: 'integer', name: 'text', age: 'integer', birth: 'date', gender: 'text' }

  # you can override default setting and mapping like below
  #
  # settings index: { number_of_shards: number_of_shards } do
  #   mappings do
  #     indexes key, type: value
  #   end
  # end

  validates :name, presence: true
  validates :age, presence: true
  validates :birth, presence: true
  validates :gender, presence: true


  # class IndexWorker
  #   include Sidekiq::Worker
  #   sidekiq_options queue: :elasticsearch, retry: false
  #
  #   def perform(klass, operation, record_id)
  #     record = klass.find(record_id)
  #
  #     Rails.logger.debug [operation, "#{record.class} ID: #{record.id}"]
  #
  #     Elastic::DocumentIndexer.new.index_document(operation, record)
  #   end
  # end
end
