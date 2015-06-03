class ModelConfiguration
  class FactoryAttributeDeclaration

    def self.for(attribute)
      if attribute.is_association?
        if (class_name = attribute.properties[:class_name]).present?
          # association :delivery_address, factory: :address
          "association #{attribute.as_symbol}, factory: :#{class_name.underscore}"
        else
          # association :address
          "association #{attribute.as_symbol}"
        end
      else
        "#{attribute.name} { #{data_for(attribute)} }"
      end
    end

  private

    def self.data_for(attribute)
      case attribute.type
      when "datetime", "date"
        date_data(attribute)
      when "string"
        string_data(attribute)
      else
        raise(ArgumentError, "Unsupported Type: #{attribute.type}")
      end
    end

  # Specific Types

    def self.date_data(attribute)
      "5.days.from_now"
    end

    def self.string_data(attribute)
      if attribute.name =~ /name/
        "FFaker::Name.name"
      elsif attribute.name =~ /email/
        "FFaker::Internet.email"
      # Guessing since this is a string, it would be phone_number of mobile_number
      elsif attribute.name =~ /number/
        "FFaker::PhoneNumberAU.phone_number"
      else
        "FFaker::Company.bs"
      end
    end

  end
end