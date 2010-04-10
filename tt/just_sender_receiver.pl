#!/usr/bin/env perl
while(<>) {
    next if /^p/;
    split;
    print "$_[2]\t$_[3]\n";
}
