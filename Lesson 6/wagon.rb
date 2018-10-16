class Wagon
  include Made
  include Validation
  attr_accessor :type, :number, :made
  WAGON_FORMAT = /^[1-9]{2}$/

  def initialize(number, *)
    @number = number
    validate!
  end

  protected

  def validate!
    error_message = 'Некорректный номер вагона'
    raise error_message if @number.to_s !~ WAGON_FORMAT

    true
  end
end
