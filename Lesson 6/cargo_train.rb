require_relative 'modules/validation'

class CargoTrain < Train
  include Validation
  
  def initialize(number)
    super
    @type = :cargo
  end
end
