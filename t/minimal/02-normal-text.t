use v6;

use Test;
plan 1;

use Markup::Minimal;
use MOM::Emitter::HTML;
my $converter = Markup::Minimal.new;

my $input           = 'normal text';
my $expected_output = '<p>normal text</p>';
my $actual_output   = MOM::Emitter::HTML.emit( $converter.format($input) );

is( $actual_output, $expected_output, 'normal text goes through unchanged' );

# vim:ft=perl6
