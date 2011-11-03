require 'rubygems'

SPEC = Gem::Specification.new do |spec|
  spec.name         = "rubydraw"
  spec.version      = "0.0.1"
  spec.author       = "J. Wostenberg"
  spec.platform     = Gem::Platform::RUBY
  spec.summary      = "Rubydraw is a high level drawing/graphics library, like Gosu or Rubygame"
  spec.description  = "
    Rubydraw is a high level game library, like
    Gosu or Rubygame. Its only dependency is
    ruby-sdl-ffi, which it uses to access SDL
    functions."
  spec.require_paths  << "lib"
  spec.files          << ["lib/rubydraw.rb"]
  spec.add_dependency("ruby-sdl-ffi", ">= 0.4")
end