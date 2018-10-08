class PassengerWagon < Wagon
attr_reader :number
            :type
            :made
            
  def initialize(number)
    super
    @type = :passenger
  end

end
