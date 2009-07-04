#!/usr/bin/perl
use strict;

my (@x, %p, %r);
open F, "lsof -U |";
while(<F>) 
{
    my @p = split(/\s+/, $_);
    if ($p[0] eq "Xquartz") { push @x, $p[5]; }
    $p{$p[7]} = \@p;
}

foreach my $x (@x) 
{
    if ($p{"->$x"}) 
    {
	my @p = @{$p{"->$x"}};
	$r{$p[1]} = $p[0];
    }
}

open F, "lsof -itcp:6000 | tail +2 |";
while(<F>) 
{
    my @p = split(/\s+/, $_);
    $r{$p[1]} = $p[0];
}

foreach my $r (sort {$a <=> $b} (keys %r)) 
{
    print "$r\t$r{$r}\n";
}
