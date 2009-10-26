require 'rubygems'
require 'json'
require 'time'
require 'date'
require 'curl'
require 'beanstalk-client'

class Queuer

	def initialize ids_to_do, ids_queued
		@ids_to_do = File.open ids_to_do, 'r'
		@ids_queued = File.new ids_queued, 'w+'
		@ids_queued.sync = true
		@beanstalk = Beanstalk::Pool.new(['localhost:11300'])
	end

	def run
#		while true
			ping_twitter
			@remaining_hits.times do
				next_id = @ids_to_do.readline.chomp			
				@beanstalk.put next_id
				@ids_queued.puts next_id	
			end
			block_until_twitter_reset_time
			block_until_beanstalk_queue_done
#		end
	end

	def ping_twitter
		log "ping_twitter"
		begin
			json = curl 'http://twitter.com/account/rate_limit_status.json'
			limit_info = JSON.parse(json)
			@reset_time = Time.parse limit_info['reset_time']				
			@remaining_hits = limit_info['remaining_hits']
			return
		rescue Exception => e
			puts e.inspect
			log "problem checking rate limit?? #{Time.now}"
			sleep 60
			retry
		end
	end

	def block_until_twitter_reset_time
		if Time.now < @reset_time
			minutes_till_reset = (@reset_time - Time.now) / 60
			log "sleeping #{minutes_till_reset.to_i} minutes until twitter reset time #{@reset_time}"
			sleep (minutes_till_reset*60)+2 # err margin
		end
	end

	def block_until_beanstalk_queue_done
		while true do
			todo = @beanstalk.stats['current-jobs-ready']
			log "beanstalk queue #todo=#{todo}"
			return if todo==0
			sleep 5
		end
	end

	def log msg
		puts "[#{Time.now}] QUEUER: #{msg}"
	end

end

raise "usage: ./queuer.rb file_to_read_ids_from file_to_write_done_ids_to" unless ARGV.length==2
STDERR.puts "warning, no UID_PWD set!! see curl.rb" unless ENV['UID_PWD']
Queuer.new(*ARGV).run
