require 'ostruct'

module Squid
  # Provides an object to store global configuration settings.
  #
  # This class is typically not used directly, but by calling
  # {Squid::Config#configure Squid.configure}, which creates and updates a
  # single instance of {Squid::Configuration}.
  #
  # @example Set the default height for Squid graphs:
  #   Squid.configure do |config|
  #     config.height = 150
  #     config.steps = 4
  #   end
  #
  # @see Squid::Config for more examples.
  #
  # An alternative way to set global configuration settings is by storing
  # them in the following environment variables:
  #
  # * +SQUID_HEIGHT+ to store the default graph height
  #
  # In case both methods are used together,
  # {Squid::Config#configure Squid.configure} takes precedence.
  #
  # @example Set the default graph height:
  #   ENV['SQUID_HEIGHT'] =  '150'
  #   ENV['SQUID_GRIDLINES'] =  '4'
  #
  class Configuration < OpenStruct
    ATTRIBUTES = {
      baseline:     {default: 'true',    as: -> (value) { true? value }},
      border:       {default: 'false',   as: -> (value) { true? value }},
      chart:        {default: 'true',    as: -> (value) { true? value }},
      color:        {default: '2e578c',  as: -> (value) { value }},
      format:       {default: 'integer', as: -> (value) { value.to_sym }},
      legend:       {default: 'true',    as: -> (value) { true? value }},
      steps:        {default: '4',       as: -> (value) { value.to_i }},
      height:       {default: '250',     as: -> (value) { value.to_f }},
      ticks:        {default: 'true',    as: -> (value) { true? value }},
      value_labels: {default: 'false',   as: -> (value) { true? value }},
    }

    attr_accessor *ATTRIBUTES.keys

    # Initialize the global configuration settings.
    def initialize
      ATTRIBUTES.each do |key, options|
        var = "squid_#{key}".upcase
        value = ENV.fetch var, options[:default]
        public_send "#{key}=", options[:as].call(value)
      end
    end

  private

    def self.true?(value)
      value.in? %w(1 t T true TRUE)
    end
  end
end
