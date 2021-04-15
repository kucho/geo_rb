lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "geo_rb/version"

Gem::Specification.new do |spec|
  spec.name = "geo_rb"
  spec.required_ruby_version = ">= 2.4.0"
  spec.homepage = "https://github.com/kucho/geo_rb"
  spec.version = GeoRb::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = "Client for geolocation services"
  spec.description = "geo_rb makes it easy for Ruby developers to locate the coordinates of addresses, cities, countries, and landmarks across the globe using third-party geocoders."
  spec.authors = ["Victor Rodriguez"]
  spec.email = "victor.rodriguez.guriz@gmail.com"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.metadata = {
    "source_code_uri" => "https://github.com/kucho/geo_rb",
    "changelog_uri" => "https://github.com/kucho/geo_rb/blob/master/CHANGELOG.md"
  }

  spec.add_runtime_dependency("geographiclib", "~> 0.0.2")

  spec.add_development_dependency("bundler", "~> 2.2")
  spec.add_development_dependency("standardrb", "~> 1.0")
  spec.add_development_dependency("rspec", "~> 3.10")
end
