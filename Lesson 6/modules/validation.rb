module Validation
  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    VALIDATIONS = :@validations

    def validate(name, validator, *args)
      validations = instance_variable_get(VALIDATIONS)
      validations ||= {}
      validations[name] ||= {}
      validations[name][validator] = args
      instance_variable_set(VALIDATIONS, validations)
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
      validations = self.class.instance_variable_get(ClassMethods::VALIDATIONS)
      validations ||= {}
      validations.each do |name, validator|
        class_name = "#{self.class} #{name}"
        validator.each do |validation_type, args|
          attr_value = instance_variable_get("@#{name}".to_sym)
          send("#{validation_type}".to_sym, class_name, attr_value, args)
        end
      end
      true
    end

    def presence(name, value, *args)
      raise "#{name} не может быть пустым" if value.nil? || value.empty?
    end

    def format(name, value, regexp)
      raise "некорректный формат #{name}" if value !~ regexp[0]
    end

    def type(name, value, type)
      raise "атрибут #{name} не принадлежит классу #{type}" unless value.class == type
    end
  end
end
