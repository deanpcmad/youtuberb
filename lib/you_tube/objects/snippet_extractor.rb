module YouTube
  module SnippetExtractor
    private

    def extract_snippet(snippet)
      return unless snippet

      self.title = snippet["title"]
      self.description = snippet["description"]
      self.published_at = snippet["publishedAt"]
      self.channel_id = snippet["channelId"] if snippet["channelId"]
      extract_thumbnails(snippet)
    end
  end
end
