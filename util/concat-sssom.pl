#!/usr/bin/perl
while(<>) {
    if (m@^subject_id@) {
        $n++;
        if ($n > 1) {
            next;
        }
    }
    print $_;
}
