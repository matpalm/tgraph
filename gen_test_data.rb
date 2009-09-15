require 'web_cache'

graph = {
	1 => [2,3],
	2 => [5,6,4],
	3 => [7,8],
	4 => [6,7],
	7 => [2],
	8 => [7]
}

wc = WebCache.new
graph.keys.each do |key|
	f = File.open(wc.filename_for(key),'w')
	f.puts '<?xml version="1.0" encoding="UTF-8"?>'
	f.puts '<ids>'
	graph[key].each { |val| f.puts "<id>#{val}</id>" }
	f.puts '</ids>'
	f.close
end
