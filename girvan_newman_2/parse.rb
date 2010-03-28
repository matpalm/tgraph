#!/usr/bin/env ruby
require 'rubygems'
require "rgl/adjacency"

def parse_from_stdin
	g = RGL::AdjacencyGraph.new
	STDIN.each do |line|
		v1, v2 = line.chomp.split "\t"
#		puts "v1=#{v1} v2=#{v2}"
		[v1, v2].each { |v| g.add_vertex v }
		g.add_edge v1, v2
	end	
	g
end

