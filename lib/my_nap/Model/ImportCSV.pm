package my_nap::Model::ImportCSV;
use Moose;
use DBI;
use namespace::autoclean;
use DBIx::TableLoader::CSV;

extends 'Catalyst::Model';

sub do_import {

	my ($self, $target, $filename) = @_;

        # hard-coded reference to DB…
        my $dbfile = "db/napdata.db";

        # limited validation on filename conversion should ideally use same method as tableloader,
        # however simple req. expecting clothing

        (my $csvtable = $filename) =~ s/\.[^.]+$//;
        my $dbh = DBI -> connect("dbi:SQLite:dbname=$dbfile","","");
        
	eval {
        	$dbh -> do("drop table $csvtable");
        };
	my $counter = DBIx::TableLoader::CSV -> new(dbh => $dbh, file => $target)->load();

        # category column name and column data are incorrectly formatted in CSV file.
	$dbh -> do("INSERT INTO clothesitem SELECT null, trim(name), trim([ category]) from $csvtable");
	$dbh -> disconnect();
	return $counter
}



=head1 NAME

my_nap::Model::ImportCSV - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.


=encoding utf8

=head1 AUTHOR

andrew glew

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
