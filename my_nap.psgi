use strict;
use warnings;

use my_nap;

my $app = my_nap->apply_default_middlewares(my_nap->psgi_app);
$app;

