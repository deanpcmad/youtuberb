module YouTube
  class ActivitiesResource < Resource
    
    def list
      response = get_request "activities", params: {home: true}
      # response = post_request("games", body: "fields id,name,status,url,created_at,updated_at;")
      # Collection.from_response(response, type: Game)
    end

  end
end
