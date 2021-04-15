require "json"
require "net/http"

module GeoRb
  module GeoCoders
    class Base
      def call(url, post_process_proc = nil)
        GeoRb.logger.debug data = parse_payload(fetch_data(URI(url)))
        post_process_proc ? post_process_proc.call(data) : data
      end

      private

      def fetch_data(url)
        response = Net::HTTP.get(url)
        JSON.parse(response).map { |result| result.transform_keys(&:to_sym) }
      end

      def format_bounding_box(a, b)
        lat1 = [a.latitude, b.latitude].min
        lon1 = [a.longitude, b.longitude].min
        lat2 = [a.longitude, b.latitude].max
        lon2 = [a.longitude, b.longitude].max
        [lat1, lon1, lat2, lon2].join(",")
      end
    end
  end
end
