# ----------------------------------------------------------------
    package XML::FeedPP;
    use strict;
    use Carp;
    use Time::Local;
    use XML::TreePP;
#   use warnings;
# ----------------------------------------------------------------
    use vars qw( $VERSION $XMLNS );
    $VERSION = "0.05";
# ----------------------------------------------------------------

=head1 NAME

XML::FeedPP -- Parse/write/merge web feeds, RSS/RDF/Atom

=head1 SYNOPSIS

Get a RSS file and parse it.

    my $source = 'http://use.perl.org/index.rss';
    my $feed = XML::FeedPP->new( $source );
    print "Title: ", $feed->title(), "\n";
    print "Date: ", $feed->pubDate(), "\n";
    foreach my $item ( $feed->get_item() ) {
        print "URL: ", $item->link(), "\n";
        print "Title: ", $item->title(), "\n";
    }

Generate a RDF file and save it.

    my $feed = XML::FeedPP::RDF->new();
    $feed->title( "use Perl" );
    $feed->link( "http://use.perl.org/" );
    $feed->pubDate( "Thu, 23 Feb 2006 14:43:43 +0900" );
    my $item = $feed->add_item( "http://search.cpan.org/~kawasaki/XML-TreePP-0.02" );
    $item->title( "Pure Perl implementation for parsing/writing xml file" );
    $item->pubDate( "2006-02-23T14:43:43+09:00" );
    $feed->to_file( "index.rdf" );

Merge some RSS/RDF files and convert it into Atom format.

    my $feed = XML::FeedPP::Atom->new();                # create empty atom file
    $feed->merge( "rss.xml" );                          # load local RSS file
    $feed->merge( "http://www.kawa.net/index.rdf" );    # load remote RDF file
    my $now = time();
    $feed->pubDate( $now );                             # touch date
    my $atom = $feed->to_string();                      # get Atom source code

=head1 DESCRIPTION

XML::FeedPP module parses a RSS/RDF/Atom file, converts its format,
marges another files, and generates a XML file.
This module is a pure Perl implementation and do not requires any other modules
expcept for XML::FeedPP.

=head1  METHODS

=head2  $feed = XML::FreePP->new( 'index.rss' );

This constructor method creates a instance of the XML::FeedPP.
The format of $source must be one of the supported feed fromats: RSS, RDF or Atom.
The first arguments is the file name on the local file system.

=head2  $feed = XML::FreePP->new( 'http://use.perl.org/index.rss' );

The URL on the remote web server is also available as the first argument.
LWP::UserAgent module is required to download it.

=head2  $feed = XML::FreePP->new( '<?xml?><rss version="2.0"><channel>....' );

The XML source code is also available as the first argument.

=head2  $feed = XML::FreePP::RSS->new( $source );

This constructor method creates a instance for RSS format.
The first argument is optional.
This method returns a empty instance when $source is not defined.

=head2  $feed = XML::FreePP::RDF->new( $source );

This constructor method creates a instance for RDF format.
The first argument is optional.
This method returns a empty instance when $source is not defined.

=head2  $feed = XML::FreePP::Atom->new( $source );

This constructor method creates a instance for Atom format.
The first argument is optional.
This method returns a empty instance when $source is not defined.

=head2  $feed->load( $source );

Load RSS/RDF/Atom file.

=head2  $feed->merge( $source );

Merge RSS/RDF/Atom file into the existing $feed instance.

=head2  $string = $feed->to_string( $encoding );

This method generates XML source as string and returns it.
The output $encoding is optional and the default value is 'UTF-8'.
On Perl 5.8 and later, any encodings supported by Encode module are available.
On Perl 5.005 and 5.6.1, four encodings supported by Jcode module are only
available: 'UTF-8', 'Shift_JIS', 'EUC-JP' and 'ISO-2022-JP'.
But normaly, 'UTF-8' is recommended to the compatibilities.

=head2  $feed->to_file( $filename, $encoding );

This method generate XML file.
The output $encoding is optional and the default value is 'UTF-8'.

=head2  $item = $feed->add_item( $url );

This method creates new item/entry and returns its instance.
First argument $link is the URL of the new item/entry.
RSS's <item> element is a instance of XML::FeedPP::RSS::Item class.
RDF's <item> element is a instance of XML::FeedPP::RDF::Item class.
Atom's <entry> element is a instance of XML::FeedPP::Atom::Entry class.

=head2  $item = $feed->get_item( $num );

This method returns items in the feed.
If $num is defined, this method returns the $num-th item's object.
If $num is not defined, this method returns the list of all items
on array context or the number of items on scalar context.

=head2  $feed->xmlns( 'xmlns:media' => 'http://search.yahoo.com/mrss' );

This code sets the XML namespace at the document root of the feed.

=head2  $url = $feed->xmlns( 'xmlns:media' );

This code returns the URL of the specified XML namespace.

=head2  @list = $feed->xmlns();

This code returns the list of all XML namespace used in the feed.

=head1  METHODS FOR CHANNEL/FEED

=head2  $feed->title( $text );

This method sets/gets the feed's <title> value.
This method returns the current value when the $title is not defined.

=head2  $feed->description( $html );

This method sets/gets the feed's <description> value in HTML.
This method returns the current value when the $html is not defined.

=head2  $feed->pubDate( $date );

This method sets/gets the feed's <pubDate> value for RSS,
<dc:date> value for RDF, or <created> value for Atom.
This method returns the current value when the $date is not defined.
See also the DATE/TIME FORMATS section.

=head2  $feed->copyright( $text );

This method sets/gets the feed's <copyright> value for RSS/Atom,
or <dc:rights> element for RDF.
This method returns the current value when the $text is not defined.

=head2  $feed->link( $url );

This method sets/gets the URL of the web site
as the feed's <link> value for RSS/RDF/Atom.
This method returns the current value when the $url is not defined.

=head2  $feed->language( $lang );

This method sets/gets the feed's <language> value for RSS,
<dc:language> element for RDF, or <feed xml:lang=""> attribute for Atom.
This method returns the current value when the $lang is not defined.

=head2  $feed->image( $url, $title, $link, $description, $width, $height )

This method sets/gets the feed's <image> value and its child nodes
for RSS/RDF. This method is ignored for Atom.
This method returns the current values as array when any arguments are not defined.

=head1  METHODS FOR ITEM/ENTRY

=head2  $item->title( $text );

This method sets/gets the item's <title> value.
This method returns the current value when the $text is not defined.

=head2  $item->description( $html );

This method sets/gets the item's <description> value in HTML.
This method returns the current value when the $text is not defined.

=head2  $item->pubDate( $date );

This method sets/gets the item's <pubDate> value for RSS,
<dc:date> element for RDF, or <modified> element for Atom.
This method returns the current value when the $text is not defined.
See also the DATE/TIME FORMATS section.

=head2  $item->category( $text );

This method sets/gets the item's <category> value for RSS/RDF.
This method is ignored for Atom.
This method returns the current value when the $text is not defined.

=head2  $item->author( $text );

This method sets/gets the item's <author> value for RSS,
<creator> value for RDF, or <author><name> value for Atom.
This method returns the current value when the $text is not defined.

=head2  $item->guid( $guid, isPermaLink => $bool );

This method sets/gets the item's <guid> value for RSS
or <id> value for Atom.
This method is ignored for RDF.
The second argument is optional.
This method returns the current value when the $guid is not defined.

=head2  $item->set( $key => $value, ... );

This method sets some node values or attributes.
See also the next section: GENERAL SET/GET

=head2  $value = $item->get( $key );

This method returns the node value or attribute.
See also the next section: GENERAL SET/GET

=head2  $link = $item->link();

This method returns the item's <link> value.

=head1  GENERAL SET/GET

XML::FeedPP understands only <rdf:*>, <dc:*> modules
and RSS/RDF/ATOM's default namespaces.
There are NO native methods for any other external modules,
such as <media:*>.
But set()/get() methods are available to get/set the value of
any elements or attributes for these modules.

=head2  $item->set( 'module:name' => $value );

This code sets the value of the child node:
<item><module:name>$value

=head2  $item->set( 'module:name@attr' => $value );

This code sets the value of the child node's attribute:
<item><module:name attr="$value">

=head2  $item->set( '@attr' => $value );

This code sets the value of the item's attribute:
<item attr="$value">

=head2  $item->set( 'hoge/pomu@hare' => $value );

This code sets the value of the child node's child node's attribute:
<item><hoge><pomu attr="$value">

=head1  DATE/TIME FORMATS

XML::FeedPP allows you to describe date/time by three formats following:

=head2  $date = "Thu, 23 Feb 2006 14:43:43 +0900";

The first format is the format preferred for the HTTP protocol.
This is the native format of RSS 2.0 and one of the formats defined by RFC 1123.

=head2  $date = "2006-02-23T14:43:43+09:00";

The second format is the W3CDTF format.
This is the native format of RDF and one of the formats defined by ISO 8601.

=head2  $date = 1140705823;

Last format is the number of seconds since the epoch, 1970-01-01T00:00:00Z.
You know, this is the native format of Perl's time() function.

=head1 MODULE DEPENDENCIES

XML::FeedPP module requires only XML::TreePP module,
which is a pure Perl implementation as well.
LWP::UserAgent module is also required to download a file from remote web server.
Jcode module is required to convert Japanese encodings on Perl 5.006 and 5.6.1.
Jcode module is NOT required on Perl 5.8.x and later.

=head1 AUTHOR

Yusuke Kawasaki, E<lt>u-suke [at] kawa.netE<gt>
http://www.kawa.net/works/perl/feedpp/feedpp-e.html

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006 Yusuke Kawasaki.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut
# ----------------------------------------------------------------
    my $RSS_VERSION = '2.0';
    my $RDF_VERSION = '2.0';
    my $ATOM_VERSION = '0.3';
    my $XMLNS_RDF  = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
    my $XMLNS_RSS  = 'http://purl.org/rss/1.0/';
    my $XMLNS_DC   = 'http://purl.org/dc/elements/1.1/';
    my $XMLNS_ATOM = 'http://purl.org/atom/ns#';
    my $XMLNS_NOCOPY = [qw( xmlns xmlns:rdf xmlns:dc xmlns:atom )];
# ----------------------------------------------------------------
    my $TREEPP_OPTIONS = {
        force_array => [qw( item rdf:li dc:subject entry )],
        last_out    => [qw( item items entry -width -height )],
    };
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $source = shift;
    my $self = {};
    bless $self, $package;
    Carp::croak "No feed source." unless defined $source;
    $self->load( $source );
    if ( exists $self->{rss} ) {
        $self->init_rss();
    } elsif ( exists $self->{'rdf:RDF'} ) {
        $self->init_rdf();
    } elsif ( exists $self->{feed} ) {
        $self->init_atom();
    } else {
        my $root = join( " ", sort keys %$self );
        Carp::croak "Invalid feed format: $root";
    }
    $self;
}
# ----------------------------------------------------------------
sub feed_bless {
    my $package = shift;
    my $self = shift;
    bless $self, $package;
    $self;
}
# ----------------------------------------------------------------
sub load {
    my $self = shift;
    my $source = shift;
    my $tree;
    my $tpp = XML::TreePP->new( %$TREEPP_OPTIONS );
    if ( $source =~ m#^https?://# ) {
        # print "Loading via HTTP: $source\n";
        $tree = $tpp->parsehttp( GET => $source );
    } elsif ( $source =~ m#<\?xml.*\?>#i ) {
        # print "Parsing XML source: $source\n";
        $tree = $tpp->parse( $source );
    } elsif ( -f $source ) {
        # print "Loading from file: $source\n";
        $tree = $tpp->parsefile( $source );
    }
    Carp::croak "Invalid feed source: $source" unless ref $tree;
    %$self = %$tree;        # override
    $self;
}
# ----------------------------------------------------------------
sub to_string {
    my $self = shift;
    my $encode = shift;
    my $tpp = XML::TreePP->new( output_encoding => $encode, %$TREEPP_OPTIONS );
    $tpp->write( $self, $encode );
}
# ----------------------------------------------------------------
sub to_file {
    my $self = shift;
    my $file = shift;
    my $encode = shift;
    my $tpp = XML::TreePP->new( output_encoding => $encode, %$TREEPP_OPTIONS );
    $tpp->writefile( $file, $self, $encode );
}
# ----------------------------------------------------------------
sub merge {
    my $self = shift;
    my $source = shift;
    my $target = XML::FeedPP->new( $source );

    if ( ref $self eq ref $target ) {
        $self->merge_native_channel( $target );
        $self->merge_native_items( $target );
    } else {
        $self->merge_common_channel( $target );
        $self->merge_common_items( $target );
    }
    undef;
}
# ----------------------------------------------------------------
sub merge_native_items {
    my $self = shift;
    my $target = shift;
    my $map1 = { map {$_->link()=>$_} $self->get_item() };
    foreach my $item2 ( $target->get_item ) {
        my $link2 = $item2->link();
        my $item1 = $map1->{$link2} || $self->add_item( $link2 );
        XML::FeedPP::Util::merge_hash( $item1, $item2 );
    }
}
# ----------------------------------------------------------------
sub merge_common_channel {
    my $self = shift;
    my $target = shift;

    my $title1 = $self->title();
    my $title2 = $target->title();
    $self->title( $title2 ) if ( ! defined $title1 && defined $title2 );

    my $description1 = $self->description();
    my $description2 = $target->description();
    $self->description( $description2 ) if ( ! defined $description1 && defined $description2 );

    my $link1 = $self->link();
    my $link2 = $target->link();
    $self->link( $link2 ) if ( ! defined $link1 && defined $link2 );

    my $language1 = $self->language();
    my $language2 = $target->language();
    $self->language( $language2 ) if ( ! defined $language1 && defined $language2 );

    my $copyright1 = $self->copyright();
    my $copyright2 = $target->copyright();
    $self->copyright( $copyright2 ) if ( ! defined $copyright1 && defined $copyright2 );

    my $pubDate1 = $self->pubDate();
    my $pubDate2 = $target->pubDate();
    $self->pubDate( $pubDate2 ) if ( ! defined $pubDate1 && defined $pubDate2 );

    my @image1 = $self->image();
    my @image2 = $target->image();
    $self->image( @image2 ) if ( ! defined $image1[0] && defined $image2[0] );

    my @xmlns1 = $self->xmlns();
    my @xmlns2 = $target->xmlns();
    my $xmlchk = { map {$_=>1} @xmlns1, @$XMLNS_NOCOPY };
    foreach my $ns ( @xmlns2 ) {
        next if exists $xmlchk->{$ns};
        $self->xmlns( $ns, $target->xmlns($ns) );
    }

    $self->merge_module_nodes( $self->docroot, $target->docroot );

    $self;
}
# ----------------------------------------------------------------
sub merge_common_items {
    my $self = shift;
    my $target = shift;

    foreach my $item2 ( $target->get_item() ) {
        my $link2 = $item2->link() or return;
        my $item1 = $self->add_item( $link2 );

        my $title2 = $item2->title();
        $item1->title( $title2 ) if defined $title2;

        my $description2 = $item2->description();
        $item1->description( $description2 ) if defined $description2;

        my $category2 = $item2->category();
        $item1->category( $category2 ) if defined $category2;

        my $author2 = $item2->author();
        $item1->author( $author2 ) if defined $author2;

        my $guid2 = $item2->guid();
        $item1->guid( $guid2 ) if defined $guid2;

        my $pubDate2 = $item2->pubDate();
        $item1->pubDate( $pubDate2 ) if defined $pubDate2;

        $self->merge_module_nodes( $item1, $item2 );
    }
    $self;
}
# ----------------------------------------------------------------
sub merge_module_nodes {
    my $self = shift;
    my $item1 = shift;
    my $item2 = shift;
    foreach my $key ( grep {/:/} keys %$item2 ) {
        next if ( $key =~ /^-?(dc|rdf|xmlns):/ );
        # deep copy would be more better
        $item1->{$key} = $item2->{$key};
    }
}
# ----------------------------------------------------------------
sub xmlns {
    my $self = shift;
    my $ns = shift;
    my $url = shift;
    my $root = $self->docroot;
    if ( ! defined $ns ) {
        my $list = [ grep {/^-xmlns(:\S|$)/} keys %$root ];
        return map {(/^-(.*)$/)[0]} @$list;
    } elsif ( ! defined $url ) {
        return undef unless exists $root->{'-'.$ns};
        return $root->{'-'.$ns};
    } else {
        $root->{'-'.$ns} = $url;
    }
}
# ----------------------------------------------------------------
sub get_xmlns {
    my $self = shift;
    my $ns = shift;
    $self->{feed}->{'-'.$ns} if exists $self->{feed}->{'-'.$ns};
}
# ----------------------------------------------------------------
sub init_rss {
    my $self = shift or return;
    XML::FeedPP::RSS->feed_bless( $self );

    $self->{rss} ||= {};
    $self->{rss}->{'-version'} ||= $RSS_VERSION;

    $self->{rss}->{channel} ||= XML::FeedPP::Element->new();
    XML::FeedPP::Element->ref_bless( $self->{rss}->{channel} );

    $self->{rss}->{channel}->{item} ||= [];
    if ( UNIVERSAL::isa( $self->{rss}->{channel}->{item}, "HASH" )) {
        # only one item
        $self->{rss}->{channel}->{item} = [ $self->{rss}->{channel}->{item} ];
    }
    foreach my $item ( @{$self->{rss}->{channel}->{item}} ) {
        XML::FeedPP::RSS::Item->ref_bless( $item );
    }

    $self;
}
# ----------------------------------------------------------------
sub init_rdf {
    my $self = shift or return;
    XML::FeedPP::RDF->feed_bless( $self );

    $self->{'rdf:RDF'} ||= {};
    $self->xmlns( "xmlns"     => $XMLNS_RSS );
    $self->xmlns( "xmlns:rdf" => $XMLNS_RDF );
    $self->xmlns( "xmlns:dc"  => $XMLNS_DC  );

    $self->{'rdf:RDF'}->{channel} ||= XML::FeedPP::Element->new();
    XML::FeedPP::Element->ref_bless( $self->{'rdf:RDF'}->{channel} );

    $self->{'rdf:RDF'}->{channel}->{items} ||= {};
    $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'} ||= {};

    my $rdfseq = $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'};
    $rdfseq->{'rdf:li'} ||= [];
    if ( UNIVERSAL::isa( $rdfseq->{'rdf:li'}, "HASH" )) {
        $rdfseq->{'rdf:li'} = [ $rdfseq->{'rdf:li'} ];
    }
    $self->{'rdf:RDF'}->{item} ||= [];
    if ( UNIVERSAL::isa( $self->{'rdf:RDF'}->{item}, "HASH" )) {
        # force array when only one item exist
        $self->{'rdf:RDF'}->{item} = [ $self->{'rdf:RDF'}->{item} ];
    }
    foreach my $item ( @{$self->{'rdf:RDF'}->{item}} ) {
        XML::FeedPP::RDF::Item->ref_bless( $item );
    }

    $self;
}
# ----------------------------------------------------------------
sub init_atom {
    my $self = shift or return;
    XML::FeedPP::Atom->feed_bless( $self );

    $self->{feed} ||= XML::FeedPP::Element->new();
    XML::FeedPP::Element->ref_bless( $self->{feed} );

    $self->xmlns( "xmlns"   => $XMLNS_ATOM );

    $self->{feed}->{entry} ||= [];
    if ( UNIVERSAL::isa( $self->{feed}->{entry}, "HASH" )) {
        # only one item
        $self->{feed}->{entry} = [ $self->{feed}->{entry} ];
    }
    foreach my $item ( @{$self->{feed}->{entry}} ) {
        XML::FeedPP::Atom::Entry->ref_bless( $item );
    }

    $self;
}
# ----------------------------------------------------------------
    package XML::FeedPP::RSS;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP" );
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $source = shift;
    my $self = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load( $source );
        if ( ! ref $self || ! ref $self->{rss} ) {
            Carp::croak "Invalid RSS format: $source";
        }
    }
    $self->init_rss();
    $self;
}
# ----------------------------------------------------------------
sub merge_native_channel {
    my $self = shift;
    my $tree = shift;

    XML::FeedPP::Util::merge_hash( $self->{rss},
        $tree->{rss}, qw( channel ) );
    XML::FeedPP::Util::merge_hash( $self->{rss}->{channel},
        $tree->{rss}->{channel}, qw( item ) );
}
# ----------------------------------------------------------------
sub add_item {
    my $self = shift;
    my $link = shift;
    Carp::croak "add_item needs a argument.\n" unless defined $link;
    my $item = XML::FeedPP::RSS::Item->new();
    $item->link( $link );
    push( @{$self->{rss}->{channel}->{item}}, $item );
    $item;
}
# ----------------------------------------------------------------
sub get_item {
    my $self = shift;
    my $num = shift;
    $self->{rss}->{channel}->{item} ||= [];
    if ( defined $num ) {
        return $self->{rss}->{channel}->{item}->[$num];
    } elsif ( wantarray ) {
        return @{$self->{rss}->{channel}->{item}};
    } else {
        return scalar @{$self->{rss}->{channel}->{item}};
    }
}
# ----------------------------------------------------------------
sub docroot { shift->{rss}; }
sub channel { shift->{rss}->{channel}; }
sub set { shift->{rss}->{channel}->set( @_ ); }
sub get { shift->{rss}->{channel}->get( @_ ); }
# ----------------------------------------------------------------
sub title { shift->{rss}->{channel}->get_or_set( "title", @_ ); }
sub description { shift->{rss}->{channel}->get_or_set( "description", @_ ); }
sub link { shift->{rss}->{channel}->get_or_set( "link", @_ ); }
sub language { shift->{rss}->{channel}->get_or_set( "language", @_ ); }
sub copyright { shift->{rss}->{channel}->get_or_set( "copyright", @_ ); }
# ----------------------------------------------------------------
sub pubDate {
    my $self = shift;
    my $date = shift;
    if ( ! defined $date ) {
        $date = $self->{rss}->{channel}->get_value( "pubDate" );
        $date = XML::FeedPP::Util::rfc1123_to_w3cdtf( $date );
        return $date;
    }
    $date = XML::FeedPP::Util::get_rfc1123( $date );
    $self->{rss}->{channel}->set_value( "pubDate", $date );
}
# ----------------------------------------------------------------
sub image {
    my $self = shift;
    my $url = shift;
    if ( defined $url ) {
        my( $title, $link, $desc, $width, $height ) = @_;
        $self->{rss}->{channel}->{image} ||= {};
        my $image = $self->{rss}->{channel}->{image};
        $image->{url}         = $url;
        $image->{title}       = $title  if defined $title;
        $image->{link}        = $link   if defined $link;
        $image->{description} = $desc if defined $desc;
        $image->{width}       = $width  if defined $width;
        $image->{height}      = $height if defined $height;
    } elsif ( exists $self->{rss}->{channel}->{image} ) {
        my $image = $self->{rss}->{channel}->{image};
        my $array = [];
        foreach my $key (qw( url title link description width height )) {
            push( @$array, exists $image->{$key} ? $image->{$key} : undef );
        }
        return wantarray ? @$array : shift @$array;
    }
    undef;
}
# ----------------------------------------------------------------
    package XML::FeedPP::RSS::Item;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP::Element" );
# ----------------------------------------------------------------
sub title { shift->get_or_set( "title", @_ ); }
sub description { shift->get_or_set( "description", @_ ); }
sub link { shift->get_or_set( "link", @_ ); }
sub category { shift->get_or_set( "category", @_ ); }
sub author { shift->get_or_set( "author", @_ ); }
sub guid { shift->get_or_set( "guid", @_ ); }
# ----------------------------------------------------------------
sub pubDate {
    my $self = shift;
    my $date = shift;
    if ( ! defined $date ) {
        $date = $self->get_value( "pubDate" );
        $date = XML::FeedPP::Util::rfc1123_to_w3cdtf( $date );
        return $date;
    }
    $date = XML::FeedPP::Util::get_rfc1123( $date );
    $self->set_value( "pubDate", $date );
}
# ----------------------------------------------------------------
    package XML::FeedPP::RDF;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP" );
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $source = shift;
    my $self = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load( $source );
        if ( ! ref $self || ! ref $self->{'rdf:RDF'} ) {
            Carp::croak "Invalid RDF format: $source";
        }
    }
    $self->init_rdf();
    $self;
}
# ----------------------------------------------------------------
sub merge_native_channel {
    my $self = shift;
    my $tree = shift;

    XML::FeedPP::Util::merge_hash( $self->{'rdf:RDF'},
        $tree->{'rdf:RDF'}, qw( channel item ) );
    XML::FeedPP::Util::merge_hash( $self->{'rdf:RDF'}->{channel},
        $tree->{'rdf:RDF'}->{channel}, qw( items ) );
}
# ----------------------------------------------------------------
sub add_item {
    my $self = shift;
    my $link = shift;

    my $rdfli = XML::FeedPP::Element->new();
    $rdfli->{'-rdf:resource'} = $link;
    $self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'} ||= [];
    push( @{$self->{'rdf:RDF'}->{channel}->{items}->{'rdf:Seq'}->{'rdf:li'}}, $rdfli );

    my $item = XML::FeedPP::RDF::Item->new( @_ );
    $item->link( $link );
    push( @{$self->{'rdf:RDF'}->{item}}, $item );

    $item;
}

# ----------------------------------------------------------------
sub get_item {
    my $self = shift;
    my $num = shift;
    $self->{'rdf:RDF'}->{item} ||= [];
    if ( defined $num ) {
        return $self->{'rdf:RDF'}->{item}->[$num];
    } elsif ( wantarray ) {
        return @{$self->{'rdf:RDF'}->{item}};
    } else {
        return scalar @{$self->{'rdf:RDF'}->{item}};
    }
}
# ----------------------------------------------------------------
sub docroot { shift->{'rdf:RDF'}; }
sub channel { shift->{'rdf:RDF'}->{channel}; }
sub set { shift->{'rdf:RDF'}->{channel}->set( @_ ); }
sub get { shift->{'rdf:RDF'}->{channel}->get( @_ ); }
# ----------------------------------------------------------------
sub title { shift->{'rdf:RDF'}->{channel}->get_or_set( "title", @_ ); }
sub description { shift->{'rdf:RDF'}->{channel}->get_or_set( "description", @_ ); }
sub link { shift->{'rdf:RDF'}->{channel}->get_or_set( "link", @_ ); }
sub language { shift->{'rdf:RDF'}->{channel}->get_or_set( "dc:language", @_ ); }
sub copyright { shift->{'rdf:RDF'}->{channel}->get_or_set( "dc:rights", @_ ); }
# ----------------------------------------------------------------
sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->{'rdf:RDF'}->{channel}->get_value( "dc:date" ) unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf( $date );
    $self->{'rdf:RDF'}->{channel}->set_value( "dc:date", $date );
}
# ----------------------------------------------------------------
sub image {
    my $self = shift;
    my $url = shift;
    if ( defined $url ) {
        my( $title, $link ) = @_;
        $self->{'rdf:RDF'}->{image} ||= {};
        $self->{'rdf:RDF'}->{image}->{'-rdf:resource'} = $url;
        $self->{'rdf:RDF'}->{channel}->{image} ||= {};
        my $image = $self->{'rdf:RDF'}->{image};
        $image->{url}         = $url;
        $image->{title}       = $title  if defined $title;
        $image->{link}        = $link   if defined $link;
    } elsif ( exists $self->{'rdf:RDF'}->{image} ) {
        my $image = $self->{'rdf:RDF'}->{image};
        my $array = [];
        foreach my $key (qw( url title link )) {
            push( @$array, exists $image->{$key} ? $image->{$key} : undef );
        }
        return wantarray ? @$array : shift @$array;
    }
    undef;
}
# ----------------------------------------------------------------
    package XML::FeedPP::RDF::Item;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP::Element" );
# ----------------------------------------------------------------
sub title { shift->get_or_set( "title", @_ ); }
sub description { shift->get_or_set( "description", @_ ); }
sub category { shift->get_or_set( "category", @_ ); }
sub author { shift->get_or_set( "creator", @_ ); }
# ----------------------------------------------------------------
sub link {
    my $self = shift;
    my $link = shift;
    return $self->get_value( "link" ) unless defined $link;
    $self->{'-rdf:about'} = $link;
    $self->set_value( "link", $link, @_ );
}
sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_value( "dc:date" ) unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf( $date );
    $self->set_value( "dc:date", $date );
}
sub guid { undef; }          # this element is NOT supported for RDF
# ----------------------------------------------------------------
    package XML::FeedPP::Atom;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP" );
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $source = shift;
    my $self = {};
    bless $self, $package;
    if ( defined $source ) {
        $self->load( $source );
        if ( ! ref $self || ! ref $self->{feed} ) {
            Carp::croak "Invalid Atom format: $source";
        }
    }
    $self->init_atom();
    $self;
}
# ----------------------------------------------------------------
sub merge_native_channel {
    my $self = shift;
    my $tree = shift;

    XML::FeedPP::Util::merge_hash( $self->{feed}, $tree->{feed}, qw( entry ) );
}
# ----------------------------------------------------------------
sub add_item {
    my $self = shift;
    my $link = shift;

    my $item = XML::FeedPP::Atom::Entry->new( @_ );
    $item->link( $link );
    push( @{$self->{feed}->{entry}}, $item );

    $item;
}
# ----------------------------------------------------------------
sub get_item {
    my $self = shift;
    my $num = shift;
    $self->{feed}->{entry} ||= [];
    if ( defined $num ) {
        return $self->{feed}->{entry}->[$num];
    } elsif ( wantarray ) {
        return @{$self->{feed}->{entry}};
    } else {
        return scalar @{$self->{feed}->{entry}};
    }
}
# ----------------------------------------------------------------
sub docroot { shift->{feed}; }
sub channel { shift->{feed}; }
sub set { shift->{feed}->set( @_ ); }
sub get { shift->{feed}->get( @_ ); }
# ----------------------------------------------------------------
sub title {
    my $self = shift;
    my $title = shift;
    return $self->{feed}->get_value( "title" ) unless defined $title;
    $self->{feed}->set_value( "title" => $title, type => "text/plain" );
}
sub description {
    my $self = shift;
    my $desc = shift;
    return $self->{feed}->get_value( "tagline" ) unless defined $desc;
    $self->{feed}->set_value( "tagline" => $desc, type => "text/html", mode => "escaped" );
}
sub link {
    my $self = shift;
    my $link = shift;

    my $node = $self->{feed}->{link} || [];
    $node = [ $node ] if UNIVERSAL::isa( $node, "HASH" );
    my $html = ( grep { ! ref $_ || ! exists $_->{'-type'} ||
                        $_->{'-type'} =~ m#^text/(x-)?html#i } @$node )[0];

    if ( defined $link ) {
        if ( ref $html ) {
            $html->{'-href'} = $link;
        } else{
            $self->{feed}->set_attr( "link",
                href    =>  $link,
                type    =>  "text/html",
                rel     =>  "alternative" );
        }
    } elsif ( ref $html ) {
        return $html->{'-href'};
    } else {
        return $html;
    }
    undef;
}
sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->{feed}->get_value( "modified" ) unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf( $date );
    $self->{feed}->get_or_set( "modified", $date );
}
sub language {
    my $self = shift;
    my $lang = shift;
    return $self->{feed}->{'-xml:lang'} unless defined $lang;
    $self->{feed}->{'-xml:lang'} = $lang;
}
sub copyright {
    shift->{feed}->get_or_set( "copyright" => @_ );
}
sub image { undef; }          # this element is NOT supported for Atom
# ----------------------------------------------------------------
    package XML::FeedPP::Atom::Entry;
    use vars qw( @ISA );
    @ISA = ( "XML::FeedPP::Element" );
# ----------------------------------------------------------------
sub title {
    my $self = shift;
    my $title = shift;
    return $self->get_value( "title" ) unless defined $title;
    $self->set_value( "title" => $title, type => "text/plain" );
}
sub description {
    my $self = shift;
    my $desc = shift;
    return $self->get_value( "content" ) unless defined $desc;
    $self->set_value( "content" => $desc, type => "text/html", mode => "escaped" );
}
sub link {
    my $self = shift;
    my $link = shift;
    my $node = $self->{link} || [];
    $node = [ $node ] if UNIVERSAL::isa( $node, "HASH" );
    my $html = ( grep { ! ref $_ || ! exists $_->{'-type'} ||
                        $_->{'-type'} =~ m#^text/(x-)?html#i} @$node )[0];

    if ( defined $link ) {
        if ( ref $html ) {
            $html->{'-href'} = $link;
        } else{
            $self->set_attr( "link",
                href    =>  $link,
                type    =>  "text/html",
                rel     =>  "alternative" );
        }
    } elsif ( ref $html ) {
        return $html->{'-href'};
    } else {
        return $html;
    }
}
sub pubDate {
    my $self = shift;
    my $date = shift;
    return $self->get_value( "created" ) unless defined $date;
    $date = XML::FeedPP::Util::get_w3cdtf( $date );
    $self->set_value( "created", $date );
}
sub author {
    my $self = shift;
    my $name = shift;
    unless ( defined $name ) {
        my $author = $self->{author}->{name} if ref $self->{author};
        return $author;
    }
    my $author = ref $name ? $name : { name => $name };
    $self->{author} = $author;
}
sub guid { shift->get_or_set( "id", @_ ); }
sub category { undef; }          # this element is NOT supported for Atom
# ----------------------------------------------------------------
    package XML::FeedPP::Element;
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $self = {@_};
    bless $self, $package;
    $self;
}
# ----------------------------------------------------------------
sub ref_bless {
    my $package = shift;
    my $self = shift;
    bless $self, $package;
    $self;
}
# ----------------------------------------------------------------
sub set {
    my $self = shift;

    while ( scalar @_ ) {
        my $key = shift @_;
        my $val = shift @_;
        my $node = $self;
        while ( $key =~ s#^([^/]+)/##s ) {
            my $child = $1;
            if ( ref $node->{$child} ) {
                # ok
            } elsif ( defined $node->{$child} ) {
                $node->{$child} = { "#text" => $node->{$child} };
            } else {
                $node->{$child} = {};
            }
            $node = $node->{$child};
        }
        my( $tagname, $attr ) = split( /\@/, $key, 2 );
        if ( $tagname eq "" && defined $attr ) {
            $node->{'-'.$attr} = $val;
        } elsif ( defined $attr ) {
            if ( ref $node->{$tagname} ) {
                $node->{$tagname}->{'-'.$attr} = $val;
            } elsif ( defined $node->{$tagname} ) {
                $node->{$tagname} = {
                    "#text"     =>  $node->{$tagname},
                    '-'.$attr   =>  $val,
                };
            } else {
                $node->{$tagname} = {
                    '-'.$attr   =>  $val,
                };
            }
        } elsif ( defined $tagname ) {
            if ( ref $self->{$tagname} ) {
                $node->{$tagname}->{'#text'} = $val;
            } else {
                $node->{$tagname} = $val;
            }
        }
    }
}
# ----------------------------------------------------------------
sub get {
    my $self = shift;
    my $key = shift;
    my $node = $self;

    while ( $key =~ s#^([^/]+)/##s ) {
        my $child = $1;
        return undef unless ref $node;
        return undef unless exists $node->{$child};
        $node = $node->{$child};
    }
    my( $tagname, $attr ) = split( /\@/, $key, 2 );
    return undef unless exists $node->{$tagname};
    if ( defined $attr ) {                      # attribute
        return undef unless ref $node->{$tagname};
        return undef unless exists $node->{$tagname}->{'-'.$attr};
        return $node->{$tagname}->{'-'.$attr};
    } else {                                    # node value
        return $node->{$tagname} unless ref $node->{$tagname};
        return $node->{$tagname}->{'#text'};
    }
}
# ----------------------------------------------------------------
sub get_or_set {
    my $self = shift;
    my $elem = shift;
    return scalar @_
        ? $self->set_value($elem,@_)
        : $self->get_value($elem);
}
# ----------------------------------------------------------------
sub get_value {
    my $self = shift;
    my $elem = shift;
    return undef unless exists $self->{$elem};
    return $self->{$elem} unless ref $self->{$elem};
    return $self->{$elem}->{'#text'};
}
# ----------------------------------------------------------------
sub set_value {
    my $self = shift;
    my $elem = shift;
    my $text = shift;
    my $attr = \@_;
    if ( ref $self->{$elem} ) {
        $self->{$elem}->{'#text'} = $text;
    } else {
        $self->{$elem} = $text;
    }
    $self->set_attr( $elem, @$attr ) if scalar @$attr;
    undef;
}
# ----------------------------------------------------------------
sub get_attr {
    my $self = shift;
    my $elem = shift;
    my $key = shift;
    return undef unless exists $self->{$elem};
    return undef unless ref $self->{$elem};
    return undef unless exists $self->{$elem}->{'-'.$key};
    $self->{$elem}->{'-'.$key};
}
# ----------------------------------------------------------------
sub set_attr {
    my $self = shift;
    my $elem = shift;
    my $attr = \@_;
    if ( defined $self->{$elem} ) {
        if ( ! ref $self->{$elem} ) {
            $self->{$elem} = { "#text" => $self->{$elem} };
        }
    } else {
        $self->{$elem} = {};
    }
    while ( scalar @$attr ) {
        my $key = shift @$attr;
        my $val = shift @$attr;
        if ( defined $val ) {
            $self->{$elem}->{'-'.$key} = $val;
        } else {
            delete $self->{$elem}->{'-'.$key};;
        }
    }
    undef;
}
# ----------------------------------------------------------------
    package XML::FeedPP::Util;
# ----------------------------------------------------------------
    my( @DoW, @MoY, %MoY );
    @DoW = qw(Sun Mon Tue Wed Thu Fri Sat);
    @MoY = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    @MoY{map {uc($_)} @MoY} = (1..12);
# ----------------------------------------------------------------
sub epoch_to_w3cdtf {
    my $epoch = shift;
    return unless defined $epoch;
    my( $sec, $min, $hour, $day, $mon, $year ) = gmtime( $epoch );
    $year += 1900;
    $mon ++;
    sprintf( "%04d-%02d-%02dT%02d:%02d:%02dZ",
        $year, $mon, $day, $hour, $min, $sec );
}
# ----------------------------------------------------------------
sub epoch_to_rfc1123 {
    my $epoch = shift;
    return unless defined $epoch;
    my( $sec, $min, $hour, $mday, $mon, $year, $wday ) = gmtime( $epoch );
    $year += 1900;
    sprintf( "%s, %02d %s %04d %02d:%02d:%02d GMT",
        $DoW[$wday], $mday, $MoY[$mon], $year, $hour, $min, $sec);
}
# ----------------------------------------------------------------
sub rfc1123_to_w3cdtf {
    my $str = shift;
    return unless defined $str;
    my( $mday, $mon, $year, $hour, $min, $sec, $tz ) = ( $str =~ m{
        ^(?:[A-Za-z]+,\s*)? (\d+)\s+ ([A-Za-z]+)\s+ (\d+)\s+
        (\d+):(\d+):(\d+)\s* ([\+\-]\d+:?\d{2})?
    }x );
    return unless ( $year && $mon && $mday );
    $mon = $MoY{uc($mon)} or return;
    if ( defined $tz && $tz =~ m/^([\+\-]\d+):?(\d{2})$/ ) {
        $tz = sprintf( "%+03d:%02d", $1, $2 );
    } else {
        $tz = "Z";
    }
    sprintf( "%04d-%02d-%02dT%02d:%02d:%02d%s",
        $year, $mon, $mday, $hour, $min, $sec, $tz );
}
# ----------------------------------------------------------------
sub w3cdtf_to_rfc1123 {
    my $str = shift;
    return unless defined $str;
    my( $year, $mon, $mday, $hour, $min, $sec, $tz ) = ( $str =~ m{
        ^(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)([\+\-]\d+:?\d{2})?
    }x );
    return unless ( $year > 1900 && $mon && $mday );
    my $epoch = Time::Local::timegm( $sec, $min, $hour, $mday, $mon-1, $year-1900 );
#   if ( $tz =~ m/^([\+\-]\d+):?(\d{2})$/ ) {
#       $epoch -= $1 * 3660 + $2 * 60;              # time zone
#   }
    my $wday = (gmtime( $epoch ))[6];
    if ( defined $tz && $tz =~ m/^([\+\-]\d+):?(\d{2})$/ ) {
        $tz = sprintf( "%+03d%02d", $1, $2 );
    } else {
        $tz = "GMT";
    }
    sprintf( "%s, %02d %s %04d %02d:%02d:%02d %s",
        $DoW[$wday], $mday, $MoY[$mon-1], $year, $hour, $min, $sec, $tz );
}
# ----------------------------------------------------------------
sub get_w3cdtf {
    my $date = shift;
    if ( $date =~ /^\d+$/s ) {
        return &epoch_to_w3cdtf( $date );
    } elsif ( $date =~ /^([A-Za-z]+,\s*)?\d+\s+[A-Za-z]+\s+\d+\s+\d+:\d+:\d+/s ) {
        return &rfc1123_to_w3cdtf( $date );
    } elsif ( $date =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[Z\+\-]/s ) {
        return $date;
    }
    undef;
}
# ----------------------------------------------------------------
sub get_rfc1123 {
    my $date = shift;
    if ( $date =~ /^\d+$/s ) {
        return &epoch_to_rfc1123( $date );
    } elsif ( $date =~ /^([A-Za-z]+,\s*)?\d+\s+[A-Za-z]+\s+\d+\s+\d+:\d+:\d+/s ) {
        return $date;
    } elsif ( $date =~ /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[Z\+\-]/s ) {
        return &w3cdtf_to_rfc1123( $date );
    }
    undef;
}
# ----------------------------------------------------------------
sub merge_hash {
    my $base = shift or return;
    my $merge = shift or return;
    my $map = { map {$_=>1} @_ };
    foreach my $key ( keys %$merge ) {
        next if exists $map->{$key};
        $base->{$key} = $merge->{$key};
    }
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
