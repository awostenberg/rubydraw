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
    @image.draw(Rubydraw::Point[width / 2, height / 2])
  end

  def handle_event(event)
    case event
      when Rubydraw::Events::UnknownEvent
        puts "Unknown event"
      when Rubydraw::Events::MouseMove
        puts "Mouse moved to #{event.position.x}, #{event.position.y}"
      when Rubydraw::Events::MousePressed
        puts "Mouse button #{event.button} pressed."
      when Rubydraw::Events::MouseReleased
        puts "Mouse button #{event.button} released."
      when Rubydraw::Events::Quit
        puts "Closing"
        close
    end
  end
end

w = MyWindow.new(300, 300)
w.open
puts "Exiting, goodbye!"