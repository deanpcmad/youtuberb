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

Firstly you'll need to set an API Key and an Access Token. 
An Access Token will be an OAuth2 token generated after authentication. 

```ruby
@client = YouTube::Client.new(api_key: "", access_token: "")
```

### Videos

```ruby
# Get a single video
@client.videos.list(id: "abc123")

# Get multiple videos
@client.videos.list(id: "abc123,123abc")

# Liked videos for the currently authenticated user
@client.videos.liked

# Get a video owned by the current user. This retrieves extra information so will only work on videos owned by the current user.
@client.videos.retrieve(id: "abc123")
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/youtuberb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
