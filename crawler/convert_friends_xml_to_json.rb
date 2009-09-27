DIR = ARGV[0]
`ls #{DIR}`.each do |filename|
	puts "processing #{filename}"
	filename.chomp!
	friends = []
	File.open("#{DIR}/#{filename}",'r').each do |line|
		next unless line =~ /^\<id\>/
		line =~ /<id>(.*)<\/id>/
		friends << $1.to_i
	end
	json_filename = filename.sub('xml','json')
	json_file = File.open("#{DIR}/#{json_filename}",'w')
	json_file.write("[#{friends.join(',')}]")
	json_file.close
end
