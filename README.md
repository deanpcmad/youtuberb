# YouTubeRB

**This library is a work in progress**

YouTubeRB is a Ruby library for interacting with the YouTube Data v3 API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'youtuberb'
```

## Usage

### Set Client Details

Firstly you'll need to set an API Key. A user Access Token is required to access private data.
An Access Token will be an OAuth2 token generated after authentication.

```ruby
# To access public data, just an API Key is required
@client = YouTube::Client.new(api_key: "")

# Or to access data for a user, an Access Token is also required
@client = YouTube::Client.new(api_key: "", access_token: "")
```

### Channels

```ruby
# Get the Channel details of the currently authenticated user
@client.channels.mine

# Get a Channel by ID
@client.channels.retrieve(id: "channel_id")

# Get a Channel by username
@client.channels.retrieve(username: "username")

# Retrieve a list of videos for a Channel
# Returns a collection of SearchResult's because YouTube don't have a direct API to view all videos on a Channel
@client.channels.videos(id: "channel_id")
```

### Videos

```ruby
# Get a single video
@client.videos.list(id: "abc123")
# => #<YouTube::Video...

# Get multiple videos
@client.videos.list(ids: ["abc123", "123abc"])
# => #<YouTube::Collection...

# Liked videos for the currently authenticated user
@client.videos.liked
# => #<YouTube::Collection...

# Get a video owned by the current user. This retrieves extra information so will only work on videos owned by the current user.
@client.videos.retrieve(id: "abc123")
# => #<YouTube::Video...
```

#### Getting a list of Videos for a Channel

```ruby
# First, grab the Channel details
channel = @client.channels.retrieve(id: "channel_id")

# Then use the Playlist Items endpoint to get the Videos
@client.playlist_items.list playlist_id: channel.contentDetails.relatedPlaylists.uploads

# Or use the Search endpoint
@client.search.list channelId: channel.id
```

### Playlists

```ruby
# Playlists created by the authenticated user
@client.playlists.list

# Playlists for a Channel
@client.playlists.list(channel_id: "channel")

# Return a set number of results & use the page_token to select the next/previous page
@client.playlists.list(max_results: 5, page_token: "page_token")

@client.playlists.retrieve(id: "playlist_id")
@client.playlists.create(title: "My Playlist")
@client.playlists.update(id: "playlist_id", title: "My Playlist", privacy_status: "public")
@client.playlists.delete(id: "playlist_id")
```

### Playlist Items

```ruby
# Playlist Items for a Playlist
@client.playlist_items.list(playlist_id: "playlist_id")

@client.playlist_items.retrieve(id: "playlist_item_id")

# Add a video to a playlist
@client.playlist_items.create(playlist_id: "playlist_id", video_id: "video_id")

@client.playlist_items.update(id: "playlist_item_id", playlist_id: "playlist_id", video_id: "video_id")

@client.playlist_items.delete(id: "playlist_id")
```

### Search

For a full list of parameters, see the [YouTube API Docs](https://developers.google.com/youtube/v3/docs/search/list).

```ruby
# Search YouTube for a term
@client.search.list(q: "search term")

# Restrict the search to a channel
@client.search.list(channelId: "channel")

# Search a channel for videos only and ordered by date
@client.search.list(channelId: "channel", type: "video", order: "date")
```

### Live Broadcasts

```ruby
# Live Broadcasts for the currently authenticated user
@client.live_broadcasts.list

# Live Broadcasts by status
@client.live_broadcasts.list status: "active"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/youtuberb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
