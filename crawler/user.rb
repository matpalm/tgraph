require 'rubygems'
require 'json'

class User

	def initialize tid, web_cache
		@tid = tid
		@web_cache = web_cache
	end

	def valid?
		name && screen_name
	end

	def name
		return @name if @name
		xml = @web_cache.user_info_xml_for(@tid)
		xml =~ /<name>(.*?)<\/name>/
		@name ||= $1
	end

	def screen_name
		return @screen_name if @screen_name
		xml = @web_cache.user_info_xml_for(@tid)
		xml =~ /<screen_name>(.*)<\/screen_name>/
		@screen_name ||= $1
	end

	def friends
		@friends ||= JSON.parse(@web_cache.friends_of_json(@tid))
		@friends = [] if @friends.is_a?(Hash) && !@friends['error'].nil?
		@friends
	end
	
	def friend_cost
		return 0 if friends.size==0
		Math.log(friends.size) / Math.log(10)		
	end

end
