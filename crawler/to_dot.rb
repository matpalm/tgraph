#!/usr/bin/env ruby
require 'set'
require 'mysql'

max_id = 3

@db = Mysql.init()
@db.connect('localhost','mat','mat')
@db.select_db('tgraph')

def tids_under_id id
	res = @db.query "select tid from users where id<=#{id}"
	tids = []
	while(row=res.fetch_row)
		tids << row[0].to_i
	end
	tids
end

puts tids_under_id(max_id).inspect
