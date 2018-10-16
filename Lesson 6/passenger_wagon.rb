class PassengerWagon < Wagon
  attr_reader :number,
              :type,
              :made,
              :passenger_seats

  def initialize(number, seats)
    super
    @type = :passenger
    @passenger_seats = seats.to_i
  end

  def take_seat(seat)
    if @passenger_seats.zero?
      puts 'свободных мест не осталось'
    else
      @free_seats = @passenger_seats - seat
      @occupied_seats = @passenger_seats - @free_seats
    end
  end

  def occupied_seats
    if @occupied_seats.nil?
      puts 'все места свободны'
    else
      puts "занятых мест: #{@occupied_seats}"
    end
  end

  def free_seats
    if @free_seats.nil?
      puts "сейчас свободно #{@passenger_seats} мест(а)"
    else
      puts "свободных мест: #{@free_seats}"
    end
  end
end
