# Shrine::Host::Url

[Shrine](https://github.com/janko-m/shrine) got many different plugins for almost everywhat you want. To change host url you can use [default_url_options](http://shrinerb.com/rdoc/classes/Shrine/Plugins/DefaultUrlOptions.html), but you can't change a host port with it. This plugin can help you change host and port for your image url. Read, please, description for details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shrine-host-url'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shrine-host-url

## Description

This plugin was developed to change minio host url and port for nginx static files caching.
I had some problems with caching when I've done like this [article](https://blog.minio.io/enterprise-grade-cloud-storage-with-nginx-plus-and-minio-e708fb4cb3e8). Someone had the same [problems](https://github.com/minio/minio/issues/4120). It was resolved like that:
1. You store file by direct link without nginx (or without nginx caching)
2. For reading from storage you need to use an another link with nginx caching
3. So, you need to change link in your RoR application

Example nginx config for storage

```
proxy_cache_path /var/cache/nginx/minio_cache levels=1:2 keys_zone=minio_cache:10m max_size=10m inactive=60m use_temp_path=off;

upstream minio_servers {
    server localhost:9000;
}

server {
  listen 80;
  server_name minio.dev;

  location / {
    proxy_cache minio_cache;
    add_header X-Cache-Status $upstream_cache_status;
    proxy_cache_revalidate on;
    proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    proxy_cache_lock on;
    proxy_ignore_headers Set-Cookie;
    proxy_cache_valid 1m;

    proxy_set_header Host $http_host;
    proxy_pass http://minio_servers;
  }
}
```

### Usage

We are using minio for storing images with [shrine](http://shrinerb.com).
Add to Gemfile

```ruby
gem 'shrine-fog'
gem 'fog-aws'
```

config/initializers/shrine.rb

```ruby
require 'shrine/storage/fog'
require 'fog/aws'
require 'image_processing/mini_magick'

minio = Fog::Storage.new(
  provider:              'AWS',
  aws_access_key_id:     '<key>',
  aws_secret_access_key: '<secret>',
  region:                'us-east-1',
  endpoint:              'http://localhost:9000/',
  path_style:             true,
)

Shrine.storages[:cache] = Shrine::Storage::Fog.new(
  connection: minio,
  directory: '<cache-directory>',
  public: true,
)

Shrine.storages[:store] = Shrine::Storage::Fog.new(
  connection: minio,
  directory: '<store-directory>',
  public: true,
)
```

Also, you need to add with the minio client corresponding directories and grant privileges.

app/models/image_uploader.rb

```ruby
class ImageUploader < Shrine
  <...>
  plugin :host_url, host: 'minio.dev', port: '8000'
end
```

For more options read, please, official shrine documentation

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/domido-com/shrine-host-url

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
