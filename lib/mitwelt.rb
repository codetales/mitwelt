# frozen_string_literal: true

require "dry-types"
require_relative "mitwelt/version"

class Mitwelt
  class Error < StandardError; end

  module Types
    include Dry.Types()
  end

  def self.fetch(key, type: :string, default: nil, required: false)
    new(key, type: type, default: default, required: required).fetch
  end

  def initialize(key, type:, default:, required:)
    @key = key
    @type = type
    @default = default.freeze
    @required = required
  end

  def fetch
    value = parsed_value
    raise(Error.new("#{@key} is required but not in ENV")) if @required && value.nil?
    value
  end

  def parsed_value
    parser[value]
  rescue Dry::Types::CoercionError => error
    raise Error.new "Unable to parse #{@key} from ENV as #{@type}: #{error.message}"
  end

  def parser
    {
      string: Types::Coercible::String,
      symbol: Types::Coercible::Symbol,
      integer: Types::Params::Integer,
      boolean: Types::Params::Bool,
      timestamp: Types::Params::Time,
      date: Types::Params::Date
    }[@type].optional
  end

  def value
    ENV[@key].nil? ? @default : ENV[@key]
  end
end
