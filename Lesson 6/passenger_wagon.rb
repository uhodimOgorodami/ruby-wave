class PassengerWagon < Wagon
attr_reader   :number
              :type
              :made
              :passenger_seats

  def initialize(number, seats)
    super
    @type = :passenger
    @passenger_seats = seats
  end

  def take_seat(seat)
    unless @passenger_seats == 0
      @occupied_seats = @passenger_seats - seat
      @free_seats = @passenger_seats
    else
      puts 'свободных мест не осталось'
    end
  end

  def occupied_seats
    unless @occupied_seats.nil?
      print "занятых мест: #{@occupied_seats}"
    else
      print "все места свободны"
    end
  end

  def free_seats
    unless @free_seats.nil?
      print "свободных мест: #{@free_seats}"
    else
      print "сейчас свободно #{@passenger_seats} мест(а)"
    end
  end

end
