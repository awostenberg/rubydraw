module Rubydraw
  # Text objects are instantiazed with the font (can be a TTF file) and
  # with the text to display. They can be drawn at a position on the
  # screen.
  class Text
    attr_accessor(:contents, :font, :color, :size)
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
      @drawable = SDL::TTF.OpenFont(font_path, size)
      raise(SDLError, "Failed to initialize font: #{SDL.GetError}") if @drawable.pointer.null?
    end

    # Draw the font in the given window at a position.
    def draw(window, position)
      sdl_color = @color.to_sdl
      sdl_surface = SDL::TTF.RenderText_Blended(@drawable, @contents, sdl_color)
      source_rect = Rectangle[Point[0, 0], Point[sdl_surface.w, sdl_surface.h]]
      blit_rect = Rectangle[position, Point[window.width, window.height]]
      SDL::BlitSurface(sdl_surface, source_rect.to_sdl, window.sdl_surface, blit_rect.to_sdl)
    end
  end
end