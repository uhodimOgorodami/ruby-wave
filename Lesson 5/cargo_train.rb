class CargoTrain < Train

  def initialize(number)
    super
    @type = :cargo
  end

  def loading
    puts "Погрузка ..."
  end
end
