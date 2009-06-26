grammar Markup::Minimal::Grammar {
    token TOP { ^ [<heading> || <parchunk>+] $ };

    token heading { '==' <parchunk>+ '==' };

    token parchunk { <twext> || <wikimark> || <metachar> || <malformed> };

    # RAKUDO: a token may not be called 'text' [perl #57864]
    token twext { [ <.alnum> || <.otherchar> || <.whitespace> ]+ };

    token otherchar { <[ !..% (../ : ; ? @ \\ ^..` {..~ ]> };

    token whitespace { ' ' | \n };

    token wikimark { '[[' \s?  <link> [\s+ <link_title>]? \s? ']]' };
    
    regex link { <[:/._@\-0..9]+alpha>+ };
    regex link_title { <-[\]]>+ };

    token metachar { '<' || '>' || '&' || \' }; #'

    token malformed { '[' || ']' }
}

class Markup::Minimal {

    use MOM::AST;

    method format($text) {
        my $wi = MOM::AST.new( 'Markup::Minimal' );
        my @pars = grep { $_ ne "" },
                    map { $_.subst( / ^ \n /, '' ) },
                    $text.split( /\n\n/ );

        my @formatted;
        for @pars -> $par {

            Markup::Minimal::Grammar.parse($par);

            if $/ {

                if $/<heading> {
                    my $heading = ~$/<heading><parchunk>[0];
                    $heading .= subst( / ^ \s+ /, '' );
                    $heading .= subst( / \s+ $ /, '' );
                    $wi.add_node('heading', $heading);
                }
                else {
                    my $node = $wi.add_node('paragraph');

                    for $/<parchunk> {
                        if $_<twext> { 
                            $node.add_text( $_<twext> );
                        }
                        elsif $_<wikimark> {
                            my $text = $_<wikimark><link_title>;
                            $text //= ~$_<wikimark><link>;
                            my $n = $node.add_node('link', 
                                           target => ~$_<wikimark><link>
                                ).add_text( $text );
                            #$n.add_text( $text ) if $text;
                        }
                        elsif $_<metachar>  { 
                            # Maybe the MOM::AST should take care of
                            # this
                            $node.add_text( quote($_<metachar>) ); 
                        }
                        elsif $_<malformed> { 
                            $node.add_text( $_<malformed> );
                        }
                    }
                }
            }
            else {
                warn 'Could not parse paragraph.';
            }

        }
        return $wi;
    }

    sub quote($metachar) {
        # RAKUDO: Chained trinary operators do not do what we mean yet.
        return '&#039;' if $metachar eq '\'';
        return '&lt;'   if $metachar eq '<';
        return '&gt;'   if $metachar eq '>';
        return '&amp;'  if $metachar eq '&';
        return $metachar;
    }
}


# vim:ft=perl6
