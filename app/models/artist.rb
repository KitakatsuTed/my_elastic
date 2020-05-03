class Artist < ApplicationRecord
  include Elastic::ArtistSearchable

  validates :name, presence: true
  validates :age, presence: true
  validates :birth, presence: true
  validates :gender, presence: true

  enum gender: { man: 2, woman: 3 }

end
