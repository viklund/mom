use v6;

use Test;
plan 1;

use Markup::Minimal;
use MOM::Emitter::HTML;

my $converter = Markup::Minimal.new;

my @pars =
  "==heading 1==",
  "par 1",
  "== heading 2 ==",
  "== heading 3 ==",
  "par 2";
my $input           = join "\n\n", @pars;
my $expected_output = join "\n\n",
   '<h1>heading 1</h1>',
   '<p>par 1</p>',
   '<h1>heading 2</h1>',
   '<h1>heading 3</h1>',
   '<p>par 2</p>';
my $actual_output = MOM::Emitter::HTML.emit( $converter.format($input) );

is( $actual_output, $expected_output, 'mixing paragraphs and headings works' );

# vim:ft=perl6
