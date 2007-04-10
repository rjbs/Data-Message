package Data::Message;
# $Id: Message.pm,v 1.1 2004/12/23 00:54:14 cwest Exp $
use strict;

use base qw[Email::Simple];
use vars qw[$VERSION];
$VERSION   = '1.01';

my $private = \q[no peeking];

sub new {
    my ($self, $message, %attrs) = @_;
    my $object = $self->SUPER::new($message);
    $object->{"$private"} = \%attrs;
    return $object;
}

sub header_set {
    my $self = shift;
    local $Email::Simple::GROUCHY = $self->{"$private"}->{grouchy};
    return $self->SUPER::header_set(@_);
}

sub _fold {
    my ($self, $line) = @_;
    return $line unless $self->{"$private"}->{fold};
    return $self->SUPER::_fold($line);
}


sub _split_head_from_body { &Email::Simple::_split_head_from_body }
sub _read_headers { &Email::Simple::_read_headers }

1;

__END__

=head1 NAME

Data::Message - Parse and Reconstruct RFC2822 Compliant Messages

=head1 SYNOPSIS

  use Data::Message;
  
  my $message = Data::Message->new(join('',<>), fold => 1);
  
  print $message->header("Customer-ID");
  print $message->body;

=head1 DESCRIPTION

This module is a generic interface to dealing with RFC2822 compliant
messages. Email is the most common example of messages in this format,
but not the only one. HTTP requests and responses are also sent and
received in this format. Many other systems rely on storing or
sending information with a header of key/value pairs followed by an
B<optional> body.

Because C<Email::Simple> is so good at parsing this format, and so
fast, this module inherits from it. Changes to the interface are only
prevelant in options provided to the constructor C<new()>. For any
other interface usage documentation, please see L<Email::Simple>.

Because C<Data::Message> is a subclass of C<Email::Simple>, its
mixins will work with this package. For example, you may use
C<Email::Simple::Creator> to aid in the creation of C<Data::Message>
objects from scratch.

=head2 new()

  my $message = Data::Message->new(join( '', <> ),
                                   fold    => 1,
                                   grouchy => 1);

The first argument is a scalar value containing the text of the
payload to be parsed. Subsequent arguments are passed as key/value
pairs.

C<fold>, which is false by default, will tell C<Data::Message> if
it should fold headers. If given a true value, headers longer than
78 characters will be folded.

C<grouchy>, which is false by default, will instruct C<Data::Message>
to complain loudly if non-ascii characters are used as header
names, when setting headers via C<header_set()>. If C<grouchy> is
true, calls to C<header_set()> should be wrapped in C<eval> as they
may die.

=head1 SEE ALSO

L<Email::Simple>,
L<Email::Simple::Creator>,
L<Email::Simple::Headers>,
L<perl>.

=head1 AUTHOR

Casey West, <F<casey@geeknest.com>>.

=head1 COPYRIGHT

  Copyright (c) 2004 Casey West.  All rights reserved.
  This module is free software; you can redistribute it and/or modify it
  under the same terms as Perl itself.

=cut
