require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  def initialize
    super(Point[500, 500])
    self.title = "Color test"
    @surface = Rubydraw::Surface.new(Point[100, 100])
    @surface.fill(Rubydraw::Color::Red)
    @zoom = 1
    whenever Rubydraw::Events::MouseMove do
      @zoom += 1
      @surface.pixels.each { |color, x, y|
        if (x * y / @zoom).odd?
          @surface.set_pixel(Point[x, y], color.invert)
        end }
      whenever Rubydraw::Events::QuitRequest do
        close
      end
    end
  end

  def tick
    @surface.draw(self, Rubydraw.mouse_state.position)
  end
end

MyWindow.new.show