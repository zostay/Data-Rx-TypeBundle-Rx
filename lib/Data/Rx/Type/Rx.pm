use strict;
use warnings;
package Data::Rx::Type::Rx;
# ABSTRACT: an individual Rx type definition

=head1 DESCRIPTION

This is the class that actually encapsulates the Rx type alias definition. You probably want to see L<Data::Rx::TypeBundle::Rx> instead.

=head1 METHDOS

=head2 new

Constructs a new type.

=cut

sub new {
    my ($class, %options) = @_;
    bless \%options, $class;
}

=head2 type_uri

Returns the type URI that has been set for the type alias.

=cut

sub type_uri { $_[0]->{type_uri} }

=head2 new_checker

Called by L<Data::Rx> when building a schema. Builds the actual checker based upon the type definition and returns itself.

=cut

sub new_checker {
    my ($self, $schema_arg, $rx) = @_;

    $self->{checker} = $rx->make_schema($self->{as});

    return $self;
}

=head2 check

This checks to see if the given value matches the Rx type defined.

=cut

sub check {
    my ($self, $value) = @_;
    
    return $self->{checker}->check($value);
}

1;
