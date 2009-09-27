require 'web_cache'
require 'db'
require 'user'
require 'set'
require 'rate_limiter'

class Crawler

	def initialize
		@web_cache = WebCache.new
		@db = Db.new
		@user_ids = @db.user_ids
	end

	def step
		tid = nil
		begin
			puts Time.now
			tid, depth, cost = @db.next_to_fetch
			puts "step tid=#{tid} depth=#{depth} cost=#{cost}"
			user = User.new tid, @web_cache
			@user_ids << tid
			if user.valid?
				friends = user.friends
				@db.update_last_seen tid, friends.size, user.name, user.screen_name			
				friend_cost = cost + 1 + user.friend_cost
				user_seen_before = already_on_frontier = 0
				friends.each do |friend|
					#@db.add_friend tid, friend
					if @user_ids.include?(friend)
						user_seen_before += 1
					elsif @db.in_frontier?(friend)
						already_on_frontier  += 1
					else	
						@db.add_to_frontier friend, depth+1, friend_cost
					end
				end
				puts "user #{user.name} added #{friends.size} friends; user_seen_before=#{user_seen_before} already_on_frontier=#{already_on_frontier}"
			else
				puts "ignoring what appears to be an invalid user #{tid}"
			end
		rescue Exception => e		
#			@web_cache.invalidate_for tid rescue puts "couldnt invalidate #{tid}"
			puts "#{e.class} #{e.message} #{e.backtrace.inspect}"
			sleep 60
		end
		@db.remove_from_frontier tid 
		puts "#{@db.count_of('users')} users; #{@db.count_of('frontier')} in frontier"
	end

end

#Db.new.reinit
STDERR.sync = true
STDOUT.sync = true
c = Crawler.new 
c.step while true

