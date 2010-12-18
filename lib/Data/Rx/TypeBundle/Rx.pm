use strict;
use warnings;
package Data::Rx::TypeBundle::Rx;
# ABSTRACT: Build types from Data::Rx schema (experimental)

use base 'Data::Rx::TypeBundle';

use Data::Rx::Type::Rx;

=head1 SYNOPSIS

  use Data::Rx;
  use Data::Rx::TypeBundle::Rx;

  my $custom_type_library = Data::Rx::TypeBundle::Rx->new;
  $custom_type_library->register_type('tag:example.com:rx/pos', {
      type => '//num',
      range => { 'min-ex' => 0 },
  });

  $custom_type_library->register_type('tag:example.com:rx/neg', {
      type => '//num',
      range => { 'max-ex' => 0 },
  });

  my $rx = Data::Rx->new({
      prefix       => { ext => 'tag:example.com:rx/' },
      type_plugins => [ $custom_type_lib ],
  });

  my $pos_checker = $rx->make_schema({ type => '/ext/pos' });

  $pos_checker->check(10);  # OK
  $pos_checker->check(0);   # NOT OK
  $pos_checker->check(-10); # NOT OK

  my $neg_checker = $rx->make_schema({ type => '/ext/neg' });

  $neg_checker->check(10);  # NOT OK
  $neg_checker->check(0);   # NOT OK
  $neg_checker->check(-10); # OK

=head1 DESCRIPTION

This provides tools for creating L<Data::Rx> type definitions. This is really just a way for creating reusable type aliases.

=head1 METHODS

=head2 new

  my $type_library = Data::Rx::TypeBundle::Rx->new;

Constructs a new type library object.

=cut

sub new {
    my ($class, $args) = @_;
    $args->{type_plugins} = [] unless $args->{type_plugins};
    my $self = { %$args };
    bless $self, $class;
}

sub _prefix_pairs {
    my $self = shift;
    return ();
}

=head2 register_type

  $type_library->register_type($type_uri, $definition);

This registers a new Rx type alias. The C<$type_uri> should be the namespace to assign the type to and the C<$definition> should be a L<Data::Rx> schema definition to assign to that type.

=cut

sub register_type {
    my ($self, $type_uri, $as) = @_;

    push @{ $self->{type_plugins} }, Data::Rx::Type::Rx->new(
        type_uri => $type_uri,
        as       => $as,
    );
}

=head2 type_plugins

Used by L<Data::Rx>. Returns all of the L<Data::Rx::Type::Rx> type plugins that have been registered.

=cut

sub type_plugins {
    my $self = shift;
    return @{ $self->{type_plugins} };
}

=head1 CAVEATS

The one thing you do need to beware of is that all of your types need to be registered before passing this object off to L<Data::Rx>. Any types registered after passing this object to the L<Data::Rx> constructor or L<Data::Rx/register_type_plugin> method will not be known to L<Data::Rx>.

=cut

1;
