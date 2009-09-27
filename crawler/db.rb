require 'mysql'
require 'set'

class Db

	def initialize
		@db = Mysql.init()
		@db.connect('localhost','mat','mat')
		@db.select_db('tgraph')
	end

	def run_query query
		start = Time.now
		result = @db.query query
		total = Time.now - start
		puts "#{query} took #{total}"
		result
	end

	def reinit
		@db.query('drop table users;') rescue nil
		@db.query('drop table friends;') rescue nil
		@db.query('drop table frontier;') rescue nil
		init_tables
	end

	def init_tables
		@db.query('create table users (id int primary key auto_increment,tid integer, num_friends integer, name varchar(255), screen_name varchar(255), last_checked timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP );')
		@db.query('create index tid_index on users(tid);')
		#@db.query('create table friends (id int primary key auto_increment,tid integer, friend integer);')
		#@db.query('create index tid_index on friends(tid);')
		@db.query('create table frontier (id int primary key auto_increment,tid integer,depth integer,cost float,created_at timestamp DEFAULT CURRENT_TIMESTAMP);')
		@db.query('create index id_index on frontier(id);')
		@db.query('create index tid_index on frontier(tid);')
		@db.query('create index cost_index on frontier(cost);')
		@db.query('insert into frontier (tid,depth,cost) values (26970530,0,0);')
	end

	def next_to_fetch
		res = run_query "select tid, depth, cost from frontier order by cost,tid limit 1;"
		row = res.fetch_row
		to_ret = row[0].to_i, row[1].to_i, row[2].to_f
		res.free
		to_ret
	end

	def user_ids
		user_ids = Set.new
		res = run_query "select tid from users"
		while(row=res.fetch_row)
			user_ids << row[0].to_i
		end
		res.free
		user_ids		
	end

	def update_last_seen tid, num_friends, name, screen_name
		name.gsub! /'/,''
		screen_name.gsub! /'/,''
		@db.query "delete from users where tid=#{tid};"
		@db.query "insert into users (tid, num_friends, name, screen_name) values (#{tid},#{num_friends},'#{name}','#{screen_name}');"
	end

	#def add_friend tid, friend
	#	@db.query "insert into friends (tid,friend) values (#{tid},#{friend});"
	#end

	def add_to_frontier tid, depth, cost
		@db.query "insert into frontier (tid,depth,cost) values (#{tid},#{depth},#{cost});"
	end

	def remove_from_frontier tid
		run_query "delete from frontier where tid=#{tid};"
	end

	def count_of table
		res = @db.query "select count(*) from #{table};"
		row = res.fetch_row
		to_ret = row[0].to_i
		res.free
		to_ret
	end

	def in_frontier? tid
		res = @db.query "select id from frontier where tid=#{tid};"
		row = res.fetch_row
		in_frontier = !row.nil?
		res.free
		return in_frontier
	end

end

