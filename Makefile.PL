use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/Lingua/JA/Gairaigo.pm';
my $repo = 'https://github.com/benkasminbullock/Lingua-JA-Gairaigo';

WriteMakefile (
    NAME => 'Lingua::JA::Gairaigo',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
);
