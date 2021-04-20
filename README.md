# geo_rb

geo_rb makes it easy for Ruby developers to locate the coordinates of addresses, cities, countries, and landmarks across the globe using third-party geocoders.

It is heavily inspired by [geopy](https://github.com/geopy/geopy).

## Install

    gem install geo_rb

## Usage

### Location lookup
Basic example: 
```ruby
GeoRb::Location.lookup("Plaza San Martin, Lima, Peru")
# [#<GeoRb::Location:0x000000015b3a9fb0 @address="Plaza San Martín, Avenida Nicolás de Pierola, Lima, LIMA 01, Perú", @point=#<GeoRb::Point:0x000000014b0769e8 @latitude=-12.05165965, @longitude=-77.03460482707533, @altitude=0.0>, @raw={:place_id=>101994693, :licence=>"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright", :osm_type=>"way", :osm_id=>44364378, :boundingbox=>["-12.0523471", "-12.050949", "-77.035317", "-77.0338948"], :display_name=>"Plaza San Martín, Avenida Nicolás de Pierola, Lima, LIMA 01, Perú", :class=>"tourism", :type=>"attraction", :importance=>0.631409003314806, :icon=>"https://nominatim.openstreetmap.org/ui/mapicons//poi_point_of_interest.p.20.png", :latitude=>-12.05165965, :longitude=>-77.03460482707533}>]
```

It is possible to specify search options (WIP doc).

### Distance from A to B
```ruby
plaza = GeoRb::Location.lookup("Plaza San Martin, Lima, Peru")
palacio = GeoRb::Location.lookup("Palacio de Justicia, Lima, Peru")
plaza.distance_to(palacio).km # => 0.6649563608870949
palacio.distance_to(plaza).km # => 0.6649563608870949
```

### Distance between multiple points
`.between` makes concurrent requests. However, it is not possible to specify options for each individual search.

```ruby
GeoRb::Distance.between("Plaza San Martin, Lima", 
                        "Palacio de Justicia, Lima", 
                        "Jockey Plaza, Lima").km
# => 0.7775e1
```