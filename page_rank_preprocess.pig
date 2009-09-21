edges = load 'edges' as (from:chararray, to:chararray);
nodes = group edges by from;
node_contribs = foreach nodes generate group, 1.0 / (double)SIZE(edges) as contrib;
store node_contribs into 'node_contribs';
zero_contribs = foreach nodes generate group, (double)0 as contrib;
store zero_contribs into 'zero_contribs';
