# rubocop:disable Documentation
module Serverspec
  module Type
    class PageReturns < Base
      def initialize(url = 'http://localhost:80/', host = 'localhost', ssl = false)
        @url = url
        @host = host
        @ssl = ssl
      end

      def content
        uri = URI.parse(@url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 70
        if @ssl
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        req = Net::HTTP::Get.new(uri.request_uri)
        req.initialize_http_header('Host' => @host)
        http.request(req).body
      end

      def to_s
        'Page returns: ' + @url
      end
    end

    def page_returns(url = 'http://localhost:80/', host = 'localhost', ssl = false)
      PageReturns.new(url, host, ssl)
    end
  end
end

include Serverspec::Type
# rubocop:enable Documentation
