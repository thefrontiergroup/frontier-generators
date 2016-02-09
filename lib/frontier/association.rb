require_relative "attribute.rb"

class Frontier::Association < Frontier::Attribute

  include Frontier::ErrorReporter

  attr_reader :attributes, :form_type

  ID_REGEXP = /_id\z/

  def initialize(model_configuration, name, properties)
    super

    @attributes = parse_attributes(properties[:attributes] || [])
    @form_type  = parse_form_type(properties[:form_type])
  end

  def association_class
    if properties[:class_name].present?
      properties[:class_name]
    else
      without_id.camelize
    end
  end

  def as_factory_name
    ":#{association_class.underscore}"
  end

  # some_thing_id -> ":some_thing_id"
  # some_thing -> ":some_thing_id"
  def as_field_name
    if name =~ ID_REGEXP
      as_symbol
    else
      "#{as_symbol}_id"
    end
  end

  # some_thing_id -> ":some_thing"
  # some_thing -> ":some_thing"
  def as_symbol_without_id
    ":#{without_id}"
  end

  def is_association?
    true
  end

  # Models

  def association_implementation
    Frontier::Association::ModelImplementation.new(self).to_s
  end

  # Factories

  def as_factory_declaration
    Frontier::Association::FactoryDeclaration.new(self).to_s
  end

private

  def parse_attributes(attributes_properties)
    attributes_properties.collect do |name, attribute_or_association_properties|
      Frontier::Attribute::Factory.build_attribute_or_association(self, name, attribute_or_association_properties)
    end
  end

  def parse_form_type(form_type_property)
    case form_type_property.to_s
    when "inline", "select"
      form_type_property.to_s
    else
      report_error("Unknown form type: '#{form_type_property.to_s}', defaulting to 'select'")
      "select"
    end
  end

  def without_id
    name.sub(ID_REGEXP, "")
  end

end

require_relative "association/factory_declaration.rb"
require_relative "association/feature_spec_assignment.rb"
require_relative "association/model_implementation.rb"
