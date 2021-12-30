require "faraday"
require "faraday_middleware"
require "json"

require_relative "you_tube/version"

module YouTube

  autoload :Client, "you_tube/client"
  autoload :Collection, "you_tube/collection"
  autoload :Error, "you_tube/error"
  autoload :Resource, "you_tube/resource"
  autoload :Object, "you_tube/object"

  autoload :ActivitiesResource, "you_tube/resources/activities"
  autoload :VideosResource, "you_tube/resources/videos"
  autoload :PlaylistsResource, "you_tube/resources/playlists"

  autoload :Activity, "you_tube/objects/activity"
  autoload :Video, "you_tube/objects/video"
  autoload :Playlist, "you_tube/objects/playlist"

end
