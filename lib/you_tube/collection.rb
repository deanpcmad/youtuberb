module YouTube
  class Collection
    include Enumerable

    attr_reader :data, :total, :next_page_token, :prev_page_token

    def self.from_response(response, type:, next_page_callback: nil, prev_page_callback: nil)
      body = response.body

      new(
        data: body["items"].map { |attrs| type.new(attrs) },
        total: body["items"].count,
        next_page_token: body["nextPageToken"],
        prev_page_token: body["prevPageToken"],
        next_page_callback: next_page_callback,
        prev_page_callback: prev_page_callback,
      )
    end

    def initialize(data:, total:, next_page_token:, prev_page_token:, next_page_callback: nil, prev_page_callback: nil)
      @data = data
      @total = total
      @next_page_token = next_page_token
      @prev_page_token = prev_page_token
      @next_page_callback = next_page_callback
      @prev_page_callback = prev_page_callback
    end

    def each(&block)
      data.each(&block)
    end

    def first
      data.first
    end

    def last
      data.last
    end

    def next_page
      return nil unless @next_page_token && @next_page_callback
      @next_page_callback.call(@next_page_token)
    end

    def prev_page
      return nil unless @prev_page_token && @prev_page_callback
      @prev_page_callback.call(@prev_page_token)
    end

    def has_next_page?
      !@next_page_token.nil?
    end

    def has_prev_page?
      !@prev_page_token.nil?
    end
  end
end
