module YouTube
  class Collection
    attr_reader :data, :total

    def self.from_response(response, type:)
      body = response.body

      new(
        data: body["items"].map { |attrs| type.new(attrs) },
        total: body["pageInfo"]["totalResults"],
        # cursor: body.dig("pagination", "cursor")
      )
    end

    def initialize(data:, total:)
      @data = data
      @total = total
    end
  end
end
