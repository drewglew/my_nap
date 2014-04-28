package my_nap::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';


__PACKAGE__->config(
    # Change default TT extension
    TEMPLATE_EXTENSION => '.tt',
    # Set the location for TT files
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER              => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.tt',
);

=head1 NAME

my_nap::View::HTML - TT View for my_nap

=head1 DESCRIPTION

TT View for my_nap.

=head1 SEE ALSO

L<my_nap>

=head1 AUTHOR

andrew glew

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
