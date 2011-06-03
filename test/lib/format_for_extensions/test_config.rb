require 'helper'
require 'format_for_extensions/config'

class TestConfig < Test::Unit::TestCase
  context "When loading the default yml file" do
    context "and inspecting field values" do
      setup {@config = FormatForExtensions::Config.values}
      should "return the postal code message" do
        assert_equal "is invalid.  Valid formats: 94105-0011 or 94105 or T2X 1V4 or T2X1V4", @config['postal_code']['message']
      end
      
      should "return the email message" do
        assert_equal "is invalid.  The address should be in a format similar to 'user@example.com'.", @config['email']['message']
      end
    end
    
    should "return the configured fields" do
      fields = FormatForExtensions::Config.fields
      ['postal_code', 'email'].each do |field|
        assert fields.include?(field)
      end
    end
    
    should "return the configured properties" do
      properties = FormatForExtensions::Config.properties
      ['regexp', 'message'].each do |property|
        assert properties.include?(property)
      end
    end
  end
  
end
