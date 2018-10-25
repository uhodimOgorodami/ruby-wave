module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_history = "#{name}_history".to_sym
        var_storage = []
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          var_storage << value
        end

        define_method(var_history) { var_storage }
      end
    end

    def strong_attr_accessor(var_name, var_class)
      var = "@#{var_name}".to_sym
      define_method(var_name) { instance_variable_get(var) }
      define_method("#{var_name}=".to_sym) do |value|
        unless value.instace_of?(var_class)
          raise TypeError, "#{var_name} не является экземпляром класса #{var_class}!"
        end

        instance_variable_set(var, value)
      end
    end
  end
end
