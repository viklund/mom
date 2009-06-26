use v6;

use Test;
plan 4;

use Markup::Minimal;
use MOM::Emitter::HTML;

my %h =
    '<'  => 'lt',
    '>'  => 'gt',
    '&'  => 'amp',
    '\'' => '#039';

my $converter = Markup::Minimal.new;

for %h.kv -> $input, $abbr {
    my $expected_escape = '&' ~ $abbr ~ ';';
    my $expected_output = "<p>$expected_escape</p>";
    my $actual_output = MOM::Emitter::HTML.emit( $converter.format($input) );

    is( $actual_output, $expected_output, "$input -> $expected_escape" );
}

# vim:ft=perl6
