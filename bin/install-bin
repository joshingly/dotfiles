#!/usr/bin/env ruby

Dir.chdir(File.expand_path("~/Dropbox/System/dotfiles/bin/"))

Dir.mkdir(File.expand_path("~/.bin")) unless Dir.exists?(File.expand_path("~/.bin"))

files = Dir.glob("*").delete_if { |file| file["install"] }

files.each do |file|
  puts "copied #{file}"
  system "cp #{file} ~/.bin/"
end
