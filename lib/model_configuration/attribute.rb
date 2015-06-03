require_relative "factory_attribute_declaration.rb"

class ModelConfiguration
  class Attribute
    attr_reader :name, :properties

    def initialize(name, properties)
      @name = name
      @properties = properties
    end

    # some_thing -> "Some thing"
    def capitalized
      name.titleize.capitalize
    end

    # some_thing -> ":some_thing_id"
    # some_thing -> ":some_thing"
    def as_field_name
      if is_association?
        ":#{name}_id"
      else
        as_symbol
      end
    end

    def as_symbol
      ":#{name}"
    end

    def sortable?
      properties[:sortable]
    end

    def type
      properties[:type]
    end

  # Views

    def as_input
      input_declaration = as_field_name
      if is_association?
        # Should convert attribute :state into:
        # f.input :state_id, collection: State.all
        collection_class = properties[:class_name].present? ? properties[:class_name] : name.camelize
        input_declaration = "#{as_field_name}, collection: #{collection_class}.all"
      end
      "f.input #{input_declaration}"
    end

  # Models

    def association_implementation
      without_options = case properties[:type]
      when "belongs_to"
        "belongs_to #{as_symbol}"
      when "has_one"
        "has_one #{as_symbol}"
      when "has_many"
        "has_many #{as_symbol}"
      when "has_and_belongs_to_many"
        "has_and_belongs_to_many #{as_symbol}"
      end

      options = nil
      if properties[:class_name].present?
        options = "class_name: #{properties[:class_name]}"
      end
      with_options = [without_options, options].join(", ")
    end

    def is_association?
      properties[:type].to_s.in?([
        "belongs_to",
        "has_one",
        "has_many",
        "has_and_belongs_to_many"
      ])
    end

    def validations
      @validations ||= (properties[:validates] || []).collect do |key, args|
        ModelConfiguration::Validation.new(self, key, args)
      end
    end

    def validation_implementation
      validation_string = validations.collect(&:implementation).join(", ")
      "validates #{as_symbol}, #{validation_string}"
    end

    def validation_required?
      validations.any?
    end

  # Factories

    def factory_declaration
      ModelConfiguration::FactoryAttributeDeclaration.for(self)
    end

  # Migrations

    def as_migration_component
      index_component = nil
      # Can be 'uniq' or 'index'
      index_component = (properties[:index] || "index") if requires_index?
      [name, properties[:type], index_component].compact.join(":")
    end

  private

    def requires_index?
      properties[:index] || properties[:searchable] || properties[:sortable]
    end

  end
end