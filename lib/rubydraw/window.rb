module Rubydraw
  # Instances of Rubydraw::Window can draw themselves on the screen after you open them.
  # Note: there can only be one window on the screen at a time; it is a limit
  # of SDL. One important things about instances of Rubydraw::Window: its main loop
  # (which starts when Rubydraw::Window#open is called) is *not* forked! It will break
  # when Rubydraw::Window#close is called (as soon as I get around to implementing this).
  class Window
    # Create a new window.
    def initialize(width, height)
      @width = width
      @height = height
      @open = false
    end

    # Call this method to start updating and drawing.
    def open
      @open = true
      # Behold, the main loop. Drumroll!
      @screen = SDL::SetVideoMode(@width, @height, 0, 0)
      loop do
        tick
        if @open
          # Update the screen to show any changes.
          SDL::UpdateRect(@screen, 0, 0, 0, 0)
        else
          # This is where the loop is broken after Rubydraw::Window#close is called.
          break
        end
          # Pause for a bit, so it's not such a tight loop.
        sleep 0.1
      end
    end

    # Call this method to tell SDL to quit drawing. The loop (started in
    # Rubydraw::Window#open) would continue if +close+ only stopped drawing, so
    # break the loop too.
    def close
      break_main_loop
      SDL.QuitSubSystem(SDL::INIT_VIDEO)
    end

    # This causes the main loop to stop executing. Use Rubydraw::Window#close to close
    # the window, not this.
    def break_main_loop
      @open = false
    end

    # Returns if this window is open.
    def open?
      @open
    end

    def sdl_surface
      @screen
    end


    # Redefine Rubydraw::Window#tick with any code you want to be executed
    # every frame, like drawing functions.
    #
    # Does nothing by default.
    def tick
    end

    # Return the width of this window.
    def width
      @width
    end

    # Return the height of this window.
    def height
      @height
    end
  end
end