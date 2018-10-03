module Made
  
  include Validation
  attr_accessor :made

  def made=(made)
    @made = made
    raise "Название не может быть пустым, попробуйте снова." if made.empty?
  end

end
