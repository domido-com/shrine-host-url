class Shrine
  module Plugins
    module HostUrl
      def self.configure(uploader, options = {})
        uploader.opts[:host_url] = (uploader.opts[:host_url] || {}).merge(options)
      end

      module FileMethods
        def url(**options)
          new_uri(
            URI.parse(super),
            uploader.opts[:host_url][:host],
            uploader.opts[:host_url][:port]
          )
        end

        private

        def new_uri(uri, new_host, new_port)
          URI::HTTP.new(
            uri.scheme,
            uri.userinfo,
            new_host,
            new_port,
            uri.registry,
            uri.path,
            uri.opaque,
            uri.query,
            uri.fragment
          ).to_s
        end
      end
    end

    register_plugin(:host_url, HostUrl)
  end
end
