require 'rubygems'
require 'json'
require 'mongo'

class MongoCache

  def initialize
    mongo = Mongo::Connection.new
    db = mongo.db 'conversations'
    @col = db['conversations']
  end

  def search_for user, back_off = 4
    user_results = @col.find("user" => user).first
    STDERR.puts "cache #{user_results.nil? ? "miss":"hit"} for #{user}"
    return user_results["search_results"] unless user_results.nil?
    
    cmd = "curl -s 'http://search.twitter.com/search.json?q=@#{user}&rpp=100'"
    api_result = JSON::parse(`#{cmd}`)
    raise "increasing calm" if api_result["error"] || api_result["results"]==""
    search_results = api_result["results"]
    @col.insert({ "user" => user, "search_results" => search_results })
    sleep 2
    search_results 

  rescue
    STDERR.puts "oh noz, sleep for #{back_off} --> #{api_result.inspect}"
    sleep back_off
    search_for user, back_off * 1.5
  end

end
