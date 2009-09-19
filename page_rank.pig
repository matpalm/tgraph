nodes = load 'nodes' as (node:chararray, other_nodes:chararray);
page_rank = load '$input' as (node:chararray, rank:float);
nodes_page_rank = join nodes by node, page_rank by node;
page_rank_contributions = stream nodes_page_rank through `divy.rb` as (node:chararray, pr:float);
divy_groups = group page_rank_contributions by node;
next_page_rank = foreach divy_groups { generate group, 0.15+(0.85*SUM(page_rank_contributions.pr)); };
store next_page_rank into '$output';
