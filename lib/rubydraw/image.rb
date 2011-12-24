module Rubydraw
  # Image instances can be initialized with Image#new, passing the
  # window to draw in, and the path to the image file to draw with.
  # Then to actually draw the image (doesn't happen immediatley;
  # read the documentation for Image#draw), call it's #draw method
  # and pass it the +x+ and +y+ coordinates.
  class Image < Surface
    def initialize(path)
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
  end
end