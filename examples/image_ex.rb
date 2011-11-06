require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  # Create a new window with an bug image inside it
  def initialize(width, height)
    super(width, height)
    @image = Rubydraw::Image.new(self, "media/bug.png")
    @max = 100
  end

  # Draw the image inside this window, and stop after +@max+ ticks.
  def tick
    @image.draw(100, 100)
  end

  def handle_event(event)
    case event
    when SDL::QuitEvent
      close
    end
  end

  #def handle_event(event)
  #  puts event.class
  #end
end

w = MyWindow.new(300, 300)
w.open
puts "Exiting, goodbye!"