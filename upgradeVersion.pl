#!/usr/bin/perl
#-------------------------------------------------------------------------------
# Upgrade version numbers in build.gradle
# Philip R Brenan at appaapps dot com, Appa Apps Ltd Inc., 2022
#-------------------------------------------------------------------------------
use v5.30;
use warnings FATAL => qw(all);
use strict;
use Data::Table::Text qw(:all);

my $f = q(test/build.gradle);                                                   # Input file
my $s = readFile $f;                                                            # Read input file
   $s =~ s(1.5) (1.6)gs;                                                        # Edit file
owf $f, $s;                                                                     # Rewrite output file
