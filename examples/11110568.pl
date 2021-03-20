#!/bin/perl -w
use strict;
$_ = shift // '';  # line 3
s{a([bc])}         # 4
 {d$1}g;           # 5
print;             # 6
