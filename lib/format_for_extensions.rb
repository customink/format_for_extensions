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
          FIELDS = FormatForExtensions::Config.values.keys
        rescue Exception => e
          puts "Exception loading config: #{e.inspect}"
          raise(RuntimeError, "Your format_for_extensions.yml file seems to be invalid, perhaps you've mis-keyed something?")
        end
        
        FIELDS.each do |field|
          define_method("validates_#{field}_for") do |*attr_names|
            configuration = {:with => self.send("#{field}_regex"),
                             :message => self.send("#{field}_message")
                            }
                            
            # Add in user supplied options (yes, users can still override the regex and 
            # message with custom options)
            configuration.update(attr_names.extract_options!)

            # Leverage existing ActiveRecord::Validations...
            validates_format_of(attr_names, configuration)
          end
        end

        # Compose accessor methods for each of the specified field types
        # e.g. postal_code_regex, postal_code_message, etc...
        ['postal_code', 'email'].each do |field|
          define_method("#{field}_regex".to_sym) do
            regex = FormatForExtensions::Config.values[field]['regex']
            raise(ArgumentError, "Your format_for_extensions.yml is missing the mapping '#{field}: regex:'") if regex.blank?
            
            return eval(regex)
          end

          define_method("#{field}_message".to_sym) do
            message = FormatForExtensions::Config.values[field]['message']
            raise(ArgumentError, "Your format_for_extensions.yml is missing the mapping '#{field}: message:'") if message.blank?
            
            return message
          end
        end
      end
    end
  end
end

ActiveRecord::Base.class_eval do
  include FormatForExtensions::ActiveRecord::Validations
end