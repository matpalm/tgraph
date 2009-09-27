#!/usr/bin/env ruby

class Pr

	D = 0.85

	def initialize g
		@g = g
		@pr = {}
		@g.keys.each { |n| @pr[n] = 1.0 }
	end

	def step
		puts @pr.inspect
		pr2 = {}
		@g.keys.each do |k| 
			pr2[k] = 0
		end
		pr2.keys.each do |n|
			out = @g[n]
			out_degree = @g[n].size
			current_pr = @pr[n]
			pass_on = current_pr / out_degree
			out.each do |n2|
				pr2[n2] ||= 0
				pr2[n2] += pass_on
			end
		end
		pr2.keys.each do |k| 
			pr2[k] = (1-D) + D * pr2[k] 
		end
		@pr = pr2
	end

	def dump_sorted
		sorted = []
		@pr.each { |k,v| sorted << [k,v] }	
		puts sorted.inspect
		sorted = sorted.sort { |a,b| b[1] <=> a[1] }
		sorted.each { |val| puts val.inspect }
	end

end

g = {}
STDIN.each do |line|
	from,to = line.chomp.split("\t")
	g[from] ||= []
	g[from] << to
end
=begin
g = {
	:a => [:b,:c],
	:b => [:c,:d],
	:c => [:d],
	:d => []
}
=end

pr = Pr.new g
100.times { pr.step }

pr.dump_sorted

