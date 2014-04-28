package my_nap::Controller::Wardrobe;
use Moose;
use namespace::autoclean; 

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

my_nap::Controller::Wardrobe - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

Limitations:
1. import clothes is only appending data, would be better if user had direct option, however they can delete clothing manually if duplicates occur.
2. the visual processing in the templates is extremely simple and could be more elegant.
4. too many to list...  


=head1 METHODS

=cut


=head2 index

Not really used.

=cut

sub index :Path :Args(0) {
    	my ( $self, $c ) = @_;
    	$c -> response -> body('Matched my_nap::Controller::Wardrobe in Wardrobe.');
}

=head2 base

simple base action 

=cut

sub base :Chained('/') :PathPart('wardrobe') :CaptureArgs(0) {
    	my ($self, $c) = @_;
    	$c -> log -> debug('*** INSIDE BASE METHOD ***');
}

=head2 baseclothes

base action; loads clothes into stash.

=cut

sub baseclothes :Chained('/') :PathPart('wardrobe') :CaptureArgs(0) {
    
    	my ($self, $c) = @_;
    	# Store the ResultSet in stash so it's available for other methods
    	$c -> stash(obj => $c->model('DB::clothesitem'));
    	# Print a message to the debug log
    	$c -> log -> debug('*** INSIDE BASE CLOTHES METHOD ***');
}

=head2 clotheslist
 
Fetch all clothes objects according to search string.  Very BASIC search process. 
 
=cut
 
sub clotheslist :Chained('baseclothes') :PathPart('clotheslist') :Args(0) {
    
    	my ($self, $c) = @_;
    	my $query = $c -> req -> param('query') || "";
    	$c -> stash(query => $query);
    	$c -> stash(clothes => [$c -> stash -> {obj} -> search({name => {'like', "%$query%"}},{order_by => 'name'})]); 
    	$c -> stash -> {status_msg} = "Previously searched on criteria: $query";
    	$c -> stash(template => 'wardrobe/clotheslist.tt');
}

=head2 categorylist
 
Filter only clothing items that are contained within selected category.
 
=cut

sub categorylist :Chained('baseclothes') :PathPart('categorylist') :Args(1) {
    
    	my ($self, $c, $category) = @_;
    	my $rs = $c -> stash -> {obj} -> search({category => "$category"});
    	$c -> stash(clothes => [$rs -> all]);
    	$c -> stash -> {status_msg} = "Search on criteria: $category";
    	$c -> stash(template => 'wardrobe/categorylist.tt');	
}

=head2 deleteclothesitem

locates outfit in outfit recordset and deletes it

=cut

sub deleteclothesitem :Chained('baseclothes') :PathPart('deleteclothesitem') :Args(1) {
    
    	my ($self, $c, $clothes_id) = @_;
    	my $del_rs = $c -> stash -> {obj} -> find({id => $clothes_id});
    	$del_rs -> delete;
    	$c -> stash -> {status_msg} = "Clothing item removed from database";
    	$c -> response -> redirect($c -> uri_for('clotheslist'));
}



=head2 baseoutfit

Base outfit used by the add and deletion

=cut

sub baseoutfit :Chained('/') :PathPart('wardrobe') :CaptureArgs(0) {

    	my ($self, $c) = @_;
    	# Find the outfit and store it in the stash
    	$c -> stash(obj => $c->model('DB::outfit'));
    	$c -> log -> debug("*** INSIDE BASE OUTFIT METHOD ***");
}

=head2 outfitlist

Simple listing of outfit data for view

=cut

sub outfitlist :Chained('baseoutfit') :PathPart('outfitlist') :Args(0) {
    
    	my ($self, $c) = @_;
    	$c -> stash(outfits => [$c -> stash -> {obj} -> all]);
    	$c -> stash(template => 'wardrobe/outfitlist.tt');
}

=head2 createoutfit

Chained from baseoutfit

=cut

sub createoutfit :Chained('baseoutfit') :PathPart('createoutfit') :Args(0) {
    
    	my ($self, $c) = @_;
    	my $outfitname = $c -> req -> param('tag_name');
    	$c -> stash(outfitname => $outfitname);
    	my $ins_rs = $c -> stash -> {obj}; 
    	$ins_rs -> create({
		tag_name => "$outfitname",
	});
    	$c -> stash -> {status_msg} = "Outfit $outfitname added to database";
    	$c -> response -> redirect($c -> uri_for('outfitlist'));
}

=head2 deleteoutfit

locates outfit in outfit recordset and deletes it

=cut

sub deleteoutfit :Chained('baseoutfit') :PathPart('deleteoutfit') :Args(1) {
    
    	my ($self, $c, $outfit_id) = @_;
    	my $del_rs = $c -> stash -> {obj} -> find({id => $outfit_id});  
    	$del_rs -> delete;
    	$c -> stash -> {status_msg} = "Outfit removed from database";
    	$c -> response -> redirect($c -> uri_for('outfitlist')); 
}


=head2 baseclothesoutfit

base clothes outfit option.  Used to manage/display included/excluded outfits.

=cut

sub baseclothesoutfit :Chained('/') :PathPart('wardrobe') :CaptureArgs(0) {

	my ($self, $c) = @_;
    	# Find the clothesoutfit and store it in the stash
    	$c -> stash(obj => $c -> model('DB::clothesoutfit'));
    	$c -> log -> debug("*** INSIDE BASE CLOTHES OUTFIT METHOD ***");
}

=head2 manageoutfit

Provides us with 2 recordsets; included items and excluded clothing.  
The TT has to obtain details in 2 ways as datasets are not same.  Also passes single
record to the TT for easy access to outfit detail. 

=cut

sub manageoutfit :Chained('baseclothesoutfit') :PathPart('manageoutfit') :Args(1) {
    
    	my ($self, $c, $id) = @_;
    	my $inc_rs = $c -> stash -> {obj} -> search({outfit_id => $id});
    	$c -> stash(included => [$inc_rs -> all]);
    	my $list = $inc_rs -> get_column('clothes_id') -> as_query;
    	my $exc_rs = $c -> model('DB::clothesitem') -> search({id => { not_in => $list}});
    	$c -> stash(excluded => [$exc_rs -> all]);
    	$c -> stash(outfitdetail => $c -> model('DB::outfit') -> search({id => $id}) -> single); 
    	$c -> stash(outfit => {id => $id} );
    	$c -> stash(template => 'wardrobe/manageoutfit.tt');
}

=head2 removeclothingfromoutfit

Uses baseclothesoutfit action to obtain recordset.  Deletes record matching 
clothes_id and outfit_id in recordset.
Limited validation.  Sends user back to the impacted manage outfit action.

=cut

sub removeclothingfromoutfit :Chained('baseclothesoutfit') :PathPart('removeclothingfromoutfit') :Args(2) {
    
    	my ($self, $c, $clothes_id, $outfit_id) = @_;
    	my $del_rs = $c -> stash -> {obj} -> find({clothes_id => $clothes_id, outfit_id => $outfit_id});
    	$del_rs -> delete;
    	$c -> stash -> {status_msg} = "Clothing removed from Outfit";
    	$c -> response -> redirect($c -> uri_for('manageoutfit',$outfit_id));
}


=head2 addclothingtooutfit

Uses baseclothesoutfit action to obtain clothesoutfit recordset.  Creates a new record in DB.
No test of duplicates due to primary key {i}
Called from anchor link inside manageoutfit window 

=cut

sub addclothingtooutfit :Chained('baseclothesoutfit') :PathPart('addclothingtooutfit') :Args(2) {
    
    	my ($self, $c, $clothes_id, $outfit_id) = @_;
    	$c -> stash -> {obj} -> create({
		clothes_id => $clothes_id,
		outfit_id => $outfit_id
    	});
    	$c -> stash -> {status_msg} = "Clothing added to Outfit";
    	$c -> response -> redirect($c -> uri_for('manageoutfit',$outfit_id));
}


=head2 importclothes
 
Opens TT so user can input filename from system.  No real need to use chained base here??
 
=cut

sub importclothes :Chained('base') :PathPart('importclothes') :Args(0) {
	
	my ($self, $c) = @_;
	$c -> stash(template => 'wardrobe/importclothes.tt');
}

=head2 upload

Now call the process that loads the data from CSV into the database SQLite table <<clothesitem>>
Use of DBI and DBIx::TableLoader::CSV.  No need to use chained base here.

=cut

sub upload :Chained('base') :PathPart('upload') :Args(0) {
	
	# unsure where this code should sit.
	my ($self, $c) = @_;
	my $import = 0;
	if ($c -> request -> parameters -> {form_submit} eq 'yes' ) {
		if (my $upload = $c -> request -> upload('clothes_csv')) {

			my $filename = $upload->filename;
			my $target = $c -> config -> {uploadtmp} .  "//$filename";
			unless ($upload->link_to($target) || $upload->copy_to($target)) {
				die ("failed to copy filename to target!");			
			}
			my $import = $c -> model('ImportCSV') -> do_import($target,$filename);
		}
	}			
    	$c -> stash -> {status_msg} = "$import clothing records added to wardrobe";
    	$c -> response -> redirect($c -> uri_for('importclothes'));
}


=encoding utf8

=head1 AUTHOR

andrew glew

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
