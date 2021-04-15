module GeoRb
  class Point
    attr_reader :latitude, :longitude, :altitude

    def initialize(latitude = 0.0, longitude = 0.0, altitude = 0.0)
      @latitude, @longitude, @altitude = normalize_coordinates(latitude, longitude, altitude)
    end

    def to_h
      instance_variables.map do |var|
        [var[1..].to_sym, instance_variable_get(var)]
      end.to_h
    end

    private

    # Normalize angle `x` to be within `[-limit; limit)` range.
    def normalize_angle(x, limit)
      double_limit = limit * 2.0
      modulo = x % double_limit
      return modulo + double_limit if modulo < -limit
      return modulo - double_limit if modulo >= limit

      modulo
    end

    def normalize_coordinates(latitude, longitude, altitude)
      latitude = Float(latitude)
      longitude = Float(longitude)
      altitude = Float(altitude)

      unless [latitude, longitude, altitude].all?(&:finite?)
        raise "Point coordinates must be finite. #{latitude}, #{longitude} #{altitude} has been passed as coordinates."
      end

      raise "Latitude must be in the [-90; 90] range." if latitude.abs > 90

      longitude = normalize_angle(longitude, 180.0) if longitude.abs > 180
      [latitude, longitude, altitude]
    end
  end
end
