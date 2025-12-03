module YouTube
  class LiveBroadcast < Object
    include ThumbnailExtractor
    include SnippetExtractor
    include StatusExtractor

    def initialize(options = {})
      super options

      extract_snippet(options["snippet"])
      extract_status(options["status"])
    end

  end
end
