use utf8;
package my_nap::Schema::Result::Clothesoutfit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

my_nap::Schema::Result::Clothesoutfit

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<clothesoutfit>

=cut

__PACKAGE__->table("clothesoutfit");

=head1 ACCESSORS

=head2 clothes_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 outfit_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "clothes_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "outfit_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</clothes_id>

=item * L</outfit_id>

=back

=cut

__PACKAGE__->set_primary_key("clothes_id", "outfit_id");

=head1 RELATIONS

=head2 clothe

Type: belongs_to

Related object: L<my_nap::Schema::Result::Clothesitem>

=cut

__PACKAGE__->belongs_to(
  "clothe",
  "my_nap::Schema::Result::Clothesitem",
  { id => "clothes_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 outfit

Type: belongs_to

Related object: L<my_nap::Schema::Result::Outfit>

=cut

__PACKAGE__->belongs_to(
  "outfit",
  "my_nap::Schema::Result::Outfit",
  { id => "outfit_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-21 00:53:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:cLMwuem21y3AuJiFu3PXJw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
