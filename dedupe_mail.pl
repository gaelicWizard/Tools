#!/usr/bin/perl

sub main {
    foreach my $mbox (@ARGV) {
        my $messageDir = "$mbox/Messages";

        opendir(MBOX, $messageDir) || die "Couldn't opendir $messageDir: $!\n";
        my @messages = grep !/^\./, readdir(MBOX);
        closedir(MBOX);

        my %filenames;
        foreach my $message (@messages) {
            my $filename = "$messageDir/$message";
            my $id;

            open(MESSAGE, $filename) || die "Couldn't open $filename $!\n";
            while( <MESSAGE> ) {
                if( /^Message-ID:\s+(.+)$/i ) {
                    $id = $1;
                }

                # Only look at the headers
                last if( /^\s*$/ );
            }
            close(MESSAGE);

            if( ! defined($id) ) {
                warn "No Message-ID in $filename.\n";
                next;
            }

            if( exists $filenames{$id} ) {
                unlink $filename || die "Couldn't unlink $filename: $!\n";
            } else {
                $filenames{$id} = $filename;
            }
        }
    }
}

&main;