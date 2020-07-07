class Artist < ApplicationRecord
  # include Elastic::Syncable
  include ElasticArSync::Elastic::Syncable

  enum gender: { man: 2, woman: 3 }
  # must define index_config otherwise mapping is not mapped
  # you can set argument to index_config to customize mapping
  index_config override_mappings: { name: { type: :keyword } }
  # index_config override_mappings: { name: { type: :text, "analyzer": "kuromoji" } }

  # you can override default setting and mapping like below instead define index_config
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

end
