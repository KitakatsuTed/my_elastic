class Elastic::SearchForm
  include ActiveModel::Model

  attr_accessor :name, :age, :birth, :gender

  def initialize(params = {})
    super
  end

  def build_query
    {
      "query": {
        "bool": {
          "filter": {
            "bool": {
              "must": [
                # { "term": { "name": ClassDetail::PUBLIC } },
                # { "term": { "age": age || '' } },
                # { "term": { "birth": birth || '' } },
                { "term": { "gender": gender || 'man' } }
              ]
              # "must_not": [{}]
            }
          }
        }
      }
    }
  end
end
