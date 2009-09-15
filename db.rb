require 'mysql'

class Db

	def initialize
		@db = Mysql.init()
		@db.connect('localhost','mat','mat')
		@db.select_db('tgraph')
	end

	def next_to_fetch
		res = @db.query("select tid, depth, cost from frontier order by cost, random limit 1;")
    row = res.fetch_row
    to_ret = row[0].to_i, row[1].to_i, row[2].to_f
		res.free
    to_ret
	end

	def update_last_seen tid
		@db.query("delete from seen where tid=#{tid};")
		@db.query("insert into seen (tid) values (#{tid});")
	end

	def add_friend tid, friend
		@db.query("insert into friends (tid,friend) values (#{tid},#{friend});")
	end

	def add_to_frontier tid, depth, cost
		@db.query("insert into frontier (tid,depth,cost,random) values (#{tid},#{depth},#{cost},#{rand(10000)});")
	end

	def remove_from_frontier tid
		@db.query("delete from frontier where tid=#{tid};")
	end

	def visited_before? tid
		@db.query("select tid from seen where tid=#{tid};")
		@db.affected_rows == 1
	end

end

