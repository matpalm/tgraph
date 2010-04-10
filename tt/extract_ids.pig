-- load initial records
records = load '$input' as (u1:long,u2:long);

-- group by uids and generate frequency table
grouped = group records by (u1,u2);
freq = foreach grouped generate flatten(group), SIZE(records) as freq;

-- rejig ids so that first is always the lower value
ids_in_order = foreach freq generate (u1>u2 ? u2 : u1), (u1>u2 ? u1 : u2), freq;

-- regroup; which give grouping of two sizes; 
--  size=1 when there were a,b records
--  size=2 when there were a,b records and b,a records
-- we are interested in the second set
ids_grouped = group ids_in_order by (u1,u2);
bidir = filter ids_grouped by SIZE(ids_in_order)==2;

-- generate with minimum frequency of a,b and b,a records
min_freq = foreach bidir generate flatten(group), MIN(ids_in_order.freq) as freq;

-- select only the top N
min_freq_sorted = order min_freq by freq desc;
store min_freq_sorted into '$output';

-- only top 100
--top_n = limit min_freq_sorted 100;
--store top_n into '$output';
