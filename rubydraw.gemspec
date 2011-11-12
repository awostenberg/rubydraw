require 'rubygems'

SPEC = Gem::Specification.new do |spec|
  spec.name         = "rubydraw"
  spec.version      = "0.1.0"
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
    lib/rubydraw.rb
    lib/rubydraw/window.rb
    lib/rubydraw/image.rb
    lib/rubydraw/sdl_error.rb
    lib/rubydraw/keys.rb
    lib/rubydraw/event_queue.rb
    lib/rubydraw/events.rb
    lib/rubydraw/point.rb]
  examples            = ["examples/window_ex.rb", "examples/image_ex.rb", "examples/media/bug.png"]
  spec.files          = ["README", lib_files, examples].flatten
  spec.add_dependency("ruby-sdl-ffi", ">= 0.4")
end