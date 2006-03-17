# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 24;
    BEGIN { use_ok('XML::FeedPP') };
# ----------------------------------------------------------------
    my $date110u = 1100000000;
    my $date110w = "2004-11-09T11:33:20Z";              # 1100000000
    my $date110h = "Tue, 09 Nov 2004 11:33:20 GMT";
    my $date111w = "2005-03-05T14:20:00+09:00";         # 1110000000
    my $date111h = "Sat, 05 Mar 2005 14:20:00 +0900";
    my $date112w = "2005-06-29T08:06:30-09:00";         # 1120000000
    my $date112h = "Wed, 29 Jun 2005 08:06:30 -0900";
    my $date113w = "2005-10-23T01:53:20Z";              # 1130000000
    my $date113h = "Sun, 23 Oct 2005 01:53:20 GMT";
    my $date114w = "2006-02-15T19:40:00Z";              # 1140000000
    my $date114h = "Wed, 15 Feb 2006 19:40:00 GMT";
    my $url = "http://www.kawa.net/";
# ----------------------------------------------------------------
    my $feed1 = XML::FeedPP::RSS->new();
#   $feed1->pubDate( $date110u );
#   is( $date110w, $feed1->pubDate(), "RSS: epoch - http - w3cdtf" );
    $feed1->pubDate( $date111w );
    is( $date111w, $feed1->pubDate(), "RSS: w3cdtf - http - w3cdtf" );
    is( $date111h, $feed1->{rss}->{channel}->{pubDate}, "RSS: w3cdtf - http" );
    $feed1->pubDate( $date112w );
    is( $date112w, $feed1->pubDate(), "RSS: w3cdtf - http - w3cdtf" );
    is( $date112h, $feed1->{rss}->{channel}->{pubDate}, "RSS: w3cdtf - http" );
    $feed1->pubDate( $date113w );
    is( $date113w, $feed1->pubDate(), "RSS: w3cdtf - http - w3cdtf" );
    is( $date113h, $feed1->{rss}->{channel}->{pubDate}, "RSS: w3cdtf - http" );
    $feed1->pubDate( $date114w );
    is( $date114w, $feed1->pubDate(), "RSS: w3cdtf - http - w3cdtf" );
    is( $date114h, $feed1->{rss}->{channel}->{pubDate}, "RSS: w3cdtf - http" );
# ----------------------------------------------------------------
    my $feed2 = XML::FeedPP::RDF->new();
#   $feed2->pubDate( $date110u );
#   is( $date110w, $feed2->pubDate(), "RDF: epoch - w3cdtf" );
    $feed2->pubDate( $date111h );
    is( $date111w, $feed2->pubDate(), "RDF: http - w3cdtf" );
    $feed2->pubDate( $date112w );
    is( $date112w, $feed2->pubDate(), "RDF: http - w3cdtf" );
    $feed2->pubDate( $date113h );
    is( $date113w, $feed2->pubDate(), "RDF: http - w3cdtf" );
    $feed2->pubDate( $date114w );
    is( $date114w, $feed2->pubDate(), "RDF: http - w3cdtf" );
# ----------------------------------------------------------------
    my $feed3 = XML::FeedPP::Atom->new();
#   $feed3->pubDate( $date110u );
#   is( $date110w, $feed3->pubDate(), "Atom: epoch - w3cdtf" );
    $feed3->pubDate( $date111w );
    is( $date111w, $feed3->pubDate(), "Atom: http - w3cdtf" );
    $feed3->pubDate( $date112h );
    is( $date112w, $feed3->pubDate(), "Atom: http - w3cdtf" );
    $feed3->pubDate( $date113w );
    is( $date113w, $feed3->pubDate(), "Atom: http - w3cdtf" );
    $feed3->pubDate( $date114h );
    is( $date114w, $feed3->pubDate(), "Atom: http - w3cdtf" );
# ----------------------------------------------------------------
    $feed1->pubDate( $date110u );
    $feed2->pubDate( $date110u );
    $feed3->pubDate( $date110u );
    my $w3c1  = $feed1->get_pubDate_w3cdtf();
    my $w3c2  = $feed1->get_pubDate_w3cdtf();
    my $w3c3  = $feed1->get_pubDate_w3cdtf();
    is( $w3c1, $w3c2, "RSS/RDF: epoch - w3cdtf" );
    is( $w3c1, $w3c3, "RSS/Atom: epoch - w3cdtf" );
    my $http1 = $feed1->get_pubDate_rfc1123();
    my $http2 = $feed1->get_pubDate_rfc1123();
    my $http3 = $feed1->get_pubDate_rfc1123();
    is( $http1, $http2, "RSS/RDF: epoch - http" );
    is( $http1, $http3, "RSS/Atom: epoch - http" );
# ----------------------------------------------------------------
    my $item1 = $feed1->add_item( $url );
    my $item2 = $feed2->add_item( $url );
    my $item3 = $feed3->add_item( $url );
    $item1->pubDate( $date110h );
    $item2->pubDate( $date110h );
    $item3->pubDate( $date110h );
    is( $date110w, $item1->pubDate(), "RSS/item: http - w3cdtf" );
    is( $date110w, $item2->pubDate(), "RDF/item: http - w3cdtf" );
    is( $date110w, $item3->pubDate(), "Atom/item: http - w3cdtf" );
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
