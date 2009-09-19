require 'web_cache'
require 'db'

class Crawler

	def initialize
		@web_cache = WebCache.new
		@db = Db.new
	end

	def friends_of id
		@web_cache.friends_of_xml(id).split.collect do |line|
			line =~ /^<id>(.*)</
			$1
		end.compact
	end

	def user_info_of id
		xml = @web_cache.user_info_xml_for(id)
		xml =~ /<name>(.*?)<\/name>/
		name = $1
		xml =~ /<screen_name>(.*)<\/screen_name>/
		screen_name = $1
		[name, screen_name]
	end

	def friend_cost num_friends
		return 0 if num_friends==0
		Math.log(num_friends) / Math.log(10)			
	end

	def step
		tid = nil
		begin
			puts Time.now
			tid, depth, cost = @db.next_to_fetch
			puts "step tid=#{tid} depth=#{depth} cost=#{cost}"
			friends = friends_of tid
			name, screen_name = user_info_of tid
			@db.update_last_seen tid, friends.size, name, screen_name			
			friend_cost = cost + 1 + friend_cost(friends.size)
			friends.each do |friend|
				@db.add_friend tid, friend
				@db.add_to_frontier friend, depth+1, friend_cost unless @db.visited_before? friend
			end
			@db.remove_from_frontier tid
			STDERR.flush
			STDOUT.flush
		rescue Exception => e		
			@web_cache.invalidate_for tid
			puts "ERROR #{e.inspect} #{e.m}"
			STDERR.flush
			STDOUT.flush
			sleep 60
		end
	end

end

c = Crawler.new 
c.step while true
