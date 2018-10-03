class PassengerTrain < Train

  def initialize(number)
    super
    @type = :passenger
  end

  def add_passenger_wagon(passenger_wagon)
    if @type != 'passenger'
      puts "#{@type} данный тип вагонов не подходит для присоединения к пассажирскому поезду"
    elsif @speed.zero? && @type == 'passenger'
      @wagons += passenger_wagon
    else
      puts "Для прицепки вагона - необходимо остановить поезд, текущая скорость #{@speed}"
    end
  end
end
