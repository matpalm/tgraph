require 'fileutils'

WEB_CACHE_DIR = 'cache'
HASH_BUCKETS = 20

class TwitterInfo

	def initialize id, cache_filename, fetch_url, rate_limiter
		@cache_filename = "#{WEB_CACHE_DIR}/#{id % HASH_BUCKETS}/#{cache_filename}" 
		@fetch_url = fetch_url
		@rate_limiter = rate_limiter
	end

	def fetch
		download unless File.exists? @cache_filename
		File.read(@cache_filename)
	end

	def download
		puts "cache miss for #{@fetch_url}"		
		@rate_limiter.checkpoint
		cmd = "curl -s #{@fetch_url} -o #{@cache_filename}"
		puts cmd
		`#{cmd}`
		#sleep 30
	end

end

class WebCache

	def initialize
		if !File.exists? WEB_CACHE_DIR
			FileUtils.mkdir_p(WEB_CACHE_DIR) 
			HASH_BUCKETS.times { |n| FileUtils.mkdir_p("#{WEB_CACHE_DIR}/#{n}") }
		end
		@rate_limiter = RateLimiter.new
	end

	def friends_of_json id
		TwitterInfo.new(
			id,
			"friends.#{id}.json", 
			"http://twitter.com/friends/ids.json?id=#{id}",
			@rate_limiter
			).fetch
	end

	def user_info_xml_for id
		TwitterInfo.new(
			id,
			"user_info.#{id}.xml", 
			"http://twitter.com/users/show.xml?id=#{id}",
			@rate_limiter
			).fetch
	end

	def invalidate_for id
		`rm #{WEB_CACHE_DIR}/*#{id}*`
	end

end

