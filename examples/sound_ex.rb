require 'rubygems'
require 'rubydraw'

class MyWindow < Rubydraw::Window
  def initialize
    super(300, 300)
    @sound = Rubydraw::Sound.new("media/hooray.ogg")
    @sound2 = Rubydraw::Sound.new("media/noise.o.ogg")
    whenever Rubydraw::Events::QuitRequest do
      close
    end
    whenever Rubydraw::Events::KeyPressed do
      @sound.play if @sound.stopped?
    end
    whenever Rubydraw::Events::FocusLoss do
      @sound2.play if @sound2.stopped?
    end
  end
end

MyWindow.new.open