#!/usr/bin/env ruby
require 'web_cache'
require 'db'
require 'user'

web_cache = WebCache.new
id_to_name = {}

STDIN.each do |line|
  ids = line.split
  ids.each { |id| id_to_name[id] ||= User.new(id,web_cache).screen_name }
  puts ids.collect { |id| id_to_name[id] }.join "\t"
end
