module YouTube
  class Video < Object
    include ThumbnailExtractor

    def initialize(options = {})
      super options

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]
        self.channel_id   = options["snippet"]["channelId"]
        extract_thumbnails(options["snippet"])
      end

      # Is a Video is blocked in any countries?
      if options["contentDetails"]
        self.blocked = !options["contentDetails"]["regionRestriction"].nil?
        self.age_restricted = !options["contentDetails"]["contentRating"].nil? && options["contentDetails"]["contentRating"]["ytRating"] == "ytAgeRestricted"
      end

      if options["liveStreamingDetails"]
        self.live_stream = !options["liveStreamingDetails"]["actualStartTime"].nil? && options["liveStreamingDetails"]["actualStartTime"] != ""
      else
        self.live_stream = false
      end

      if options["status"]
        self.upload_status  = options["status"]["uploadStatus"]
        self.privacy_status = options["status"]["privacyStatus"]
      end
    end

  end
end
