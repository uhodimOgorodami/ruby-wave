class CargoWagon < Wagon
  attr_reader :number
              :type
              :made

  def initialize(number)
    super
    @type = :cargo
  end

end
