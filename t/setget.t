# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 14;
    BEGIN { use_ok('XML::FeedPP') };
# ----------------------------------------------------------------
    my $ftitle = "Title of the site";
    my $fdesc  = "Description of the site";
# ----------------------------------------------------------------
	my $hash = {
		'elem1'				=>	'ELEM01',
		'elem2@attr2'		=>	'ATTR02',
		'elem3'				=>	'ELEM03',
		'elem3@attr3'		=>	'ATTR03',
		'elem4'				=>	'ELEM03',
		'elem4@attr4'		=>	'ATTR04',
		'elem4@attr5'		=>	'ATTR05',
		'elem4/elem6'		=>	'ELEM06',
		'elem7/elem8'		=>	'ELEM08',
		'elem7/elem8@attr8'	=>	'ATTR08',
		'elem7/elem8'		=>	'ELEM08',
		'elem9/elem10'		=>	'ATTR10',
		'elem9/elem11'			=>	'ELEM10',
		'elem9/elem12@attr12'	=>	'ELEM12'
	};
# ----------------------------------------------------------------
    my $feed1 = XML::FeedPP::RSS->new();
    $feed1->title( $ftitle );
	$feed1->set( %$hash );
# ----------------------------------------------------------------
	foreach my $key ( sort keys %$hash ) {
		is( $feed1->get($key), $hash->{$key}, $key );
	}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
