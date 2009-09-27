require 'json'
require 'date'

class RateLimiter

	def initialize
		@recheck_required = true
	end

	def checkpoint
		recheck_with_twitter if @recheck_required
		if @allowed > 0
			@allowed -=1
			puts "RATELIMIT: allowed now #{@allowed}"
		else
			block_until_reset_time
			@recheck_required = true
			checkpoint
		end
	end

	def recheck_with_twitter
		json = `curl -s http://twitter.com/account/rate_limit_status.json`
		limit_info = JSON.parse(json)		
		@allowed = limit_info['remaining_hits']
		@reset_time = DateTime.parse limit_info['reset_time']
	end

	def block_until_reset_time
		while DateTime.now < @reset_time
			minutes_till_reset = ((@reset_time - DateTime.now)*24*60).to_i
			puts "RATELIMIT: sleeping #{minutes_till_reset} minutes until #{@reset_time}"
			sleep (minutes_till_reset*60)+2 # err margin
		end
	end

end
