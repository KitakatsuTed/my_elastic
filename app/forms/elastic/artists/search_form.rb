class Elastic::Artists::SearchForm
  include ActiveModel::Model

  attr_accessor :name, :age_from, :age_to, :birth_from, :birth_to, :gender
  attr_reader :query

  def initialize(params = {})
    super(parse_date_params(params, [:birth_from, :birth_to]))
    @query = build_query
  end

  def get_indices
    search.results.results.as_json
  end

  def records
    search.records
  end

  private

  # @see https://teratail.com/questions/57198#reply-91507
  def parse_date_params(params, attributes)
    attributes.each do |attribute|
      date_parts = (1..3).map { |i| params.delete("#{attribute}(#{i}i)") }
      params[attribute] = Time.zone.local(*date_parts).to_date if date_parts.any?
    end
    params
  end

  def search
    @result ||= Artist.search(build_query)
  end

  def build_query
    {
      "query": {
        "bool": {
          "filter": [
            {
              "bool": {
                "must": [
                  { "terms": { "gender": gender ? [gender] : ['man', 'woman'] } },
                ]
              }
            },
            {
              "range": {
                "birth": { "gte": birth_from, "lte": birth_to }
              }
            },
            {
              "range": {
                "age": { "gte": age_from, "lte": age_to }
              }
            }
          ]
        }
      }
    }
  end
end