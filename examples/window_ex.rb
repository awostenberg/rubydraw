require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  def initialize(width, height)
    super(width, height)
    puts "New window created with width: #{@width} and height #{@height}"
    whenever Rubydraw::Events::QuitRequest do
      close
    end
  end
end

print "Window height: "
w = gets.to_i
print "Window width: "
h = gets.to_i

window = MyWindow.new(w, h).show