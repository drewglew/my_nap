use utf8;
package my_nap::Schema::Result::Outfit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

my_nap::Schema::Result::Outfit

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

=head1 TABLE: C<outfit>

=cut

__PACKAGE__->table("outfit");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tag_name

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tag_name",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 clothesoutfits

Type: has_many

Related object: L<my_nap::Schema::Result::Clothesoutfit>

=cut

__PACKAGE__->has_many(
  "clothesoutfits",
  "my_nap::Schema::Result::Clothesoutfit",
  { "foreign.outfit_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 clothes

Type: many_to_many

Composing rels: L</clothesoutfits> -> clothe

=cut

__PACKAGE__->many_to_many("clothes", "clothesoutfits", "clothe");


# Created by DBIx::Class::Schema::Loader v0.07039 @ 2014-01-21 00:53:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SEazvnT7vsaI5rw7bKFPZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
