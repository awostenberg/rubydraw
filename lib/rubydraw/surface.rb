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

    def initialize(*args)
      if args.size == 1
        # Must mean to wrap an SDL surface.
        @sdl_surface = args[0]
      else
        load_from_color(*args)
      end
    end

    # Create a new, blank surface with the given dimensions.
    def load_from_color(dimensions, color=Rubydraw::Color::Black)
      @dimensions = dimensions
      pixel_format = SDL.GetVideoInfo.vfmt
      rmsk, gmsk, bmsk, amsk = 0xff0000, 0x00ff00, 0x0000ff, 0x000000
      depth = pixel_format.BitsPerPixel
      @sdl_surface = SDL.CreateRGBSurface(0, dimensions.x, dimensions.y, depth, rmsk, gmsk, bmsk, amsk)
      if @sdl_surface.pointer.null?
        raise SDLError, "Failed to create Rubydraw surface: #{SDL.GetError}"
      end
      fill(color)
      self
    end

    private :load_from_color

    # Blit (copy) into +surface at +position+ (see Rubydraw::Point).
    # No graphical effects are applied.
    def blit(surface, position, damaging=true)
      source_rect = Rectangle[Point[0, 0], size]
      blit_rect = Rectangle[position, size]
      if surface.window? and damaging
        surface.add_space_to_clear(blit_rect)
      end
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

    def size
      Point[width, height]
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

    # This is a private method because it doesn't lock the SDL surface (too
    # much locking and unlocking for Rubydraw::Surface#pixels). Use
    # Rubydraw::Surface#get_pixel.
    #
    # Credit goes to Rubygame and the SDL docs for showing how to access this
    # information.
    def basic_get_pix(point)
      bpp = @sdl_surface.format.BytesPerPixel
      p = @sdl_surface.pixels + (point.y * @sdl_surface.pitch + point.x * bpp)

      pcolor =
          case bpp
            when 1
              p.get_uint8(0)
            when 2
              p.get_uint16(0)
            when 3
              if (FFI::Platform::BYTE_ORDER == FFI::Platform::BIG_ENDIAN)
                (ptr.get_uint8(0) << 16)|(ptr.get_uint8(1) << 8)|ptr.get_uint8(2)
              else
                ptr.get_uint8(0)|(ptr.get_uint8(1) << 8)|(ptr.get_uint8(2) << 16)
              end
            when 4
              p.get_uint32(0)
          end

      r, g, b, a = SDL.GetRGBA(pcolor, @sdl_surface.format)
      Rubydraw::Color.new(r, g, b, a)
    end

    # This is a private method because it doesn't lock the SDL surface (too
    # much locking and unlocking for Rubydraw::Surface#pixels_do). Use
    # Rubydraw::Surface#set_pixel.
    #
    # Credit goes to Rubygame and the SDL docs for showing how to access this
    # information.
    def basic_set_pix(point, new_color)
      color = new_color.to_i(:surface)
      color = 0xff_ff_ff
      puts color

      bpp = @sdl_surface.format.BytesPerPixel
      p = @sdl_surface.pixels + (point.y * @sdl_surface.pitch + point.x * bpp)

      case bpp
        when 1
          p.put_uint8(0, color)
        when 2
          p.put_uint16(0, color)
        when 3
          if (FFI::Platform::BYTE_ORDER == FFI::Platform::BIG_ENDIAN)
            p.put_uint8(0, (color >> 16) & 0xff)
            p.put_uint8(1, (color >> 8) & 0xff)
            p.put_uint8(2, color & 0xff)
          else
            p.put_uint8(0, color & 0xff)
            p.put_uint8(1, (color >> 8) & 0xff)
            p.put_uint8(2, (color >> 16) & 0xff)
          end
        when 4
          p.put_uint32(0, color)
      end

      return new_color
    end

    private :basic_set_pix
    private :basic_get_pix

    # Returns the color of the pixel at +point+.
    def get_pixel(point)
      SDL.LockSurface(@sdl_surface)
      result = basic_get_pix(point)
      SDL.UnlockSurface(@sdl_surface)
      return result
    end

    # Sets the color at +point+.
    def set_pixel(point, new)
      SDL.LockSurface(@sdl_surface)
      result = basic_set_pix(point, new)
      SDL.UnlockSurface(@sdl_surface)
      return result
    end

    # Returns a two-dimensional array (from https://rubygems.org/gems/2DArray)
    # containing each pixel color at its proper position.
    #
    # There's probably a better way to implement this... :/
    def pixels
      ary = Array2D.new(width, height)
      x = 0
      y = 0
      SDL.LockSurface(@sdl_surface)
      ary.each { |elem, elem_x, elem_y|
        ary[elem_x, elem_y] = basic_get_pix(Point[elem_x, elem_y]) }
      SDL.UnlockSurface(@sdl_surface)
      ary
    end

    # Flip the surface on an axis.
    def flip(axis)
      axis = axis.to_sym
      if axis == :horizontal
        pixels.each {
          |color, x, y|
          set_pixel(Point[x, height - y], color)
        }
        return self
      end
      if axis == :vertical
        pixels.each {
          |color, x, y|
          set_pixel(Point[width - x, y], color)
        }
        return self
      end
      # Only get here if no axis mode was matched.
      raise ArgumentError, "Unknown flip mode: \"#{axis}\""
    end

    # Returns the area of this surface; e.g. if +width+ were 5 and +height+ were
    # 4, this method would return 20.
    def area
      width * height
    end
  end
end