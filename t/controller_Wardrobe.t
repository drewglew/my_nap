use strict;
use warnings;
use Test::More;


use Catalyst::Test 'my_nap';
use my_nap::Controller::Wardrobe;

ok( request('/wardrobe')->is_success, 'Request should succeed' );
done_testing();
