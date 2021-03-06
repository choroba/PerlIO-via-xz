#!/pro/bin/perl

use 5.14.2;
use warnings;

our $VERSION = "0.01 - 20201003";
our $CMD = $0 =~ s{.*/}{}r;

use Test::More;
use IO::Compress::Xz     qw( $XzError   );
use IO::Uncompress::UnXz qw( $UnXzError );

my $txt = "Lorem ipsum dolor sit amet\n";
my $xz;

{   my $z = IO::Compress::Xz->new (\$xz) or die $XzError;
    ok ($z->print ($txt), "print");
    ok ($z->close, "close");
    }

{   my $z = IO::Uncompress::UnXz->new (\$xz) or die $UnXzError;
    ok (my $data = $z->getline, "getline");
    is ($data, $txt, "Roundtrip");
    }

{   local $/ = undef;
    my $z = IO::Uncompress::UnXz->new (\$xz) or die $UnXzError;
    ok (my $data = $z->getline, "getline \$/ = undef");
    is ($data, $txt, "Roundtrip");
    }

{   my $z = IO::Uncompress::UnXz->new (\$xz) or die $UnXzError;
    local $/ = undef;
    ok (my $data = $z->getline, "getline \$/ = undef");
    is ($data, $txt, "Roundtrip");
    }

done_testing;
