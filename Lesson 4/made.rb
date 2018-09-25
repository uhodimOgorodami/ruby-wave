module Made
  attr_accessor :made

  def made=(made)
    @made = made
    if made.empty?
      puts "Название не может быть пустым, попробуйте снова."
    end
  end
end
