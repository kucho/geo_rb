require "rspec"
require "geo_rb"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect # disables `should`
  end
end
