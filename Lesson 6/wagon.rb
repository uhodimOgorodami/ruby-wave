class Wagon
  include Made
  include Validation
  attr_accessor :type
                :number
                :made
  WAGON_FORMAT = /^[1-9]{2}$/

  def initialize(number)
    @wagon_number = number
    validate!
  end

  protected

  def validate!
    raise "Некорректный номер вагона" if @wagon_number.to_s !~ WAGON_FORMAT
    true
  end

end
