#!/usr/bin/perl -w

$hostname=`hostname`;
chomp $hostname;
$xauthority=$ENV{'HOME'}.'/.Xauthority';
undef $/; # read the whole file in a variable
open IN,$xauthority;
$_=;
s/^x01x00x00x0d([^x00]+)/x01x00x00x0d$hostname/;
print "Old hostname in ~/.Xauthority was $1, replaced by $hostname";
rename $xauthority, "$xauthority.back";
open OUT, ">$xauthority";
print OUT;
exit;
