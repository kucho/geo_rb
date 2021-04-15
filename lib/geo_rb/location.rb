require "forwardable"

module GeoRb
  # Contains a parsed geocoder response. Can be iterated over as
  # ``(location<String>, (latitude<float>, longitude<Float))``.
  #  Or one can access the properties ``address``, ``latitude``,
  #  ``longitude``, or ``raw``. The last
  #  is a dictionary of the geocoder's response for this item.
  class Location
    extend Forwardable
    def_delegators :point, :latitude, :longitude, :altitude
    attr_reader :address, :point, :raw

    def self.lookup(text, adapter: GeoRb::GeoCoders::Nominatim, **options)
      adapter.new.geocode(text, **options)
    end

    def initialize(address:, raw:, point: Point)
      @address = address
      @point = point
      @raw = raw
    end

    def distance_to(location)
      Distance.new(self, location)
    end

    def to_h
      {address: address}.merge(point.to_h)
    end
  end
end
