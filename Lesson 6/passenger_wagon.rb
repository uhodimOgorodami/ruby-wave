class PassengerWagon < Wagon
attr_reader   :number
              :type
              :made
              :passenger_seats

  def initialize(number, seats)
    super
    @type = :passenger
    @passenger_seats = seats.to_i
  end

  def take_seat(seat)
    unless @passenger_seats == 0
      @free_seats = @passenger_seats - seat
      @occupied_seats = @passenger_seats - @free_seats
    else
      puts 'свободных мест не осталось'
    end
  end

  def occupied_seats
    unless @occupied_seats.nil?
      puts "занятых мест: #{@occupied_seats}"
    else
      puts "все места свободны"
    end
  end

  def free_seats
    unless @free_seats.nil?
      puts "свободных мест: #{@free_seats}"
    else
      puts "сейчас свободно #{@passenger_seats} мест(а)"
    end
  end

end
