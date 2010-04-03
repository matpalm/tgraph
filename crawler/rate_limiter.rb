require 'rubygems'
require 'json'
require 'date'
require 'curl'

class RateLimiter
  
  def initialize
    @recheck_required = true
  end
  
  def checkpoint
    recheck_with_twitter if @recheck_required		
    if @allowed > 0
      @allowed -=1
      STDERR.puts "RATELIMIT: allowed now #{@allowed}"
    else
      block_until_reset_time
      @recheck_required = true
      checkpoint
    end
  end
  
  def recheck_with_twitter
    STDERR.puts "RATELIMIT: recheck_with_twitter"
    while true
      begin
        json = curl 'http://twitter.com/account/rate_limit_status.json'
        limit_info = JSON.parse(json)		
        @allowed = limit_info['remaining_hits']
        @reset_time = DateTime.parse limit_info['reset_time']				
        @recheck_required = false
        return
      rescue Exception => e
        STDERR.puts "RATELIMIT: problem checking rate limit?? #{Time.now} #{e.backtrace}"
        sleep 60
      end
    end
  end
  
  def block_until_reset_time
    while DateTime.now < @reset_time
      minutes_till_reset = ((@reset_time - DateTime.now)*24*60).to_i
      STDERR.puts "RATELIMIT: sleeping #{minutes_till_reset} minutes until #{@reset_time}"
      sleep (minutes_till_reset*60)+2 # err margin
    end
  end

end
