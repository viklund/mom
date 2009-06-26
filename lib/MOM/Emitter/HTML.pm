use MOM::Emitter;
use MOM::AST;
class MOM::Emitter::HTML is MOM::Emitter {
    method emit(MOM::AST $m) {
        my $str = join '', gather for $m.as_stream() {
            when MOM::AST::Paragraph { take "<p>"  }
            when MOM::End::Paragraph { take "</p>\n\n" }

            when MOM::AST::Heading   { take "<h1>" }
            when MOM::End::Heading   { take "</h1>\n\n" }

            when MOM::AST::Link      { take "<a href=\"{ .target }\">" }
            when MOM::End::Link      { take "</a>" }

            when Str                 { take $_ }

            when MOM::AST            { }
            when MOM::End            { }
            default                  { warn "OOpsi: {$_.perl}" }
        }
        return $str.subst( / [ \n | \s ]+ $ /, '' );
    }
}

# vim: ft=perl6
