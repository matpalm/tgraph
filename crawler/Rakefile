require 'db'
desc "rebuild db"
task :init_db do
	db = Db.new
	db.drop_tables
	db.init_tables
end

