require 'fileutils'

WEB_CACHE_DIR = '/data2/tgraph/cache'

class TwitterInfo

	def initialize cache_filename, fetch_url
		@cache_filename = "#{WEB_CACHE_DIR}/#{cache_filename}.xml" 
		@fetch_url = fetch_url
	end

	def fetch_xml
		download_xml unless File.exists? @cache_filename
		File.read(@cache_filename)
	end

	def download_xml
		puts "cache miss for #{@fetch_url}"
		cmd = "curl -s #{@fetch_url} -o #{@cache_filename}"
		puts cmd
		`#{cmd}`
		sleep 30
	end

end

class WebCache

	def initialize
		FileUtils.mkdir_p(WEB_CACHE_DIR) unless File.exists? WEB_CACHE_DIR
	end

	def friends_of_xml id
		TwitterInfo.new(
			"friends.#{id}", 
			"http://twitter.com/friends/ids.xml?id=#{id}"
			).fetch_xml
	end

	def user_info_xml_for id
		TwitterInfo.new(
			"user_info.#{id}", 
			"http://twitter.com/users/show.xml?id=#{id}"		
			).fetch_xml
	end

	def invalidate_for id
		`rm #{WEB_CACHE_DIR}/*#{id}*`
	end

end

