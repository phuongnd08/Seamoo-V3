module Services
  module PubSub
    class << self
      def server_url
        "#{SiteSettings.pubsub.server}/#{SiteSettings.pubsub.mount_point}"
      end

      def server_uri
        @server_uri ||= URI.parse(server_url)
      end

      def client
        Faye::Client.new(server_url)
      end

      def publish(channel, data)
        Net::HTTP.post_form(server_uri, :message => JSON.dump(:channel => channel, :data => data))
      end
    end
  end
end
