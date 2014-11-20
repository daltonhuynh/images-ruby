require "faraday"
require "faraday_middleware"

module Images
  class Client
    DEFAULT_HEADERS = {
      'Accept' => "application/vnd.dhimages+json; version=1"
    }
    IMAGES_PATH = "/api/images"

    attr_reader :api_key, :host

    def initialize(api_key, host)
      @api_key = api_key
      @host = host
    end

    def images(page = 1)
      client.get "#{IMAGES_PATH}?page=#{page}"
    end

    def get_image(uuid)
      client.get "#{IMAGES_PATH}/#{uuid}"
    end

    def create_image(width, height)
      client.post do |req|
        req.url IMAGES_PATH
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          :width  => width,
          :height => height
        }.to_json
      end.body
    end

    def destroy_image(uuid)
      client.delete "#{IMAGES_PATH}/#{uuid}"
    end

    private

      def client
        @client ||= begin
          Faraday.new(:url => host, :headers => DEFAULT_HEADERS) do |conn|
            conn.request :json
            conn.response :json, :content_type => /\bjson$/
            conn.adapter Faraday.default_adapter
            conn.basic_auth(api_key, nil)
          end
        end
      end

  end
end
