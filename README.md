# geo_rb

geo_rb makes it easy for Ruby developers to locate the coordinates of addresses, cities, countries, and landmarks across the globe using third-party geocoders.

It is heavily inspired by [geopy](https://github.com/geopy/geopy).

## Install

    gem install geo_rb

## Usage

### Address lookup
```ruby
plaza = GeoRb::Location.lookup("Plaza San Martin, Lima, Peru")
palacio = GeoRb::Location.lookup("Palacio de Justicia, Lima, Peru")
plaza.distance_to(palacio).km # => 0.6649563608870949
palacio.distance_to(plaza).km # => 0.6649563608870949
```
