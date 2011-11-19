require 'rubygems'

SPEC = Gem::Specification.new do |spec|
  spec.name         = "rubydraw"
  spec.version      = "0.1.5"
  spec.author       = "J. Wostenberg"
  spec.summary      = "Rubydraw is a high level drawing/graphics library, like Gosu or Rubygame"
  spec.description  = "
    Rubydraw is a high level drawing/game library,
    like Gosu or Rubygame. Its only dependency is
    ruby-sdl-ffi, which it uses to access SDL
    functions."

  spec.homepage       = "https://github.com/awostenberg/rubydraw"
  spec.platform       = Gem::Platform::RUBY
  spec.require_paths  << "lib"
  lib_files           = %w[
    window.rb
    image.rb
    sound.rb
    sdl_error.rb
    keys.rb
    event_queue.rb
    events.rb
    point.rb
    color.rb]
  example_files       = %w[
    window_ex.rb
    image_ex.rb
    sound_ex.rb
    media/bug.png
    media/hooray.ogg
    media/noise.ogg]
  lib_files.collect! {|file_name| "lib/rubydraw/" + file_name}
  example_files.collect! {|file_name| "examples/" + file_name}
  spec.files          = ["README", "lib/rubydraw.rb", "lib/ext/string.rb", lib_files, example_files].flatten
  spec.add_dependency("ruby-sdl-ffi", ">= 0.4")
end