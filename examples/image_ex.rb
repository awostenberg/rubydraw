require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  # Create a new window with an bug image inside it
  def initialize(width, height)
    super(width, height)
    @image = Rubydraw::Image.new(self, "media/bug.png")
    @step = 1
    @max = 100
  end

  # Draw the image inside this window, and stop after +@max+ ticks.
  def tick
    @step += 1
    if @step < 10
      @image.draw(10, 10)
    end
    if @step == @max
      puts "Closing window."
      close
    end
  end
end

w = MyWindow.new(300, 300)
w.open
puts "Exiting, goodbye!"