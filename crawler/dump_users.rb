#!/usr/bin/env ruby

require 'set'
['web_cache','db','user'].each { |f| require "#{File.dirname(__FILE__)}/#{f}" }

web_cache = WebCache.new
db = Db.new
user_to_friends = {}

STDIN.each do |line|
  id1 = line.to_i
  user = User.new id1, web_cache
  user.friends.each do |id2|
    a,b = id1,id2
    a,b = b,a if id2 < id1
    puts "#{a} #{b}"
  end
end


