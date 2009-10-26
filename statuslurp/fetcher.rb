require 'rubygems'
require 'beanstalk-client'
require 'curl'

class Fetcher

	def initialize tweet_out		
		@tweet_out = File.new(tweet_out,'a')
		@tweet_out.sync = true
	end

	def run
		beanstalk = Beanstalk::Pool.new(['localhost:11300'])
		ok = errors = 0
		while true
			job = beanstalk.reserve
			result = curl "http://twitter.com/users/#{job.body}.json"
			if result =~ /^<!DOCTYPE/
				errors += 1
			else
				@tweet_out.puts result
				ok += 1
			end
			job.delete
			puts "[#{Time.now}] FETCHER: #{$$} >#{job} ok=#{ok} errors=#{errors}"
		end		
	end

end

raise "usage: fetcher.rb NUM_FETCHERS" unless ARGV.length==1
ARGV.first.to_i.times do |i|
	fork { Fetcher.new("fetcher.#{i}.json").run }
end
Process.waitall
