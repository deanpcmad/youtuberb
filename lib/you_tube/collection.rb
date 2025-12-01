module YouTube
  class Collection
    attr_reader :data, :total, :next_page_token, :prev_page_token

    def self.from_response(response, type:)
      body = response.body

      new(
        data: body["items"].map { |attrs| type.new(attrs) },
        total: body["items"].count,
        next_page_token: body["nextPageToken"],
        prev_page_token: body["prevPageToken"],
      )
    end

    def initialize(data:, total:, next_page_token:, prev_page_token:)
      @data = data
      @total = total
      @next_page_token = next_page_token
      @prev_page_token = prev_page_token
    end
  end
end
