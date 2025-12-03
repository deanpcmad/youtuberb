require 'json'

module YouTube
  class VideosResource < Resource

    PARTS = "id,snippet,contentDetails,liveStreamingDetails,statistics,status"
    AUTH_PARTS = "id,snippet,contentDetails,fileDetails,processingDetails,statistics,status,suggestions"

    # Retrieves Videos by ID. Can be comma separated to retrieve multiple.
    def list(id: nil, ids: nil)
      raise ArgumentError, "Either id or ids is required" if id.nil? && ids.nil?

      if id
        response = get_request("videos", params: {id: id, part: PARTS})
      elsif ids
        response = get_request("videos", params: {id: ids.join(","), part: PARTS})
      end

      items = response.body["items"]
      return nil if items.nil? || items.empty?

      if items.count == 1
        Video.new(items[0])
      else
        Collection.from_response(response, type: Video)
      end
    end

    # Retrieves liked Videos for the currently authenticated user
    def liked(**options)
      params = {myRating: "like", part: PARTS}.merge(options)
      response = get_request "videos", params: params

      next_callback = ->(token) { liked(pageToken: token, **options.except(:pageToken)) }
      prev_callback = ->(token) { liked(pageToken: token, **options.except(:pageToken)) }

      Collection.from_response(
        response,
        type: Video,
        next_page_callback: next_callback,
        prev_page_callback: prev_callback
      )
    end

    # Retrieves a Video by the ID. This retrieves extra information so will only work
    # on videos for an authenticated user
    def retrieve(id:)
      response = get_request "videos", params: {id: id, part: AUTH_PARTS}
      items = response.body["items"]
      return nil if items.nil? || items.empty?
      Video.new(items[0])
    end

    # Uploads a video using resumable upload protocol
    # Supports large files by uploading in chunks
    #
    # @param file [String, File] Path to video file or File object
    # @param title [String] Video title (required)
    # @param description [String] Video description
    # @param privacy_status [String] 'public', 'unlisted', or 'private'
    # @param tags [Array<String>] Video tags/keywords
    # @param category_id [String] YouTube category ID (e.g., '22' for Music, '28' for Science & Technology)
    # @param embeddable [Boolean] Whether the video can be embedded (default: true)
    # @param license [String] Video license: 'youtube' or 'creativeCommon' (default: 'youtube')
    # @param chunk_size [Integer] Size of upload chunks in bytes (default: 5MB)
    # @return [Video] The uploaded video object with metadata
    def upload(file:, title:, description: nil, privacy_status: "private", tags: nil, category_id: nil, chunk_size: 5242880)
      raise ArgumentError, "title is required" if title.nil? || title.empty?
      raise Error, "access_token is required for video uploads. Initialize client with: YouTube::Client.new(api_key: '...', access_token: '...')" unless client.access_token
      raise ArgumentError, "file does not exist" unless file_exists?(file)

      file_obj = file.is_a?(String) ? File.open(file, 'rb') : file
      file_size = file_obj.size

      begin
        # Step 1: Initialize resumable upload session
        session_uri = initialize_resumable_upload(title, description, privacy_status, tags, category_id, file_size)

        # Step 2: Upload file in chunks
        upload_file_chunks(session_uri, file_obj, file_size, chunk_size)
      ensure
        file_obj.close if file.is_a?(String)
      end
    end

    private

    def file_exists?(file)
      file.is_a?(File) || File.exist?(file)
    end

    def initialize_resumable_upload(title, description, privacy_status, tags, category_id, file_size)
      raise Error, "access_token is required for video uploads" unless client.access_token

      # Use the upload API endpoint (different from the regular API endpoint)
      upload_connection = Faraday.new("https://www.googleapis.com/upload/youtube/v3/") do |conn|
        conn.response :json, content_type: "application/json"
        conn.adapter :net_http
      end

      response = upload_connection.post do |req|
        req.path = "videos?uploadType=resumable&part=snippet,status"
        req.headers['Authorization'] = "Bearer #{client.access_token}"
        req.headers['X-Upload-Content-Length'] = file_size.to_s
        req.headers['X-Upload-Content-Type'] = 'video/*'
      end

      if response.status != 200
        handle_response(response)
        raise Error, "Failed to initialize resumable upload: #{response.status}"
      end

      # Get the session URI from the Location header
      location = response.headers["location"] || response.headers["Location"]
      raise Error, "No upload session URI received from server" unless location

      location
    end

    def upload_file_chunks(session_uri, file_obj, file_size, chunk_size)
      bytes_uploaded = 0

      while bytes_uploaded < file_size
        chunk = file_obj.read(chunk_size)
        chunk_end = bytes_uploaded + chunk.size - 1

        headers = {
          "Content-Type" => "application/octet-stream",
          "Content-Length" => chunk.size.to_s,
          "Content-Range" => "bytes #{bytes_uploaded}-#{chunk_end}/#{file_size}"
        }

        response = client.connection.put(session_uri, chunk, headers)

        bytes_uploaded += chunk.size

        case response.status
        when 200, 201
          # Upload complete, video object returned
          if response.body.is_a?(String)
            body = JSON.parse(response.body)
          else
            body = response.body
          end
          return Video.new(body)
        when 308
          # Resume incomplete, more data expected
          next
        else
          # Handle errors
          handle_response(response)
          raise Error, "Unexpected response status during upload: #{response.status}"
        end
      end

      raise Error, "Upload did not complete successfully"
    end

    def build_video_metadata(title, description, privacy_status, tags, category_id)
      metadata = {
        snippet: {
          title: title,
          description: description || ""
        },
        status: {
          privacyStatus: privacy_status
        }
      }

      metadata[:snippet][:tags] = tags if tags && !tags.empty?
      metadata[:snippet][:categoryId] = category_id.to_i if category_id

      # Return as hash
      metadata
    end

  end
end
