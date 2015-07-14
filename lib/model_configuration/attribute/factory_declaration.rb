class ModelConfiguration::Attribute::FactoryDeclaration

  attr_reader :attribute

  def initialize(attribute)
    @attribute = attribute
  end

  def to_s
    "#{attribute.name} { #{data_for_attribute} }"
  end

private

  def data_for_attribute
    if constant = attribute.constants.first
      "#{constant.name}.sample"
    else
      attributes_based_on_type
    end
  end

  def attributes_based_on_type
    case attribute.type
    when "boolean"
      "[true, false].sample"
    when "datetime", "date"
      date_data
    when "decimal", "integer"
      number_data
    when "enum"
      enum_data
    when "string"
      string_data
    when "text"
      text_data
    else
      raise(ArgumentError, "Unsupported Type: #{attribute.type}")
    end
  end

# Specific Types

  def date_data
    "5.days.from_now"
  end

  def enum_data
    "#{attribute.model_configuration.as_constant}.#{attribute.name.pluralize}.keys.sample"
  end

  def number_data
    "rand(9999)"
  end

  def text_data
    "FFaker::Lorem.paragraph(5)"
  end

  def string_data
    if attribute.name =~ /city/
      "FFaker::AddressAU.city"
    elsif attribute.name =~ /email/
      "FFaker::Internet.email"
    elsif attribute.name =~ /line_1/
      "FFaker::AddressAU.street_address"
    elsif attribute.name =~ /line_2/
      "FFaker::AddressAU.secondary_address"
    elsif attribute.name =~ /name/
      "FFaker::Name.name"
    # Guessing since this is a string, it would be phone_number or mobile_number
    elsif attribute.name =~ /number/
      "FFaker::PhoneNumberAU.phone_number"
    elsif attribute.name =~ /postcode/ || attribute.name =~ /post_code/
      "FFaker::AddressAU.postcode"
    elsif attribute.name =~ /suburb/
      "FFaker::AddressAU.suburb"
    else
      "FFaker::Company.bs"
    end
  end

end