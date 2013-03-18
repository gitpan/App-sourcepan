#  You may distribute under the terms of either the GNU General Public License
#  or the Artistic License (the same terms as Perl itself)
#
#  (C) Paul Evans, 2013 -- leonerd@leonerd.org.uk

package App::sourcepan;

use strict;
use warnings;

our $VERSION = '0.01';

use CPAN;
use File::Basename qw( basename );
use File::Copy qw( copy );

=head1 NAME

C<App::sourcepan> - fetch source tarballs from CPAN

=head1 SYNOPSIS

 $ sourcepan App::sourcepan

=head1 DESCRIPTION

This module provides a command F<sourcepan>, which fetches the source
distribution for the module or modules named on the commandline, and places
each in the current working directory.

=cut

sub run
{
   my @modules = @_;

   my %dists;
   foreach my $module ( CPAN::Shell->expand( Module => @ARGV ) ) {
      my $dist = $module->distribution;
      $dists{$dist->pretty_id} = $dist;
   }

   foreach my $id ( sort keys %dists ) {
      my $dist = $dists{$id};

      # Peeking inside
      $dist->get_file_onto_local_disk;

      my $basename = basename $id;
      copy( $dist->{localfile}, $basename ) or die "Cannot copy - $!";

      print "$id => $basename\n";
   }
}

=head1 AUTHOR

Paul Evans <leonerd@leonerd.org.uk>

=cut

0x55AA;
