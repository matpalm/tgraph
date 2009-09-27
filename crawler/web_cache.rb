require 'fileutils'

WEB_CACHE_DIR = 'cache'

class TwitterInfo

	def initialize cache_filename, fetch_url, rate_limiter
		@cache_filename = "#{WEB_CACHE_DIR}/#{cache_filename}" 
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
		FileUtils.mkdir_p(WEB_CACHE_DIR) unless File.exists? WEB_CACHE_DIR
		@rate_limiter = RateLimiter.new
	end

	def friends_of_json id
		TwitterInfo.new(
			"friends.#{id}.json", 
			"http://twitter.com/friends/ids.json?id=#{id}",
			@rate_limiter
			).fetch
	end

	def user_info_xml_for id
		TwitterInfo.new(
			"user_info.#{id}.xml", 
			"http://twitter.com/users/show.xml?id=#{id}",
			@rate_limiter
			).fetch
	end

	def invalidate_for id
		`rm #{WEB_CACHE_DIR}/*#{id}*`
	end

end

