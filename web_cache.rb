require 'fileutils'

WEB_CACHE_DIR = '/data2/tgraph/cache'

class WebCache

	def initialize
		FileUtils.mkdir_p(WEB_CACHE_DIR) unless File.exists? WEB_CACHE_DIR
	end

	def friends_xml id		
		download(id) unless File.exists? filename_for(id)
		File.read(filename_for(id))
	end

	def download id
		puts "cache miss for #{id}"
		cmd = "curl -s http://twitter.com/friends/ids.xml?id=#{id} -o #{filename_for(id)}"
		puts cmd
#		sleep 5
	end

	def filename_for id
		"#{WEB_CACHE_DIR}/#{id}.xml" 
	end
end

