require 'rubygems'

SPEC = Gem::Specification.new do |spec|
  spec.name         = "rubydraw"
  spec.version      = "0.3.0"
  spec.author       = "J. Wostenberg"
  spec.summary      = "Rubydraw is a high level drawing/graphics library, like Gosu or Rubygame."
  spec.description  = "
    Rubydraw is a high level drawing/game library,
    like Gosu or Rubygame.
    Dependancies: ruby-sdl-ffi, SDL (not a ruby gem),
    and 2DArray."

  spec.homepage       = "https://github.com/awostenberg/rubydraw"
  spec.platform       = Gem::Platform::RUBY
  spec.require_paths  << "lib"
  lib_files           = %w[
    window.rb
    flags.rb
    surface.rb
    image.rb
    sound.rb
    text.rb
    sdl_error.rb
    keys.rb
    event_queue.rb
    events.rb
    point.rb
    color.rb
    rectangle.rb
    mouse_state.rb]
  example_files       = %w[
    window_ex.rb
    image_ex.rb
    ball_catch_game.rb
    media/bug.png
    media/ball.png
    media/bucket.png]
  ext_files           = %w[
    string.rb
    object.rb
    aliases.rb]
  fonts               = [
    "Georgia",
    "Georgia Bold",
    "Georgia Italic",
    "Georgia Bold Italic",
    "Sans Serif",
    "Times New Roman",
    "Times New Roman Bold",
    "Times New Roman Italic",
    "Times New Roman Bold Italic"]
  lib_files.collect! {|file_name| "lib/rubydraw/" + file_name}
  example_files.collect! {|file_name| "examples/" + file_name}
  ext_files.collect! {|file_name| "lib/ext/" + file_name}
  fonts.collect! {|font_name| "lib/fonts/#{font_name}.ttf"}
  spec.files          = ["README", "lib/rubydraw.rb", lib_files, example_files, ext_files, fonts].flatten
  spec.add_dependency("ruby-sdl-ffi", ">= 0.4")
  spec.add_dependency("2DArray", ">= 0.1.0")
end