#!/usr/bin/env ruby

basedir = "/Users/josh/.vim/bundle/"
Dir.chdir(basedir)

entries = Dir.glob("*")

# ignore any plain old files in this directory...
# why would there be any?
entries.delete_if do |entry|
  path_to_entry = basedir + entry
  not File.directory?(path_to_entry)
end

def handle_js
  puts "Moving YOUR syntax file from Code/Syntax"
  system "cp ~/Dropbox/Code/Syntax/javascript.vim ~/.vim/bundle/vim-javascript/syntax/javascript.vim"
end

entries.each do |entry|
  Dir.chdir(basedir + entry)
  puts entry
  puts "-------------------------"
  system "git pull"
  handle_js if entry == "vim-javascript"
  puts "-------------------------\n\n\n\n"
end
