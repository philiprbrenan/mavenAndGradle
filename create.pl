#!/usr/bin/perl
#-------------------------------------------------------------------------------
# Create lots of classes
# Philip R Brenan at appaapps dot com, Appa Apps Ltd Inc., 2022
#-------------------------------------------------------------------------------
use v5.30;
use warnings FATAL => qw(all);
use strict;
use Data::Table::Text qw(:all);

my $N = $ARGV[0] // 10;                                                         # Number of classes to create
my $F = fpd qw(test src main java com appaapps test);                           # Output folder

for my $c(1..$N)                                                                # Create each class
 {my $class = "App$c";                                                          # Class name
  my @j = <<END;
package com.appaapps.test;
  public class $class {
END
  for my $l(1..$N)                                                              # Each line
   {push @j, qq(    int i$l = $l;);                                             # Some java
   }
  push @j, <<END;                                                               # Finish java
}
END
  owf fpe($F, $class, q(java)), join "\n", @j;                                  # Write to class file
 }
