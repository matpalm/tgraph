require 'rubygems'
require 'json'
require 'mongo'

class MongoCache

  def initialize
    mongo = Mongo::Connection.new
    db = mongo.db 'conversations'
    @col = db['conversations']
  end

  def search_for user
    user_results = @col.find("user" => user).first
    STDERR.puts "cache #{user_results.nil? ? "miss":"hit"} for #{user}"
    return user_results["search_results"] unless user_results.nil?

    api_result = `curl -s 'http://search.twitter.com/search.json?q=@#{user}&rpp=100'`
    search_results = JSON::parse(api_result)["results"]
    @col.insert({ "user" => user, "search_results" => search_results })
    search_results
  end

end
