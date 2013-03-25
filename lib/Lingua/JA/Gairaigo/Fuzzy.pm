=encoding UTF-8

=head1 NAME

Lingua::JA::Gairaigo::Fuzzy - variant spellings of foreign words in Japanese

=head1 SYNOPSIS

    use Lingua::JA::Gairaigo::Fuzzy 'same_gairaigo';
    my $same = same_gairaigo ('メインフレーム', 'メーンフレーム');

=head1 DESCRIPTION

Given two Japanese gairaigo words, guess whether they are the same
word.

=head1 FUNCTIONS

=head2 same_gairaigo

=cut

package Lingua::JA::Gairaigo::Fuzzy;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/same_gairaigo/;
%EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
use warnings;
use strict;
use Carp;
our $VERSION = 0.01;
use utf8;

use lib '/home/ben/projects/Text-Fuzzy/blib/lib';
use lib '/home/ben/projects/Text-Fuzzy/blib/arch';
use Text::Fuzzy 'fuzzy_index';
use Lingua::JA::Moji ':all';

our $verbose;# = 1;
binmode STDOUT, ":utf8";

sub same_gairaigo
{
    my ($kana, $n) = @_;
    if (chouon ($kana, $n)) {
	my $gotcha = usual_suspect ($kana, $n);
	if ($gotcha) {
	    return 1;
	}
    }
    return undef;
}

sub usual_suspect
{
    my ($kana, $n) = @_;
    my ($dist, $edits) = fuzzy_index ($kana, $n, 1);

    # Is this a likely candidate?

    my $gotcha;

    if ($edits =~ /ii|dd|rr/) {

	# Double delete, double insertion, double replace means this
	# is unlikely to be the same word.

	return;
    }
    my @kana = split //, $kana;
    my @nkana = split //, $n;
    my @edits = split //, $edits;

    # $i is the offset in @kana, and $j is the offset in @nkana.

    my $i = 0;
    my $j = 0;

    if ($verbose) {
	print "$kana -> $n via $edits\n";
    }
    for my $edit (@edits) {

	if ($edit eq 'r') {

	    # Replaced $k with $q.

	    my $k = $kana[$i];
	    my $q = $nkana[$j];
	    if ($k =~ /[ーィイ]/ && $q =~ /[ーィイ]/) {
		my $prev;

		# Check whether the previous kana ends in "e", so it
		# is something like "ヘイ" and "ヘー".

		if (ends_in_e (\@kana, $i)) {
		    $gotcha = 1;
		}
		else {
		    if ($verbose) {
			print "No e for you.\n";
		    }
		}
	    }
	    if ($k =~ /ーッ/ && $q =~ /ーッ/) {
		$gotcha = 1;
	    }
	    $i++;
	    $j++;
	}
	elsif ($edit eq 'd') {

	    # Delete $k from $kana to get $n.

	    my $k = $kana[$i];
	    if ($k eq 'ー' || $k eq '・' || $k eq 'ッ') {
		$gotcha = 1;
	    }
	    my $q = $kana[$j];
	    if ($q =~ /[ーィイ]/) {
		if (ends_in_e (\@kana, $i)) {
		    $gotcha = 1;
		}
	    }
	    $i++;
	}
	elsif ($edit eq 'i') {

	    # Character $k was inserted into $n.

	    my $k = $nkana[$j];
	    if ($k eq 'ー' || $k eq '・' || $k eq 'ッ') {
		$gotcha = 1;
	    }
	    $j++;
	}
	elsif ($edit eq 'k') {

	    # The two strings are the same at this point.

	    $i++;
	    $j++;
	}
    }

    # Check we did not make a mistake scanning the two strings.

    if ($i != scalar @kana) {
	print "Mismatch $i\n";
    }
    if ($j != scalar @nkana) {
	print "Mismatch $j\n";
    }
    return $gotcha;
}

sub ends_in_e
{
    my ($kana_ref, $i) = @_;
    my $prev;
    if ($i >= 1) {
	$prev = $kana_ref->[$i - 1];
	$prev = kana2romaji ($prev);
	if ($prev =~ /e$/) {
	    return 1;
	}
    }
    else {
	if ($verbose) {
	    print "$i no goog\n";
	}
    }
    return undef;
}

sub chouon
{
    my ($x, $y) = @_;
    my %xa = alph ($x);
    my %ya = alph ($y);
    my $found;
    my $mismatch = check (\%xa, \%ya, \$found);
    if ($mismatch) {
#	print "Mismatch $x / $y: $mismatch\n";
	return undef 
    }
    $mismatch = check (\%ya, \%xa, \$found);
    if ($mismatch) {
#	print "Mismatch $x / $y: $mismatch\n";
	return undef 
    }
    if ($found) {
	return 1;
    }
    return undef;
}

sub alph
{
    my ($x) = @_;
    my %xa;
    my @xl = split //, $x;
    @xa{@xl} = @xl;
    return %xa;
}

sub check
{
    my ($xa, $ya, $found) = @_;
    my $ok;
    for my $k (keys %$ya) {
	next if $xa->{$k};
	if ($k eq 'ー' || $k eq 'イ' || $k eq 'ィ' || $k eq '・' || $k eq 'ッ') {
#	    print "boo to a goose.\n";
	    $ok = 1;
	    next;
	}
#	print "Return $k\n";
	return $k;
    }
    if ($ok) {
#	print "OK.\n";
	$$found = $ok;
    }
    return;
}

1;
