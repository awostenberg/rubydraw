module Rubydraw
  # Image instances can be initialized with Image#new, passing the
  # window to draw in, and the path to the image file to draw with.
  # Then to actually draw the image (doesn't happen immediatley;
  # read the documentation for Image#draw), call it's #draw method
  # and pass it the +x+ and +y+ coordinates.
  class Image
    # Create a new image in the given window and load the image from
    # +path.+
    def initialize(path)
      # In case program is being run from a different directory,
      # provide the _full_ path. Nothing relative here.
      full_path = File.expand_path path
      @sdl_image = SDL::Image.Load(full_path)
      if @sdl_image.pointer.null?
        # SDL couln't load the image; usually happens because it doesn't
        # exist.
        raise Rubydraw::SDLError "Failed to load image: #{SDL.GetError}"
      end
    end

    # Blit (copy) into the window at +position+ (see Rubydraw::Point).
    # No graphical effects are applied.
    #
    # Notice that you don't blit surfaces to other surfaces when using
    # Rubygame, but instead you draw things.
    def draw(window, position)
      unless position.respond_to?(:x) and position.respond_to?(:y)
        raise ArgumentError, "Expected a Point, got #{position}"
      end
      source_rect = Rectangle[Point[0, 0], Point[width, height]]
      blit_rect = Rectangle[position, Point[window.width, window.height]]
      SDL::BlitSurface(@sdl_image, source_rect.to_sdl, window.sdl_surface, blit_rect.to_sdl)
      self
    end

    # Returns the image width
    def width
      @sdl_image.w
    end

    # Returns the image height
    def height
      @sdl_image.h
    end
  end
end