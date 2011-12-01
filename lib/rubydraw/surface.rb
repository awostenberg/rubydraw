module Rubydraw
  # The basic class whose instances can blit themselves to other surfaces or the window.
  # You can only manipulate the surface's pixels, but there are subclasses to do other
  # things (like Rubydraw::Image or Rubydraw::Text)
  class Surface
    # Load an image from +path+.
    def self.load_img(path)
      Image.new(path)
    end

    # Create a new Rubydraw::Font with +text+ as its contents.
    def self.load_text(contents, color)
      Text.new(contents, color)
    end

    # Create a new, blank surface with the given dimensions.
    def initialize(dimensions)
      @dimensions = dimensions
      pixel_format = SDL.GetVideoInfo.vfmt
      rmsk, gmsk, bmsk, amsk = 0xff0000, 0x00ff00, 0x0000ff, 0x000000
      depth = pixel_format.BitsPerPixel
      @sdl_surface = SDL.CreateRGBSurface(0, dimensions.x, dimensions.y, depth, rmsk, gmsk, bmsk, amsk)
      if @sdl_surface.pointer.null?
        raise SDLError, "Failed to create Rubydraw surface: #{SDL.GetError}"
      end
      self
    end

    # Blit (copy) into +surface at +position+ (see Rubydraw::Point).
    # No graphical effects are applied.
    def blit(surface, position)
      if surface.nil?
        raise SDLError, "Surface to blit to cannot be nil"
      end
      if position.nil?
        raise SDLError, "Position to blit at cannot be nil"
      end
      source_rect = Rectangle[Point[0, 0], Point[width, height]]
      blit_rect = Rectangle[position, Point[surface.width, surface.height]]
      SDL::BlitSurface(@sdl_surface, source_rect.to_sdl, surface.to_sdl, blit_rect.to_sdl)
      self
    end

    alias draw blit

    # Returns the width of this surface.
    def width
      @sdl_surface.w
    end

    # Returns the height of this surface.
    def height
      @sdl_surface.h
    end

    # Fills this surface with the given color.
    def fill(color)
      SDL.FillRect(@sdl_surface, nil, color.to_i(:surface))
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

      @sdl_surface = SDL::Gfx.rotozoomSurface(@sdl_surface, angle, zoom, smooth)
      raise SDLError, "Filed to perform rotozoom: #{SDL.GetError}" if @sdl_surface.pointer.null?
      self
    end

    # Returns a rotated and/or expanded image, without modifying the
    # reciever.
    def rotozoom(angle, zoom, smooth=false)
      new_image = self.class.new(@sdl_surface)
      new_image.rotozoom!(angle, zoom, smooth)
    end

    # Returns the sdl surface.
    def to_sdl
      @sdl_surface
    end
  end
end