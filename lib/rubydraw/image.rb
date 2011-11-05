module Rubydraw
  # Image instances can be initialized with Image#new, passing the
  # window to draw in, and the path to the image file to draw with.
  # Then to actually draw the image (doesn't happen immediatley;
  # read the documentation for Image#draw), call it's #draw method
  # and pass it the +x+ and +y+ coordinates.
  class Image
    # Create a new image in the given window and load the image from
    # +path.+
    def initialize(window, path)
      @window = window
      unless window.is_a?(Rubydraw::Window)
        raise Rubydraw::DrawError "Window cannot be nil"
      end
      # In case program is being run from a different directory,
      # provide the _full_ path. Nothing relative here.
      full_path = File.expand_path path
      @sdl_image = SDL::Image.Load(full_path)
      if @sdl_image.pointer.null?
        # SDL couln't load the image; usually happens because it doesn't
        # exist.
        raise Rubydraw::DrawError "Failed to load image from: '#{full_path}'"
      end
    end

    # Blit (copy) into the window at +x+ and +y.+
    # No graphical effects are applied.
    #
    # Notice that you don't blit surfaces to other surfaces when using
    # Rubygame, but instead you draw them.
    def draw(x, y)
      source_rect = SDL::Rect.new([0, 0, width, height])
      blit_rect = SDL::Rect.new([x, y, @window.width, @window.height])
      SDL::BlitSurface(@sdl_image, source_rect, @window.sdl_surface, blit_rect)
      #SDL::BlitSurface(@sdl_image, nil, @window.sdl_surface, nil)
    end

    # Returns the image width
    def width
      @sdl_image.w
    end

    # Returns the image height
    def height
      @sdl_image.h
    end

    # Returns the SDL image that was created in Image#initialize.
    # Rubydraw::Window uses this to draw this Image instance.
    def sdl_image
      @sdl_image
    end
  end
end