require "faraday"
require "json"

require_relative "you_tube/version"

module YouTube

  autoload :Client, "you_tube/client"
  autoload :Collection, "you_tube/collection"
  autoload :Error, "you_tube/error"
  autoload :Resource, "you_tube/resource"
  autoload :Object, "you_tube/object"

  autoload :ChannelsResource, "you_tube/resources/channels"
  autoload :VideosResource, "you_tube/resources/videos"
  autoload :PlaylistsResource, "you_tube/resources/playlists"
  autoload :PlaylistItemsResource, "you_tube/resources/playlist_items"
  autoload :SearchResource, "you_tube/resources/search"
  autoload :LiveBroadcastsResource, "you_tube/resources/live_broadcasts"

  autoload :Channel, "you_tube/objects/channel"
  autoload :Video, "you_tube/objects/video"
  autoload :Playlist, "you_tube/objects/playlist"
  autoload :PlaylistItem, "you_tube/objects/playlist_item"
  autoload :SearchResult, "you_tube/objects/search_result"
  autoload :LiveBroadcast, "you_tube/objects/live_broadcast"

end
