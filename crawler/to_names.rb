#!/usr/bin/env ruby
['web_cache','db','user'].each { |f| require "#{File.dirname(__FILE__)}/#{f}" }

web_cache = WebCache.new
id_to_name = {}

STDIN.each do |line|
  ids = line.split
  ids.each { |id| id_to_name[id] ||= User.new(id,web_cache).screen_name }
  puts ids.collect { |id| id_to_name[id] }.join "\t"
end
