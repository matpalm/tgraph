require 'web_cache'
require 'db'

class Crawler

	def initialize
		@web_cache = WebCache.new
		@db = Db.new
	end

	def friends_of id
		@web_cache.friends_xml(id).split.collect do |line|
			line =~ /^<id>(.*)</
			$1
		end.compact
	end

	def step
		tid, depth, cost = @db.next_to_fetch
		@db.update_last_seen tid	
		friends = friends_of tid
		friend_cost = cost + 1 + Math.log(friends.size) / Math.log(10)		
		friends.each do |friend|
			@db.add_friend tid, friend
			@db.add_to_frontier friend, depth+1, friend_cost unless @db.visited_before? friend
		end
		@db.remove_from_frontier tid
	end

end

c = Crawler.new 
c.step
