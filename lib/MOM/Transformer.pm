use v6;

use MOM::AST;
class MOM::Transformer {
    has $.code;
    has $.node;
    multi method new( MOM::AST $node, Code $code ) {
        return self.bless( self.CREATE, node => $node, code => $code );
    }

    multi method transform( MOM::AST $ma ) {
        if $ma ~~ $!node {
            $!code( $ma );
        }
        for $ma.children -> $c { 
            self.transform( $c );
        }
    }

    multi method transform( Str $s ) {
        return;
        warn "Now we are transforming a string";
        if $!node ~~ Str {
            $!code( $s ); # don't know what this would mean
        }
    }
}

# vim: ft=perl6
