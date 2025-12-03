module YouTube
  class Video < Object
    include ThumbnailExtractor
    include SnippetExtractor
    include StatusExtractor

    def initialize(options = {})
      super options

      extract_snippet(options["snippet"])

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

      extract_status(options["status"])
    end

  end
end
