require_relative "../../model_configuration/model_configuration"

class FrontierModelGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  attr_accessor :model_configuration

  def scaffold
    self.model_configuration = ModelConfiguration.new(ARGV[0])

    unless model_configuration.skip_seeds
      # Generate seed files for the model
      generate("frontier_seed", ARGV[0])
    end

    # EG: CreateDriver name:string contact_number:string
    generate("migration", "Create#{model_configuration.as_constant} #{model_attributes_with_deleted_at}")

    template("model.rb", "app/models/#{model_configuration.model_name}.rb")
    template("model_spec.rb", "spec/models/#{model_configuration.model_name}_spec.rb")
    template("factory.rb", "spec/factories/#{model_configuration.model_name.pluralize}.rb")
  end

private

  # We include deleted_at for paranoia (soft delete)
  def model_attributes_with_deleted_at
    default_columns = ["created_at:datetime", "updated_at:datetime"]
    default_columns << "deleted_at:datetime:index" if model_configuration.soft_delete
    (model_attributes + default_columns).join(" ")
  end

  # Should be in the format attribute_name:type attribute_name:type
  # EG: name:string date_of_birth:datetime
  def model_attributes
    model_configuration.attributes.collect(&:as_migration_component)
  end

end
