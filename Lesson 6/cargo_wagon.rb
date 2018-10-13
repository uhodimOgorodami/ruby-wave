require_relative 'validation'
require_relative 'made'
require_relative 'wagon'

class CargoWagon < Wagon

  attr_reader   :number
                :type
                :made
                :all_volume

  def initialize(number, all_volume)
    super
    @type = :cargo
    @all_volume = all_volume
  end

  def load(volume)
    unless @all_volume == 0
      @free_volume = @all_volume - volume
      @occupied_volume = @all_volume - @free_volume
    else
      puts 'некуда загружать'
    end
  end

  def free_volume
    unless @free_volume.nil?
      puts "текущий свободный объем составляет: #{@free_volume}"
    else
      puts "объем вагона ничем не занят: #{@all_volume}"
    end
  end

  def occupied_volume
    unless @occupied_volume.nil?
      puts "текуший занятый объем составляет: #{@occupied_volume}"
    else
      puts "объем вагона ничем не занят: #{@all_volume}"
    end
  end

end
