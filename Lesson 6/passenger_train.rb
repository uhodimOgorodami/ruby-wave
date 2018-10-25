require_relative 'modules/validation'

class PassengerTrain < Train
  include Validation
  def initialize(number)
    super
    @type = :passenger
  end
end
