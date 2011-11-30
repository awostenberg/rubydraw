module Rubydraw
  # Text objects are instantiazed with the font (can be a TTF file) and
  # with the text to display. They can be drawn at a position on the
  # screen.
  class Text
    attr_reader(:contents, :font, :color, :size)

    # Create a new drawable Text object with the given font and contents.
    def initialize(contents, color, font_name="Times New Roman", size = 25)
      @font, @contents, @size, @color = font_name, contents, size, color
      if File.exist?(font_name)
        font_path = font_name
      else
        # The font doesn't exist in the program's directory.
        # Check in Rubydraw's font directory (rubydraw-x.x.x/lib/rubydraw/fonts)
        font_path = "#{File.dirname(__FILE__)}/../fonts/#{font_name}.ttf"
      end
      unless File.exists?(font_path)
        raise "Font file '#{font_name}' does not exist; attemped to load from '#{font_path}'"
      end
      sdl_text = SDL::TTF.OpenFont(font_path, size)
      raise(SDLError, "Failed to initialize font: #{SDL.GetError}") if sdl_text.pointer.null?

      sdl_color = @color.to_sdl
      @sdl_surface = SDL::TTF.RenderText_Blended(sdl_text, @contents, sdl_color)
    end

    # Returns the SDL surface for this object.
    def sdl_surface
      @sdl_surface
    end

    alias to_sdl sdl_surface

    # Blit (copy) into +surface at +position+ (see Rubydraw::Point).
    # No graphical effects are applied.
    def blit(surface, position)
      source_rect = Rectangle[Point[0, 0], Point[width, height]]
      blit_rect = Rectangle[position, Point[surface.width, surface.height]]
      SDL::BlitSurface(sdl_surface, source_rect.to_sdl, surface.to_sdl, blit_rect.to_sdl)
      self
    end

    alias draw blit

    # Returns the width.
    def width
      @sdl_surface.w
    end

    # Returns the height.
    def height
      @sdl_surface.h
    end
  end
end