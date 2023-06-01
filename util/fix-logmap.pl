#!/usr/bin/perl
print "subject_id\tobject_id\tconfidence\tpredicate_id\n";
while(<>) {
    next unless m@:.*:@;
    chomp;
    s@http://purl.obolibrary.org/obo/(\S+)_@$1:@g;
    print $_;
    print "\tskos:exactMatch\n";
}
