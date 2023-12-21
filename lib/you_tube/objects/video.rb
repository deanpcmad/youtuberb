module YouTube
  class Video < Object

    def initialize(options = {})
      super options

      if options["snippet"]
        self.title        = options["snippet"]["title"]
        self.description  = options["snippet"]["description"]
        self.published_at = options["snippet"]["publishedAt"]
        self.channel_id   = options["snippet"]["channelId"]

        if options["snippet"]["thumbnails"]
          thumb = options["snippet"]["thumbnails"]
          self.thumbnail_default  = thumb["default"]["url"]   if thumb["default"]
          self.thumbnail_medium   = thumb["medium"]["url"]    if thumb["medium"]
          self.thumbnail_high     = thumb["high"]["url"]      if thumb["high"]
          self.thumbnail_standard = thumb["standard"]["url"]  if thumb["standard"]
          self.thumbnail_maxres   = thumb["maxres"]["url"]    if thumb["maxres"]
        end
      end

      # Is a Video is blocked in any countries?
      if options["contentDetails"]
        self.blocked = !options["contentDetails"]["regionRestriction"].nil?
        self.age_restricted = !options["contentDetails"]["contentRating"].nil? && options["contentDetails"]["contentRating"]["ytRating"] == "ytAgeRestricted"
      end

      if options["liveStreamingDetails"]
        self.live_stream = options["liveStreamingDetails"]["actualStartTime"].present?
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
