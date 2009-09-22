require 'web_cache'
require 'db'
require 'user'

class Crawler

	def initialize
		@web_cache = WebCache.new
		@db = Db.new
	end

	def step
		tid = nil
		begin
			puts Time.now
			tid, depth, cost = @db.next_to_fetch
			puts "step tid=#{tid} depth=#{depth} cost=#{cost}"
			user = User.new tid, @web_cache
			if user.valid?
				friends = user.friends
				@db.update_last_seen tid, friends.size, user.name, user.screen_name			
				friend_cost = cost + 1 + user.friend_cost
				friends.each do |friend|
					@db.add_friend tid, friend
					@db.add_to_frontier friend, depth+1, friend_cost
				end
				puts "user #{user.name} added #{friends.size} friends"
			else
				puts "ignoring what appears to be an invalid user #{tid}"
			end
			@db.remove_from_frontier tid
		rescue Exception => e		
#			@web_cache.invalidate_for tid rescue puts "couldnt invalidate #{tid}"
			puts "#{e.class} #{e.message} #{e.backtrace.inspect}"
			sleep 60
		end
	end

end

STDERR.sync = true
STDOUT.sync = true
c = Crawler.new 
c.step while true
