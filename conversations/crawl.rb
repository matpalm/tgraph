#!/usr/bin/env ruby
require 'set'
require 'mongo_cache.rb'

todo = []
todo << "mat_kelcey"
processed = Set.new
mongo_cache = MongoCache.new

while not todo.empty? do
  STDERR.puts "#todo = #{todo.size} #processed=#{processed.size}"

  next_user = todo.shift
  STDERR.puts "processing #{next_user}"

  next if processed.include? next_user

  results = mongo_cache.search_for next_user
  results ||= [] 
  results.each do |result|    
    prio = result['id']
    from_user = result['from_user'].downcase
    puts "#{prio}\t#{next_user}\t#{from_user}"
    todo << from_user
  end
  STDOUT.flush

  processed << next_user

end
