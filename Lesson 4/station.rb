# === Station ===

class Station
  attr_reader :name
  attr_accessor :train_list

  def initialize(name)
    @name = name
    @train_list = []
  end

  def arrive(train)
    @train_list << train unless @train_list.include?(train)
  end

  def train_list_by_type(type)
    if type == 'cargo'
      @train_list.find_all { |type| type == 'cargo' }
    elsif type == 'passenger'
      @train_list.find_all { |type| type == 'passenger' }
    else
      @train_list
    end
  end

  def departure(train)
    @train_list.delete(train) if @train_list.include?(train)
  end
end
