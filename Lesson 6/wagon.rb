require_relative 'modules/validation'
require_relative 'modules/made'

class Wagon
  include Made
  include Validation
  attr_accessor :type, :number, :made
  WAGON_FORMAT = /^[1-9]{2}$/

  validate :num, :presence
  validate :num, :format, WAGON_FORMAT
  validate :num, :type, String

  def initialize(num, *)
    @num = num
    validate!
  end
end
