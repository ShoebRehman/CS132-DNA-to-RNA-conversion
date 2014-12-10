#!/usr/bin/env perl
#
#
#
# DNA Transcription -- receives a file as a command line argument and translates the DNA to RNA then transcribes the RNA into One-Letter Amino Acid sequences
#
# Written by: Shoeb Rehman
#             11/16/2014
#
# Usage Information: Run the script along with a file
#---------------------------------------------------------------------------------------------
#                       Assignment 6: DNA -> RNA -> Amino Acid Conversion
#---------------------------------------------------------------------------------------------


$^W = 1; # Turns Warnings On
use strict;

sub aaConvert{

my ($codon) = @_;
$codon = lc $codon;
my (%genetic_code) = (
        'uuu' => 'Phe', 'uuc' => 'Phe',
        'uua' => 'Leu', 'uug' => 'Leu', 'cuu' => 'Leu', 'cuc' => 'Leu', 'cua' => 'Leu', 'cug' => 'Leu',
        'auu' => 'Ile', 'auc' => 'Ile', 'aua' => 'Ile',
        'aug' => 'Met', #start codon
        'guu' => 'Val', 'guc' => 'Val', 'gua' => 'Val', 'gug' => 'Val',
        'ucu' => 'Ser', 'ucc' => 'Ser', 'uca' => 'Ser', 'ucg' => 'Ser', 'agu' => 'Ser', 'agc' => 'Ser',
        'ccu' => 'Pro', 'ccc' => 'Pro', 'cca' => 'Pro', 'ccg' => 'Pro',
        'acu' => 'Thr', 'acc' => 'Thr', 'acg' => 'Thr', 'aca' => 'Thr',
        'gcu' => 'Ala', 'gcc' => 'Ala', 'gca' => 'Ala', 'gcg' => 'Ala',
        'uau' => 'Tyr', 'uac' => 'Tyr',
        'uaa' => 'END', 'uag' => 'END', 'uga' => 'END', #Stop Codon
        'cau' => 'His', 'cac' => 'His',
        'caa' => 'Gln', 'cag' => 'Gln',
        'aau' => 'Asn', 'aac' => 'Asn',
        'aaa' => 'Lys', 'aag' => 'Lys',
        'gau' => 'Asp', 'gac' => 'Asp',
        'gaa' => 'Glu', 'gag' => 'Glu',
        'ugu' => 'Cys', 'ugc' => 'Cys',
        'ugg' => 'Trp',
        'cgu' => 'Arg', 'cgc' => 'Arg', 'cga' => 'Arg', 'cgg' => 'Arg', 'aga' => 'Arg', 'agg' => 'Arg',
        'ggu' => 'Gly', 'ggc' => 'Gly', 'gga' => 'Gly', 'ggg' => 'Gly',
        );
if(exists $genetic_code{$codon}){
        return $genetic_code{$codon};
}

else{
        print "The codon \"$codon\" does not translate to an amino acid.\n";
        exit;
}

}

my%one_letter = ( #three letter amino acids to a single letter hash
        'Ser' => 'S', 'Phe' => 'F', 'Leu' => 'L', 'Tyr' => 'Y', 'Cys' => 'C',
        'Trp' => 'W', 'Pro' => 'P', 'His' => 'H', 'Gln' => 'Q', 'Arg' => 'R',
        'Ile' => 'I', 'Met' => 'M', 'Thr' => 'T', 'Asn' => 'N', 'Lys' => 'K',
        'Val' => 'V', 'Ala' => 'A', 'Asp' => 'D', 'Glu' => 'E', 'Gly' => 'G',
);


my $input = '';

my $RNASeq = '';

my @file;

open (FILE, "@ARGV[0]") or die "Unable to open @ARGV[0]";

@file = <FILE>;
close MyFile;

my $DNA;
chomp(@file);
$DNA = join('',@file);

if($DNA =~ /([^ACGT])/i){#checks to see if there are any non-valid characters in file
        print "This file contains a non-valid letter.\nNow terminating... \n";
        exit;
}

else{
        my $RNA = lc $DNA;
        $RNA =~ s/t/u/g; #translation of DNA to RNA
        my $final_seq = '';
        my ($codon_3, $i, $z, $is_started, $aa, $single_aa);

        #Transcription of RNA into an Amino Acid
        for(my $i=0; $i<length($RNA)-2; $i+=3){
                $codon_3 = substr($RNA,$i,3);
                $aa.= aaConvert($codon_3);
        }

        #takes the Three-Letter Amino Acid chain and converts to single letter
        for(my $i=0; $i<length($aa)-2; $i+=3){
                $single_aa = substr($aa,$i,3);
                if($single_aa =~ /END/){ #stop codon found, terminate conversion
                        $is_started = 0;
                        $final_seq .= "\n";
                }
                else{
                if($single_aa =~ /Met/){
                        $is_started = 1;
                }
                if($is_started){ #for as long as the stop codon isn't found
                        $final_seq .= $one_letter{$single_aa};
                }
                }
        }
        if($final_seq =~ /\n$/){#if the string ends in a new line, it deletes the newline
                chop $final_seq;
        }
        print "$final_seq\n";
}

exit;
          
