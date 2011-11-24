module Rubydraw
  # Image instances can be initialized with Image#new, passing the
  # window to draw in, and the path to the image file to draw with.
  # Then to actually draw the image (doesn't happen immediatley;
  # read the documentation for Image#draw), call it's #draw method
  # and pass it the +x+ and +y+ coordinates.
  class Image
    # Create a new image and load the file from a path. Or, load it using
    # an SDL surface.
    def initialize(arg)
      if arg.is_a?(String)
        # This must mean to load from a path.
        load_from_path(arg)
      elsif arg.is_a?(SDL::Surface)
        load_from_surface(arg)
      else
        raise TypeError, "Failed to load image: Expected String or SDL::Surface but got #{arg}"
      end
      self
    end

    def load_from_path(path)  #:nodoc:
      # Check if this image has already been initialize. If it has, raise
      # an error.
      unless @sdl_image.nil?
        raise SDLError, "Images may only be loaded once"
      end
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

    def load_from_surface(surface) #:nodoc:
      # Check if this image has already been initialized. If it has, raise
      # an error.
      unless @sdl_image.nil?
        raise SDLError, "Images may only be loaded once"
      end
      @sdl_image = surface
    end

    # Blit (copy) into the window at +position+ (see Rubydraw::Point).
    # No graphical effects are applied.
    #
    # Notice that you don't blit surfaces to other surfaces when using
    # Rubygame, but instead you draw things.
    def draw(window, position)
      source_rect = Rectangle[Point[0, 0], Point[width, height]]
      blit_rect = Rectangle[position, Point[window.width, window.height]]
      #source_rect = Rectangle[Point[0, 0], Point[window.width, window.height]]
      #blit_rect = Rectangle[position, Point[window.width, window.height]]
      SDL::BlitSurface(@sdl_image, source_rect.to_sdl, window.sdl_surface, blit_rect.to_sdl)
      self
    end

    # Rotates and/or expands the image. Note that this modifies the image
    # itself.
    def rotozoom!(angle, zoom, smooth=false)
      smooth =
          if smooth
            1
          else
            0
          end

      @sdl_image = SDL::Gfx.rotozoomSurface(@sdl_image, angle, zoom, smooth)
      raise SDLError, "Filed to perform rotozoom: #{SDL.GetError}" if @sdl_image.pointer.null?
      return self
    end

    # Returns a rotated and/or expanded image, without modifying the
    # reciever.
    def rotozoom(angle, zoom, smooth=false)
      new_image = self.class.new(@sdl_image)
      new_image.rotozoom!(angle, zoom, smooth)
    end

    # Returns the image width
    def width
      @sdl_image.w
    end

    # Returns the image height
    def height
      @sdl_image.h
    end

    # Returns the sdl surface.
    def to_sdl
      @sdl_image
    end
  end
end