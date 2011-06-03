require 'active_record'

module FormatForExtensions
  module ActiveRecord
    module Validations
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        require 'format_for_extensions/config'
        
        begin
          FIELDS = FormatForExtensions::Config.fields
          PROPERTIES = FormatForExtensions::Config.properties
        rescue Exception => e
          puts "Exception loading config: #{e.inspect}"
          raise(RuntimeError, "Your format_for_extensions.yml file seems to be invalid, perhaps you've mis-keyed something?")
        end
        
        FIELDS.each do |field|
          define_method("validates_#{field}_for") do |*attr_names|
            configuration = {:with => self.send("#{field}_regexp"),
                             :message => self.send("#{field}_message")
                            }
                            
            # Add in user supplied options (yes, users can still override the regexp and 
            # message with custom options)
            configuration.update(attr_names.extract_options!)

            # Leverage existing ActiveRecord::Validations...
            validates_format_of(attr_names, configuration)
          end
        end

        # Compose accessor methods for each of the specified field types
        # e.g. postal_code_regexp, postal_code_message, etc...
        FIELDS.each do |field|
          PROPERTIES.each do |property|
            define_method("#{field}_#{property}".to_sym) do
              value = FormatForExtensions::Config.values[field][property]
              
              raise(ArgumentError, "Your format_for_extensions.yml is missing the mapping '#{property}' for '#{field}'") if value.blank?
            
              return property == 'regexp' ? Regexp.new(value) : value
            end
          end
        end
        
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include FormatForExtensions::ActiveRecord::Validations
end