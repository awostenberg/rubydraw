          # Rubydraw is a high level drawing/gaming library written in Ruby, like Gosu or Rubygame. Its only dependency is ruby-sdl-ffi, which it uses to access SDL functions.
          # NOTE: ruby-sdl-ffi does NOT work with Ruby 1.9.2 (at least for me)! I will try to fix this big issue. In the meantime, please use <= Ruby 1.8. Sorry for the inconvenience!
          # Other stuff: I stole the Window#update and Window#draw proudly from Gosu. It is a good Ruby and C++ library, and I suggest you try it. But try Rubydraw first! :P
module Rubydraw
          # Instances of Window can draw themselves on the screen after you open them. To draw images, use the Image class and pass a Window instance a parameter.
  class Window
          # Create a new window
    def initialize(width, height)
      @width = width
      @height = height
      @open = false
    end

          # Call this method to start updating and drawing
    def open
      @open = true
          # Behold, the main loop. Drumroll!
      loop do
        update
        draw
        @screen = SDL::SetVideoMode(@width, @height, 0, 0)
        SDL::UpdateRect(@screen, 1, 1, 1, 1)
      end
    end

          # Call this method to cease updating and drawing
    def close
      @open = false
    end

          # Returns if this window is open
    def open?
      @open
    end

          # Redefine this method and put any code here you want to be executed every frame.
          # Does nothing by default.
    def update
    end

          # Redefine this method and put your drawing code in it.
          # Does nothing by default.
    def draw
    end

          # Return the width of this window
    def width
      @width
    end

          # Return the height of this window
    def height
      @height
    end
  end
end