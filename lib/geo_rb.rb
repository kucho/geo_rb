require "logger"

module GeoRb
  autoload :Distance, "geo_rb/distance"
  autoload :GeoCoders, "geo_rb/geo_coders"
  autoload :Location, "geo_rb/location"
  autoload :Point, "geo_rb/point"

  def self.logger
    @@logger ||= defined?(Rails) ? Rails.logger : Logger.new($stdout)
  end

  def self.logger=(logger)
    @@logger = logger
  end
end
