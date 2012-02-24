# main.rb
# RubydrawWrapper
#
# Created by Alan Wostenberg on 1/16/12.
# Copyright 2012 Wosterware.com. All rights reserved.

# DO NOT PUT YOUR RUBY PROGRAM IN THIS FILE. PUT IT IN: ApplicationBundle/Contents/Resources/main.rb

resources = File.expand_path(File.dirname(__FILE__) + "/../Resources") + "/"
main_rb = resources + "main.rb"
gems_path = resources + "gems"
[main_rb, gems_path].each {|f| $LOAD_PATH.unshift(f)}
puts File.dirname(__FILE__)
#puts $LOAD_PATH