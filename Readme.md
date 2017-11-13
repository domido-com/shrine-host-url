# Shrine::Host::Url

Change image host and port for [Shrine](https://github.com/janko-m/shrine)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shrine-host-url'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shrine-host-url

## Usage

```ruby
class ImageUploader < Shrine
  plugin :host_url, host: 'minio.dev', port: 3003
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/domido-com/shrine-host-url

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
