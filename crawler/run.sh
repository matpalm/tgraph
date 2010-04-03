set -x
rm dendrogram.jpg # to ensure stuff happened
cat ids | ../dump_users.rb > following
cat following | sort | uniq -c | perl -ne'next if /^\s+1/;split;print "$_[1]\t$_[2]\n"' | ../../only_largest_connected_component.rb > friends
cat friends | ../to_names.rb > names
cat names | ../../dotify.rb | dot -Tpng > friends.png
cat names | ../../girvan_newman_2/decompose.rb > decomposition.json
cat decomposition.json | ../../girvan_newman_2/dendrogramer.rb > dendrogram.r
R --vanilla < dendrogram.r
eog dendrogram.jpg


