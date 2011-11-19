module Rubydraw
  # Text objects are instantiazed with the font (can be a TTF file) and
  # with the text to display. They can be drawn at a position on the
  # screen.
  class Text
    attr_accessor(:font, :contents, :size, :color)
    # Create a new drawable Text object with the given font and contents.
    def initialize(font, contents, color = Rubydraw::Color::White, size = 25)
      @font, @contents, @size, @color = font, contents, size, color
      @drawable = SDL::TTF.OpenFont(font, size)
      raise(SDLError, "Failed to initialize font: #{SDL.GetError}") if @drawable.pointer.null?
    end

    # Draw the font in the given window at a position.
    def draw(window, position)
      sdl_color = @color.to_sdl
      sdl_surface = SDL::TTF.RenderText_Blended(@drawable, @contents, sdl_color)
      source_rect = Rectangle[sdl_surface.w, sdl_surface.h, Point[0, 0]]
      blit_rect = Rectangle[window.width, window.height, position]
      SDL::BlitSurface(sdl_surface, source_rect.to_sdl, window.sdl_surface, blit_rect.to_sdl)
    end
  end
end