require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  def initialize
    super(300, 300)
    @sound = Rubydraw::Sound.new("media/hooray.ogg")
    whenever Rubydraw::Events::QuitRequest do
      close
    end
    whenever Rubydraw::Events::KeyPressed do
      @sound.play
    end
  end
end

MyWindow.new.open