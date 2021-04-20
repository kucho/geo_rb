require "bigdecimal/util"
require "concurrent"
require "geodesic_wgs84"

module GeoRb
  class Distance
    EARTH_RADIUS = 6_371.0088

    attr_reader :kilometers, :meters
    alias_method :km, :kilometers
    alias_method :m, :meters

    def self.between(*addresses, adapter: GeoRb::GeoCoders::Nominatim)
      return new if addresses.size == 1

      requests = addresses.map do |address|
        Concurrent::Promises.future(address) { |a| adapter.new.geocode(a) }
      end

      locations = Concurrent::Promises.zip(*requests).value!
      new(*locations)
    end

    def initialize(*locations)
      @meters = case locations.size
      when 0..1
        0
      else
        locations.each_cons(2).reduce(0) do |distance, pair|
          a, b = sanitize_location(pair.first), sanitize_location(pair.last)
          distance + measure(a, b)
        end
      end
      @kilometers = @meters.to_d / 1_000
    end

    def ensure_same_altitude(a, b)
      raise LatitudeMismatch if (a.altitude - b.altitude).abs > 1e-6
    end

    def measure(a, b)
      ensure_same_altitude(a, b)
      Wgs84.new.distance(a.latitude, a.longitude, b.latitude, b.longitude).first.to_d
    end

    private

    def sanitize_location(location)
      case location
      when Location, Point
        location
      when Array
        case location.size
        when 2..3
          Point.new(*location.map(&:to_f))
        else
          raise CoordsError
        end
      when String
        points = location.split(",")
        raise CoordsError unless [2, 3].include?(points.size)

        Point.new(*points.map(&:to_f))
      else
        raise LocationError
      end
    end
  end

  class LatitudeMismatch < ArgumentError
    def message
      "Calculating distance between points with different altitudes is not supported"
    end
  end

  class LocationError < ArgumentError
    def message
      "Invalid locations"
    end
  end

  class CoordsError < ArgumentError
    def message
      "In order to calculate the distance between points it is necessary to have at least latitude and longitude"
    end
  end
end
