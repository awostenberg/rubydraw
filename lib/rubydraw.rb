require 'ruby-sdl-ffi'

          # So I don't have to type "rubydraw/filename_here" all the time
def rbd_require(file)
  require "rubydraw/#{file}"
end

          # Require all the rubydraw files
rbd_require "window"