module YouTube
  class SearchResource < Resource

    def list(**params)
      request_params = {part: "id,snippet"}.merge(params)
      response = get_request "search", params: request_params

      next_callback = ->(token) { list(page_token: token, **params) }
      prev_callback = ->(token) { list(page_token: token, **params) }

      Collection.from_response(
        response,
        type: SearchResult,
        next_page_callback: next_callback,
        prev_page_callback: prev_callback
      )
    end

  end
end
