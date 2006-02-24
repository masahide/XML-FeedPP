# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 38;
    BEGIN { use_ok('XML::FeedPP') };
# ----------------------------------------------------------------
    my $ftitle = "Title of the site";
    my $fdesc  = "Description of the site";
    my $fdateA = "Mon, 02 Jan 2006 03:04:05 +0600";
    my $fdateB = "2006-01-02T03:04:05+06:00";
    my $fright = "Owner of the site";
    my $flink  = "http://www.kawa.net/";
    my $flang  = "ja";
# ----------------------------------------------------------------
    my $link1 = "http://www.perl.org/";
    my $link2  = "http://use.perl.org/";
    my $link3 = "http://cpan.perl.org/";
    my $title1 = "The Perl Directory - perl.org";
    my $title2 = "use Perl: All the Perl that's Practical to Extract and Report";
    my $title3 = "The Comprehensive Perl Archive Network";
# ----------------------------------------------------------------
    my $idesc  = "Description of the first item";
    my $icate  = "Category of the first item";
    my $idateA = "Sun, 11 Dec 2005 10:09:08 -0700";
    my $idateB = "2005-12-11T10:09:08-07:00";
    my $iauthor = "Author";
    my $iguid   = "GUID";
    my $mtitle  = "Media title";
    my $mtext   = "Media text";
    my $mcredit = "Media credit";
    my $mcate   = "Media category";
    my $mcont   = "http://www.kawa.net/xp/images/mixi-3.jpg";
    my $mthumb  = "http://www.kawa.net/xp/images/xp-title-256.gif";
    my $mheight = 640;
    my $mwidth  = 480;
# ----------------------------------------------------------------
    my $feed1 = XML::FeedPP::Atom->new();
    $feed1->title( $ftitle );
    $feed1->description( $fdesc );
    $feed1->pubDate( $fdateB );
    $feed1->copyright( $fright );
    $feed1->link( $flink );
    $feed1->language( $flang );
# ----------------------------------------------------------------
    ok( 0 == $feed1->get_item(), "0 item" );
# ----------------------------------------------------------------
    my $item1 = $feed1->add_item( $link1 );
    $item1->title( $title1 );
    $item1->pubDate( $idateB );
    ok( 1 == $feed1->get_item(), "1 item" );
# ----------------------------------------------------------------
    $item1->description( $idesc );
    $item1->category( $icate );
    $item1->author( $iauthor, isPermaLink => "false" );
    $item1->guid( $iguid );
    $item1->media_title( $mtitle );
    $item1->media_text( $mtext, type => "html" );
    $item1->media_thumbnail( $mthumb, height => $mheight, width => $mwidth );
    $item1->media_content( $mcont, type => "image/gif", height => $mheight, width => $mwidth );
    $item1->media_credit( $mcredit, rold => "photographer" );
    $item1->media_category( $mcate, scheme => "urn:flickr:tags" );
# ----------------------------------------------------------------
    my $item2 = $feed1->add_item( $link2 );
    $item2->title( $title2 );
    $item2->pubDate( $idateA );
    ok( 2 == $feed1->get_item(), "2 items" );
# ----------------------------------------------------------------
    my $item3 = $feed1->add_item( $link3 );
    $item3->title( $title3 );
    $item3->pubDate( $idateA );
    ok( 3 == $feed1->get_item(), "3 items" );
# ----------------------------------------------------------------
    my $source1 = $feed1->to_string();
    my $feed2 = XML::FeedPP::Atom->new( $source1 );
    ok( 3 == $feed2->get_item(), "3 items" );
# ----------------------------------------------------------------
    is( $feed2->title(),            $ftitle,    "Atom->title()" );
    is( $feed2->description(),      $fdesc,     "Atom->description()" );
    is( $feed2->pubDate(),          $fdateB,    "Atom->pubDate()" );
    is( $feed2->copyright(),        $fright,    "Atom->copyright()" );
    is( $feed2->link(),             $flink,     "Atom->link()" );
    is( $feed2->language(),         $flang,     "Atom->language()" );
# ----------------------------------------------------------------
    my $item4 = $feed2->get_item( 0 );
# ----------------------------------------------------------------
    is( $item4->link(),             $link1,     "Entry->link()" );
    is( $item4->title(),            $title1,    "Entry->title()" );
    is( $item4->pubDate(),          $idateB,    "Entry->pubDate()" );
    is( $item4->description(),      $idesc,     "Entry->description()" );
    is( $item4->category(),         undef,      "Entry->category()" );
    is( $item4->author(),           $iauthor,   "Entry->author()" );
    is( $item4->guid(),             $iguid,     "Entry->guid()" );
    is( $item4->media_title(),      undef,      "Entry->media_title()" );
    is( $item4->media_text(),       undef,      "Entry->media_text()" );
    is( $item4->media_thumbnail(),  undef,      "Entry->media_thumbnail()" );
    is( $item4->media_credit(),     undef,      "Entry->media_credit()" );
    is( $item4->media_category(),   undef,      "Entry->media_category()" );
    is( $item4->media_content(),    undef,      "Entry->media_content()" );
# ----------------------------------------------------------------
    my $source2 = $feed1->to_string();
#   warn "\n$source2\n";
    is( $source1, $source2, "turn around - rss source." );
# ----------------------------------------------------------------
    like( $source2, qr/<title[^>]*>\s*      \Q$ftitle\E/x,  "<title>" );
    like( $source2, qr/<tagline[^>]*>\s*    \Q$fdesc\E/x,   "<tagline>" );
    like( $source2, qr/<modified[^>]*>\s*   \Q$fdateB\E/x,  "<modified>" );
    like( $source2, qr/<copyright[^>]*>\s*  \Q$fright\E/x,  "<copyright>" );
    like( $source2, qr/<link[^>]*     href="\Q$flink\E/x,   '<link href="">' );
    like( $source2, qr/<feed[^>]* xml:lang="\Q$flang\E/x,   '<feed xml:lang="">' );
# ----------------------------------------------------------------
    like( $source2, qr/<link[^>]*           href="\Q$link1\E/x,   '<link href="">' );
    like( $source2, qr/<title[^>]*>\s*            \Q$title1\E/x,  "<title>" );
    like( $source2, qr/<created[^>]*>\s*          \Q$idateB\E/x,  "<created>" );
    like( $source2, qr/<content[^>]*>\s*          \Q$idesc\E/x,   "<content>" );
#   like( $source2, qr/<category[^>]*>\s*         \Q$icate\E/x,   "<category>" );
    like( $source2, qr/<name[^>]*>\s*             \Q$iauthor\E/x, "<author><name>" );
    like( $source2, qr/<id[^>]*>\s*               \Q$iguid\E/x,   "<id>" );
#   like( $source2, qr/<media:title[^>]*>\s*      \Q$mtitle\E/x,  "<media:title>" );
#   like( $source2, qr/<media:text[^>]*>\s*       \Q$mtext\E/x,   "<media:text>" );
#   like( $source2, qr/<media:thumbnail[^>]* url="\Q$mthumb\E/x,  "<media:thumbnail>" );
#   like( $source2, qr/<media:credit[^>]*>\s*     \Q$mcredit\E/x, "<media:credit>" );
#   like( $source2, qr/<media:category[^>]*>\s*   \Q$mcate\E/x,   "<media:category>" );
#   like( $source2, qr/<media:content[^>]*\s*url="\Q$mcont\E/x,   "<media:content>" );
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
