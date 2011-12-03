module Rubydraw
  # Image instances can be initialized with Image#new, passing the
  # window to draw in, and the path to the image file to draw with.
  # Then to actually draw the image (doesn't happen immediatley;
  # read the documentation for Image#draw), call it's #draw method
  # and pass it the +x+ and +y+ coordinates.
  class Image < Surface
    # Create a new image and load the file from a path. Or, wrap an
    # SDL::Surface.
    def initialize(arg)
      if arg.is_a?(String)
        # This must mean to load from a path.
        load_from_path(arg)
      elsif arg.is_a?(SDL::Surface)
        load_from_surface(arg)
      else
        raise TypeError, "Failed to load image: Expected String or SDL::Surface but got: #{arg}"
      end
      self
    end

    def load_from_path(path)  #:nodoc:
      # Check if this image has already been initialized. If it has, raise
      # an error.
      unless @sdl_surface.nil?
        raise SDLError, "Images may only be loaded once"
      end
      # In case program is being run from a different directory,
      # provide the _full_ path. Nothing relative here.
      full_path = File.expand_path path
      @sdl_surface = SDL::Image.Load(full_path)
      if @sdl_surface.pointer.null?
        # SDL couln't load the image; usually happens because it doesn't
        # exist.
        raise SDLError, "Failed to load image: #{SDL.GetError}"
      end
    end

    def load_from_surface(surface) #:nodoc:
      # Check if this image has already been initialized. If it has, raise
      # an error.
      unless @sdl_surface.nil?
        raise SDLError, "Images may only be loaded once"
      end
      @sdl_surface = surface
    end

    private :load_from_path, :load_from_surface
  end
end