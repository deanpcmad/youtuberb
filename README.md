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

```ruby
@client = YouTube::Client.new(api_key: "", access_token: "")
```

### Videos

```ruby
@client.videos.get_by_id(user_id: 141981764)
```

### Playlists

```ruby
@client.playlists.list
@client.playlists.create(title: "My Playlist")
@client.playlists.delete(id: "playlist_id")
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deanpcmad/youtuberb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
