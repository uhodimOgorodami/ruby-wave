module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end


  module ClassMethods
    attr_accessor :instances

    private
    def self.instances_count
      @@instances += 1
    end
  end

  module InstanceMethods

    private
    def register_instance
      self.class.send(:instances_count)
    end
  end
end
