use v6;

use Test;
plan 10;

use Markup::Minimal;
use MOM::Emitter::HTML;
use MOM::Transformer;
use MOM::AST;
my $converter = Markup::Minimal.new;
my $link_maker = MOM::Transformer.new( 
    MOM::AST::Link,
    {
        # $^m gets overwritten by the match BECAUSE it's a block afterwards
        # (in if), don't know if this is a bug or not, should check that
        # somehow.
        my $ma = $^m;
        if $ma.target !~~ m/':'/ {
            $ma.target = "?action=view&page=" ~ $ma.target;
        }
    }
);


{
    my $input = 'An example of a [[link]]';
    my $expected_output
        = '<p>An example of a <a href="?action=view&page=link">link</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'link conversion works' );
}

{
    my $input = 'An example of a [[ link ]]';
    my $expected_output
        = '<p>An example of a <a href="?action=view&page=link">link</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'link conversion works' );
}

{
    my $input = 'An example of a [[malformed link';
    my $expected_output = '<p>An example of a [[malformed link</p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'malformed link I' );
}

{
    my $input = 'An example of a malformed link]]';
    my $expected_output = '<p>An example of a malformed link]]</p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'malformed link II' );
}

{
    my $input = 'An example of a [[My_Page]]';
    my $expected_output
        = '<p>An example of a <a href="?action=view&page=My_Page">My_Page</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'My_Page' );
}

{
    my $input = 'An example of a [[link boo]]';
    my $expected_output
        = '<p>An example of a <a href="?action=view&page=link">boo</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'named link' );
}

{
    my $input = 'An example of a [[http://link.org boo]]';
    my $expected_output
        = '<p>An example of a <a href="http://link.org">boo</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'named external link' );
}

{
    my $input = 'and [[http://link.org/foo-12_0.pod foo-pod 12]]';
    my $expected_output
        = '<p>and <a href="http://link.org/foo-12_0.pod">foo-pod 12</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 
        'named external link with digets and dot' );
}

{
    my $input = 'An example of a [[http://link.org boo bar baz]]';
    my $expected_output
        = '<p>An example of a <a href="http://link.org">boo bar baz</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'named (long name) external link' );
}

{
    my $input = 'An example of a [[mailto:forihrd@gmail.com ihrd]]';
    my $expected_output
        = '<p>An example of a <a href="mailto:forihrd@gmail.com">ihrd</a></p>';

    my $ma = $converter.format( $input );
    $link_maker.transform( $ma );
    my $actual_output = MOM::Emitter::HTML.emit( $ma );

    is( $actual_output, $expected_output, 'mailto' );
}

# vim:ft=perl6
