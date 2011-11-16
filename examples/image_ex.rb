require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  # Create a new window with an bug image inside it
  def initialize
    super(300, 300)
    @image = Rubydraw::Image.new("media/bug.png")
    whenever Rubydraw::Events::QuitRequest do
      close
    end
    whenever Rubydraw::Events::MouseMove do |event|
      @mouse_position = event.position
    end
  end

  def mouse_moved(event)
    new_position = event.position
    puts "Mouse moved! New position: #{new_position.x}, #{new_position.y}"
  end

  def tick
    @image.draw(self, @mouse_position) #if @focused
  end
end

w = MyWindow.new
w.open