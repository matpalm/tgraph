#!/usr/bin/env ruby

require 'mysql'
require 'set'
require 'rubygems'
require 'json'

raise "usage: arg0=id limit" unless ARGV.length==1
limit = ARGV[0]
USE_IDS = false # as opposed to user names

db = Mysql.init()
db.connect('localhost','mat','mat')
db.select_db('tgraph')
res = db.query "select tid, name from users where id<=#{limit} order by id;"
user_to_name = {}
ids = []
while(row=res.fetch_row)
	id = row[0].to_i
	user_to_name[id] = row[1].downcase.gsub(/[^a-z0-9 ]/,'')
	ids << id
end
res.free
ids.each do |id|
	friends = JSON.parse(File.read("cache/friends.#{id}.json"))
	friends.reject! { |i| !ids.include? i }
	friends.each do |fid|	
		if USE_IDS
			puts "#{id}\t#{fid}"
		else
			puts "#{user_to_name[id]}\t#{user_to_name[fid]}"
		end
	end
end

