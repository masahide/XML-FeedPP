use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'XML-FeedPP',
    VERSION_FROM        => 'lib/XML/FeedPP.pm',
    PREREQ_PM           => {
        'Test::More'        => '0',
        'XML::TreePP'       => '0.19',
#       'LWP::UserAgent'    => '0',
#       'HTTP::Lite'        => '0'
    },
);
