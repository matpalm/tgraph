raw = load '$input' as (id:chararray, u1:chararray, u2:chararray);
without_ids = foreach raw generate u1,u2;
no_dups = filter without_ids by u1 != u2;
pairs = group no_dups by (u1,u2);
pair_frequency = foreach pairs generate flatten(group), SIZE(no_dups) as freq;
ordered_pairs = foreach pair_frequency generate
	(group::u1<group::u2 ? group::u1 : group::u2) as u1,
	(group::u1<group::u2 ? group::u2 : group::u1) as u2,
	freq;
ordered_pairs_grouped = group ordered_pairs by (u1,u2);
min_pairs = foreach ordered_pairs_grouped generate flatten(group), MIN(ordered_pairs.freq) as freq;
store min_pairs into '$output';
