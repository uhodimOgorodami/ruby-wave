module Validation
  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, type, *args)
      @validations ||= []
      @validations << { attr: name, type: type, args: args }
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    protected

    def validate!
      self.class.validations.each do |validation|
        value = instance_variable_get("@#{validation[:attr]}")
        send("validate_#{validation[:type]}", validation[:attr], value, *validation[:args])
      end
      true
    end

    def validate_presence(_attr, value)
      raise 'не может быть пустым' if value.nil? || value.to_s.empty?
    end

    def validate_format(attr, value, args)
      raise "некорректный формат #{attr}" if value !~ args
    end

    def validate_type(attr, value, type)
      raise "атрибут #{attr} не принадлежит классу #{type}" unless value.class == type
    end
  end
end
