#!/usr/bin/perl -w
# simulate request: curl 192.168.11.106 &> /dev/null
# for ((i=1;i<=100;i+=1)); do curl 192.168.11.106 &> /dev/null; sleep 5; done &
# or
# while true; do curl 192.168.11.106 &> /dev/null; sleep 5; done &
#pattern=GET
#file=/var/log/httpd/access_log
# run it with: sudo /usr/local/bin/bloodhound.pl /etc/sysconfig/bloodhoundd.conf
# sample output:
#Pattern GET count in the file /var/log/httpd/access_log: 175
#Pattern GET count in the file /var/log/httpd/access_log: 181
#Pattern GET count in the file /var/log/httpd/access_log: 187
#Pattern GET count in the file /var/log/httpd/access_log: 193
#Pattern GET count in the file /var/log/httpd/access_log: 199
#Pattern GET count in the file /var/log/httpd/access_log: 205
#

use strict;
use warnings;

#my $config = $ARGV[0];

#my $pattern = "^pattern=";
#my $file = "^file=";

my $pattern = $ARGV[0];
my $file = $ARGV[1];

#open my $fh, '<', $config
#        or die "Error opening $config - $!\n";

#while (my $line = <$fh>) {
#        chomp $line;
#        if ($line =~ $pattern) {
#                $pattern = substr($line, index($line, "=") + 1, length($line));
#        } elsif ($line =~ $file) {
#                $file = substr($line, index($line, "=") + 1, length($line));
#        }
#}

#close($fh)
#    or warn "Unable to close the file handle: $!";

#print "$pattern\n";
#print "$file\n";
my $desc = "Pattern $pattern count in the file $file: ";
while (1) {
        #print system("egrep $pattern $file | wc -l");
        print $desc . `egrep $pattern $file | wc -l`;
        sleep 30;
}