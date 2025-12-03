module YouTube
  module StatusExtractor
    private

    def extract_status(status)
      return unless status

      self.privacy_status = status["privacyStatus"]
      self.upload_status = status["uploadStatus"] if status["uploadStatus"]
      self.long_uploads_status = status["longUploadsStatus"] if status["longUploadsStatus"]
    end
  end
end
