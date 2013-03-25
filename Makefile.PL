use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/Lingua/JA/Gairaigo/Fuzzy.pm';
my $repo = 'https://github.com/benkasminbullock/Lingua-JA-Gairaigo';

WriteMakefile (
    NAME => 'Lingua::JA::Gairaigo::Fuzzy',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
	'Lingua::JA::Moji' => 0,
	'Text::Fuzzy' => '0.10_03',
    },
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
        },
    },
);
