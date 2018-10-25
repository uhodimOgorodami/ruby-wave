class CargoWagon < Wagon
  attr_reader :number, :type, :made, :all_volume

  validate :num, :presence

  def initialize(number, all_volume)
    super
    @type = :cargo
    @all_volume = all_volume.to_i
  end

  def cargo_load(volume)
    if !@all_volume.zero?
      @free_volume = @all_volume - volume
      @occupied_volume = @all_volume - @free_volume
    else
      puts 'некуда загружать'
    end
  end

  def free_volume
    if !@free_volume.nil?
      puts "текущий свободный объем составляет: #{@free_volume}"
    else
      puts "объем вагона ничем не занят: #{@all_volume}"
    end
  end

  def occupied_volume
    if !@occupied_volume.nil?
      puts "текуший занятый объем составляет: #{@occupied_volume}"
    else
      puts "объем вагона ничем не занят: #{@all_volume}"
    end
  end
end
