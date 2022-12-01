# frozen_string_literal: true

require 'bundler/setup'
require 'dry-validation'

DataSchema = Dry::Schema.JSON do
  required(:type).filled(:string, eql?: 'DataSegment')
  required(:data).filled(:string)
  required(:length).filled(:integer)
end

SnipSchema = Dry::Schema.JSON do
  required(:type).filled(:string, eql?: 'SnipSegment')
  required(:length).filled(:integer)
end

HighlightSchema = Dry::Schema.JSON do
  required(:type).filled(:string, eql?: 'HighlightSegment')
  required(:data).filled(:string)
  required(:length).filled(:integer)
end

# Schema
class MySchema < Dry::Validation::Contract
  json do
    required(:response).value(:array).each do
      schema(DataSchema | SnipSchema | HighlightSchema)
    end
  end
end

data = {
  'response' => [
    { 'type' => 'SnipSegment', 'length' => 394 },
    { 'type' => 'DataSegment', 'data' => 'PC9zY3JpcHQ+Cg==', 'length' => 10 },
    { 'type' => 'HighlightSegment', 'data' => 'PHNjcmlwdCB0eXBlPSJ0ZXh0L2phdmFzY3JpcHQiIHNyYz0iLi4vanMvY29uZmlnLmpzIj4=',
      'length' => 53 }
  ]
}

result = MySchema.new.call(data)

puts result.success?
pp result.errors(full: true).to_h

