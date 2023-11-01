module YouTube
  class SearchResource < Resource

    def list(**params)
      response = get_request "search", params: {part: "snippet"}.merge(params)
      Collection.from_response(response, type: Video)
    end

  end
end
