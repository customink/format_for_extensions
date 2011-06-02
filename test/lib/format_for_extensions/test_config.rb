require 'helper'
require 'format_for_extensions/config'

class TestConfig < Test::Unit::TestCase
  should "load the default yml file if an override has not been specified" do
    config = FormatForExtensions::Config.values
    
    assert_equal "is invalid.  Valid formats: 94105-0011 or 94105 or T2X 1V4 or T2X1V4", config['postal_code']['message']
    assert_equal "is invalid.  The address should be in a format similar to 'user@example.com'.", config['email']['message']
  end
  
end
