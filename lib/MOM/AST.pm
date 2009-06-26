use v6;

# Need to predeclare these so the hash can pick them up.
class MOM::AST            { }
class MOM::AST::Link      is MOM::AST { }
class MOM::AST::Heading   is MOM::AST { } # Will have level
class MOM::AST::Paragraph is MOM::AST { }

enum MOM::End < Paragraph Link Heading Str >;

class MOM::AST is also {
    has $.parent;
    has @.children        is rw;
    has %.html_attributes is rw;

    my %types = {
        paragraph => MOM::AST::Paragraph,
        link      => MOM::AST::Link,
        heading   => MOM::AST::Heading,
    };

    method add_node($type, *@A, *%H) {
        #warn "Adding $type";
        my $C = %types{$type};
        my $node = $C.new( parent => self, |%H );
        push @!children, $node;
        for @A {
            when Str { $node.children.push: $_ }
            default  { warn "Don't know what to do with a {$_.WHAT}" }
        }
        #for %H.kv -> $k, $v {
        #    warn "    {self.WHAT} Adding $k => $v";
        #    $node.$k = $v;
        #}
        return $node;
    }

    method add_text($str) {
        @.children.push: ~$str;
    }

    method to_string( $indent = 0, *%extra_info ) {
        say ' ' x $indent, "{self.WHAT}.new( ";
        if $.parent { say ' ' x $indent, "    parent => MOM::AST.new( ... )," }
        for %extra_info.pairs {
            say ' ' x $indent,"    ",.fmt("%s => %s");
        }
        if @!children {
            say ' ' x $indent, "    children => [";
            for @!children { 
                when MOM::AST { .to_string( $indent+8)   }
                default        { say ' ' x $indent+8, $_.perl; }
            }
            say ' ' x $indent, "    ]";
        }
        say ' ' x $indent, ')';
    }

    method as_stream() {
        my @stream = ();
        @stream.push: self;
        for @!children {
            when Str { @stream.push: $_ }
            default  { @stream.push: .as_stream() }
        }
        @stream.push: do given self {
            when MOM::AST::Paragraph { MOM::End::Paragraph }
            when MOM::AST::Link      { MOM::End::Link }
            when MOM::AST::Heading   { MOM::End::Heading }
            when MOM::AST            { MOM::End }
        };
        return @stream;
    }
}

class MOM::AST::Link is also {
    has $.target is rw;
    has $.title  is rw;

    method to_string( $indent = 0 ) {
        nextwith(self, $indent, target => $!target, title => $!title );
    }
}

# vim: ft=perl6
