use v6;

use Test;
plan 1;

my $used_successfully = False;
try {
    use Markup::Minimal;
    $used_successfully = True;
}

ok( $used_successfully, "use Markup::Minimal" );

# vim:ft=perl6
