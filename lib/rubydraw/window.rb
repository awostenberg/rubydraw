module Rubydraw
  # Instances of Rubydraw::Window can draw themselves on the screen after you open them.
  # Note: there can only be one window on the screen at a time; it is a limit
  # of SDL. One important things about instances of Rubydraw::Window: its main loop
  # (which starts when Rubydraw::Window#open is called) is *not* forked! It will break
  # when Rubydraw::Window#close is called.
  class Window
    attr_reader(:width, :height)

    # Create a new window.
    def initialize(width, height, bkg_color=Color::Black)
      unless height.is_a?(Numeric) and width.is_a?(Numeric)
        # Raise an error
        raise SDLError "Window width and height have to be a number."
      end

      @width = width
      @height = height
      @open = false

      @event_queue = EventQueue.new

      @registered_actions = {}

      @bkg_color = bkg_color
    end

    # Call this method to start updating and drawing.
    def show
      @open = true
      # Behold, the main loop. Drumroll!
      @screen = SDL::SetVideoMode(@width, @height, 0, 0)
      loop do
        handle_events
        if @open
          # Clear the contents of the window
          clear
          tick
          # Update the screen to show any changes.
          SDL::UpdateRect(@screen, 0, 0, 0, 0)
        else
          # This is where the loop is broken after Rubydraw::Window#close is called.
          break
        end
      end
    end

    # Clear the window's contents by filling it with black. A bit of a cheat; I don't
    # know if there is a better way to do this.
    def clear
      fill_with(@bkg_color)
    end

    # Fill the entire window with a Rubydraw::Color. Do this by feeding SDL the numeric
    # verion of the color; see Rubydraw::Color#to_i
    def fill_with(color)
      SDL::FillRect(@screen, nil, color.to_i)
    end

    # Call this method to tell SDL to quit drawing. The loop (started in
    # Rubydraw::Window#open) would continue if +close+ only stopped drawing, so
    # break the loop too.
    def close
      break_main_loop
      SDL.QuitSubSystem(SDL::INIT_VIDEO)
    end

    alias quit close

    # Collect and handle new events by executing blocks in +@regestered_events+. See
    # Rubydraw::Window#register_action on how to use it.
    def handle_events
      events = @event_queue.get_events

      #events.each {|event|
      #  block = @registered_actions[event.class]
      #  block.call(event) unless block.nil?}
      events.each {|event|
        blocks = @registered_actions[event.class]
        unless blocks.nil?
          blocks.each {|b| b.call(event) unless b.nil?}
        end}
    end

    # This causes the main loop to exit. Use Rubydraw::Window#close to close the
    # window, not this.
    def break_main_loop
      @open = false
    end

    # Returns if this window is open.
    def open?
      @open
    end

    # Return the SDL surface object. Only used in Rubydraw::Image#draw for blitting to
    # this window.
    def sdl_surface
      @screen
    end


    # Redefine Rubydraw::Window#tick with any code you want to be executed
    # every frame, like drawing functions.
    #
    # Does nothing by default.
    def tick
    end

    def registered_actions
      @registered_actions
    end
  end
end