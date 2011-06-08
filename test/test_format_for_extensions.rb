require 'helper'

class TestFormatForExtensions < Test::Unit::TestCase
  
  context "When loading FormatFor" do
    context "with valid configurations" do
      setup { @fields = FormatForExtensions::Config.values.keys }
    
      should "define extended validation methods for each configured field" do    
        @fields.each do |field|
          assert ActiveRecord::Base.respond_to?("validates_#{field}_for")
        end
      end
  
      should "define data accessor methods for each configured field" do
        @fields.each do |field|
          assert ActiveRecord::Base.respond_to?("#{field}_regexp")
          assert ActiveRecord::Base.respond_to?("#{field}_message")
        end
      end
  
      should "consider the postal code to be valid" do
        person = Person.new
        ['94105-0011', '94105', 'T2X 1V4', 'T2X1V4'].each do |postal_code|
          person.postal_code = postal_code
          assert person.valid?
        end
      end
  
      should "consider the postal code to be invalid" do
        person = Person.new
        ['9410', 'abc', '123-123'].each do |postal_code|
          person.postal_code = postal_code
          assert !person.valid?
        end
      end
    
      should "consider the email to be valid" do
        person = Person.new
        ['user@example.org', 'some.other.guy@yahoo.us.ca', 'a@b.com'].each do |email|
          person.email = email
          assert person.valid?
        end
      end
    
      should "consider the email to be invalid" do
        person = Person.new
        ['user@example', 'yahoo.us.ca', 'a.com'].each do |email|
          person.email = email
          assert !person.valid?
        end
      end
    end

    context "with invalid configurations " do
      # TODO:  How to test this?? Once active record and the gem are loaded, how do we unload/reload them with bad params?
    end
  end
end
