require 'rubygems'
#require 'gosu'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  def initialize(width, height)
    super(width, height)
    puts "New window created with width: #{@width} and height #{@height}"
  end

  def tick
    update
    draw
  end

  def update
    #puts "Updated!"
  end

  def draw
    #puts "Drawn!"
  end
end

print "Window height: "
w = gets.to_i
print "Window width: "
h = gets.to_i

window = MyWindow.new(w, h).open

          # Wait for a while to let the user enjoy the window
sleep 10