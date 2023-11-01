module YouTube
  class SearchResource < Resource

    def list(**params)
      response = get_request "search", params: {part: "id,snippet"}.merge(params)
      Collection.from_response(response, type: SearchResult)
    end

  end
end
