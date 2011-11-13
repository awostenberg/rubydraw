require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  # Create a new window with an bug image inside it
  def initialize(width, height)
    super(width, height)
    @image = Rubydraw::Image.new("media/bug.png")
    @max = 100

    register_action(Rubydraw::Events::MouseMove) {|event| @mouse_position = event.position}
    register_action(Rubydraw::Events::QuitRequest) {close}
  end

  def mouse_moved(event)
    new_position = event.position
    puts "Mouse moved! New position: #{new_position.x}, #{new_position.y}"
  end

  # Draw the image inside this window.
  def tick
    @image.draw(self, @mouse_position)
  end
end

w = MyWindow.new(300, 300)
w.open