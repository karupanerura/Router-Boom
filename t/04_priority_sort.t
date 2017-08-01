use strict;
use warnings;

use Test::More;
use Router::Boom;

sub set_route {
    my $r = shift;
    $r->add('/*',          'e');
    $r->add('/{d:[0-9]+}', 'd');
    $r->add('/{c}',        'c');
    $r->add('/:b',         'b');
    $r->add('/a',          'a');
}

subtest 'disabled' => sub {
    my $r = Router::Boom->new();
    set_route($r);
    is [$r->match('/c/c/c/c')]->[0], 'e';
    is [$r->match('/0')]->[0],       'e';
    is [$r->match('/b')]->[0],       'e';
    is [$r->match('/a')]->[0],       'e';
};

subtest 'enabled' => sub {
    my $r = Router::Boom->new(enable_priority_sort => 1);
    set_route($r);
    is [$r->match('/c/c/c/c')]->[0], 'e';
    is [$r->match('/0')]->[0],       'd';
    is [$r->match('/b')]->[0],       'b';
    is [$r->match('/a')]->[0],       'a';
};

done_testing;

