class Artist < ApplicationRecord
  include Elastic::Searchable
  index_config attr_mappings: { id: 'integer', name: 'text', age: 'integer', birth: 'date', gender: 'text' }

  validates :name, presence: true
  validates :age, presence: true
  validates :birth, presence: true
  validates :gender, presence: true

  enum gender: { man: 2, woman: 3 }

end
