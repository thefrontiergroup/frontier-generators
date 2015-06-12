# Frontier Generators

Use the Frontier Generators on the [Frontier Template](https://github.com/thefrontiergroup/rails-template) to quickly spin up CRUD interfaces.

You can create a YAML specification of your entities that you can pass directly to any of the generators. EG:

```
rails g frontier_scaffold /path/to/yml
```

Frontier Generators also provides unit and feature specs where applicable.

## Attributes

You can specify which attributes should be on your model thusly:

```yaml
model_name:
  attributes:
    attribute_name:
      # Set to false if you don't want this attribute to be represented on the index
      # Note: This is true by default
      show_on_index: false

      # Choose one of the following
      type: datetime
      type: date
      type: time
      type: decimal
      type: integer
      type: string

      # enum should also provide enum_options
      type: enum
      enum_options: [:admin, :public]
```

## Associations

You can add validations the same way you would add an attribute. Currently supported:

EG:

```yaml
model_name:
  attributes:
    attribute_name:
      type: "belongs_to"
      # Optional - this will use this model in factories and in the model
      class_name: "User"
```

## Validations

You can add validations to your models. This will provide implementations and specs when generated.

Frontier currently supports the following validations:

```yaml
model_name:
  attributes:
    attribute_name:
      validates:
        numericality: true
        # Or, numericality can use one or more args
        numericality:
          greater_than: 0
          greater_than_or_equal_to: 0
          equal_to: 0
          less_than: 100
          less_than_or_equal_to: 100
        presence: true
        uniqueness: true
```