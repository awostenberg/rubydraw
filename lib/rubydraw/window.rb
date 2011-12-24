module Rubydraw
  # Instances of Rubydraw::Window can draw themselves on the screen after you open them.
  # Note: there can only be one window on the screen at a time; it is a limit
  # of SDL. One important things about instances of Rubydraw::Window: its main loop
  # (which starts when Rubydraw::Window#open is called) is *not* forked! It will break
  # when Rubydraw::Window#close is called.
  class Window
    attr_accessor(:bkg_color)

    # Create a new window.
    def initialize(dimensions, flags=[], bkg_color=Color::Black)
      width, height = dimensions.to_ary
      @fullscreen = flags.include?(Rubydraw::Flags::Fullscreen)
      if width < 0
        raise SDLError, "New window width cannot be less than zero"
      end
      if height < 0
        raise SDLError, "New window height cannot be less than zero"
      end
      unless flags.include?(Flags::Fullscreen)
        if height == 0
          # Compensate for the height of the window bar itself, the menu bar at the top
          # of the screen, and a space of around 4px at the bottom of the screen. Not
          # sure what the numbers would be for anything other than Mac OSX; more info
          # would be appreciated.
          height = Rubydraw::screen_height - 48
        end
      end
      @width, @height, @flags, @bkg_color = width, height, Flags.collapse(flags), bkg_color
      @open = false

      @event_queue = EventQueue.new

      @registered_actions = {}
    end

    def width
      begin
        return @screen.w
      rescue NameError
        if @width == 0
          return Rubydraw.screen_width
        else
          return @width
        end
      end
    end

    def height
      begin
        return @screen.h
      rescue NameError
        if @height == 0
          return Rubydraw.screen_height
        else
          return @height
        end
      end
    end

    # Call this method to start updating and drawing.
    def show
      @open = true
      # Behold, the main loop. Drumroll!
      @screen = SDL::SetVideoMode(@width, @height, 0, @flags)
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
      SDL::FillRect(@screen, nil, convert(color))
    end

    # Convert +color+ to the display format.
    def convert(color)
      if @fullscreen
        return color.to_i(:display_fullscreen)
      else
        return color.to_i(:display)
      end
    end

    # Call this method to tell SDL to quit drawing. The loop (started in
    # Rubydraw::Window#open) would continue if +close+ only stopped drawing, so
    # break the loop too.
    def close
      break_main_loop
      SDL.QuitSubSystem(SDL::INIT_VIDEO)
    end

    alias quit close

    # Returns the window's current title.
    def title
      SDL.WM_GetCaption
    end

    # Sets the window title to +new+.
    def title=(new)
      SDL.WM_SetCaption(new, new)
    end

    # Sets the window's icon to +new+.
    def icon=(new)
      SDL.WM_SetIcon(new.to_sdl, nil)
    end

    # Collect and handle new events by executing blocks in +@regestered_events+. See
    # Object#whenever on how to use it.
    def handle_events
      events = @event_queue.get_events
      events.each {|event|
        # +blocks+ is a hashmap; the value being the object that registered it. This
        # property is only used in Object#unregister_action.
        events = @registered_actions
        blocks = events[event.class]
        unless blocks.nil?
          blocks.each {|obj, b|
            b.call(event) unless b.nil?
          }
        end
      }
    end

    # Causes the main loop to exit as soon as it get the chance to.
    def break_main_loop
      @open = false
    end

    private :break_main_loop

    # Returns if this window is open.
    def open?
      @open
    end

    # Return the SDL surface object. Only used in Rubydraw::Image#draw for blitting to
    # this window.
    def sdl_surface
      @screen
    end

    alias to_sdl sdl_surface

    # Redefine Rubydraw::Window#tick with any code you want to be executed
    # every frame, like drawing functions.
    #
    # Does nothing by default.
    def tick
    end

    def registered_actions
      @registered_actions
    end

    # Draw a line from +start+ to +finish+. Both should be an instance of Rubydraw::Point.
    #
    #   start:   The point on one side of the line.
    #   finish:  The point on the other end of the line.
    #   color:   An instance of Rubydraw::Color; defines the color of the line.
    #   mode:    Should be either +:aa+ or +:default+. When +:aa+, anti-aliasing is enabled, otherwise, it's not.
    def draw_line(start, finish, color, anti_aliasing=true)
      r, g, b, a = color.to_a
      args = [@screen, start.x, start.y, finish.x, finish.y, r, g, b, a]
      if not anti_aliasing
        SDL::Gfx.lineRGBA(*args)
      end
      if anti_aliasing
        SDL::Gfx.aalineRGBA(*args)
      end
      self
    end

    # Draw a rectangle over +area+.
    #
    #   area:   The area which the new rectangle will cover. Should be an instance of Rubydraw::Rectangle.
    #   color:  Specifies what color to use when drawing the rectangle. If +fill+ is enabled, it will fill the new rect with this color. If not, it will only affect the border.
    #   fill:   A boolean determining whether to fill it in or not. (anti-aliasing is not needed because all the lines are perfectly straigt)
    def draw_rectangle(area, color, fill=true)
      tl = area.top_left
      br = area.bottom_right
      r, g, b, a = color.to_a
      args = [@screen, tl.x, tl.y, br.x, br.y, r, g, b, a]
      if fill
        SDL::Gfx.boxRGBA(*args)
      end
      if not fill
        SDL::Gfx.rectangleRGBA(*args)
      end
      self
    end

    alias draw_rect draw_rectangle

    # Draw an ellipse. Similar to Rubydraw::Window#draw_circle, except not all ellipses are circles.
    #
    #   center:         The center of the ellipse, should be a Rubydraw::Point object.
    #   dimensions:     Determines the width and the height of the ellipse to be drawn; should be a Rubydraw::Point.
    #   color:          The color to use when drawing; should be an instance of Rubydraw::Color.
    #   mode:           Can be one of three modes; +:fill+, +:outline+, or +:aa+. When set to +:fill+, it will draw a *solid* ellipse. When it is +:outline+, it renders without filling. When set to +:aa+ (anti-aliasing), it will draw without filling and smooth the border.
    def draw_ellipse(center, dimensions, color, mode=:fill)
      x, y = center.to_a
      width, height = (dimensions / 2).to_a
      r, g, b, a = color.to_a
      args = [@screen, x, y, width, height, r, g, b, a]

      if mode == :fill
        SDL::Gfx.filledEllipseRGBA(*args)
        return self
      end
      if mode == :outline
        SDL::Gfx.ellipseRGBA(*args)
        return self
      end
      if mode == :aa
        SDL::Gfx.aaellipseRGBA(*args)
        return self
      end

      # Only reaches this when +mode+ is not recognized.
      raise ArgumentError, "Unknown mode '#{mode}'"
    end

    # Draw a circle.
    def draw_circle(center, radius, color, mode=:fill)
      draw_ellipse(center, Point[radius, radius], color, mode)
    end
  end
end