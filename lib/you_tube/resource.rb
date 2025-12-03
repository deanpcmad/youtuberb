module YouTube
  class Resource
    attr_reader :client

    def initialize(client)
      @client = client
    end

    private

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get("#{url}?key=#{client.api_key}", params, headers)
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, headers)
    end

    def patch_request(url, body:, headers: {})
      handle_response client.connection.patch(url, body, headers)
    end

    def put_request(url, body:, headers: {})
      handle_response client.connection.put(url, body, headers)
    end

    def delete_request(url, params: {}, headers: {})
      handle_response client.connection.delete(url, params, headers)
    end

    def handle_response(response)
      case response.status
      when 308
        # 308 Permanent Redirect - used in resumable uploads to indicate more data expected
        return response
      when 400
        # Check for specific error reasons that should have better messages
        if response.body.is_a?(Hash) && response.body["error"].is_a?(Hash)
          error_reason = response.body["error"]["errors"]&.first&.dig("reason")
          if error_reason == "uploadLimitExceeded"
            raise Error, "Error 400: Upload limit exceeded. The account has reached its upload quota. '#{response.body["error"]["message"]}'"
          end
        end
        raise Error, "Error 400: Your request was malformed. '#{response.body["error"]}'"
      when 401
        raise Error, "Error 401: You did not supply valid authentication credentials. '#{response.body["error"]["message"]}'"
      when 403
        raise Error, "Error 403: You are not allowed to perform that action. '#{response.body["error"]["message"]}'"
      when 404
        raise Error, "Error 404: No results were found for your request. '#{response.body["error"]["message"]}'"
      when 409
        raise Error, "Error 409: Your request was a conflict. '#{response.body["error"]["message"]}'"
      when 429
        raise Error, "Error 429: Your request exceeded the API rate limit. '#{response.body["error"]["message"]}'"
      when 500
        raise Error, "Error 500: We were unable to perform the request due to server-side problems. '#{response.body["error"]["message"]}'"
      when 503
        raise Error, "Error 503: You have been rate limited for sending more than 20 requests per second. '#{response.body["error"]["message"]}'"
      when 204
        # 204 No Content - successful response with no body
        return true
      end

      response
    end
  end
end
