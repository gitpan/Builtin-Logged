package Log::Any::For::Builtins;

use 5.010001;
use strict;
use warnings;
use Log::Any '$log';
use SHARYANTO::String::Util qw(ellipsis);
use SHARYANTO::Proc::ChildError qw(explain_child_error);

our $VERSION = '0.06'; # VERSION

our $Max_Log_Output = 1024;

sub system {
    if ($log->is_trace) {
        $log->tracef("system(): %s", join(" ", @_));
    }
    my $res = CORE::system(@_);
    if ($log->is_trace) {
        $log->tracef("system() child error: %d (%s)",
                     $?, explain_child_error()) if $?;
    }
    $res;
}

sub my_qx {
    my $arg = join " ", @_;
    if ($log->is_trace) {
        $log->tracef("my_qx(): %s", $arg);
    }
    my $wa = wantarray;
    my $output;
    my @output;
    if ($wa) { @output = qx($arg) } else { $output = qx($arg) }
    if ($log->is_trace) {
        $log->tracef("my_qx() child error: %d (%s)",
                     $?, explain_child_error()) if $?;
        if ($wa) { $output = join("", @output) }
        $log->tracef("my_qx() output (%d bytes%s): %s",
                     length($output),
                     (length($output) > $Max_Log_Output ?
                         ", $Max_Log_Output shown" : ""),
                     ellipsis($output, $Max_Log_Output+3));
    }
    $wa ? @output : $output;
}

sub import {
    no strict 'refs';

    my ($self, @args) = @_;
    my $caller = caller();

    for my $arg (@args) {
        if ($arg eq 'system') {
            *{"$caller\::system"} = \&system;
        } elsif ($arg eq 'my_qx') {
            *{"$caller\::my_qx"} = \&my_qx;
        } else {
            die "$arg is not exported by ".__PACKAGE__;
        }
    }
}

1;
# ABSTRACT: Log builtin functions

__END__

=pod

=encoding UTF-8

=head1 NAME

Log::Any::For::Builtins - Log builtin functions

=head1 VERSION

version 0.06

=head1 SYNOPSIS

 use Log::Any::For::Builtins qw(system my_qx);

 system "blah ...";
 my $out = my_qx("blah ...");

When run, it might produce logs like:

 [TRACE] system(): blah ...
 [TRACE] system() child error: 256 (exited with value 1)
 [TRACE] my_qx(): blah ...
 [TRACE] my_qx() child error: 0 (exited with value 0)
 [TRACE] my_qx() output (200 bytes): Command output...

=head1 DESCRIPTION

This module provides replacement for some builtin functions (and operators). The
replacement behaves exactly the same, except that they are peppered with log
statements from L<Log::Any>. The log statements are at C<trace> level.

=head1 EXPORTS

=over 4

=item * system

=item * my_qx

Will provide my_qx(). Use this instead of qx() or backtick. Perl currently does
not provide an easy way to override/overload qx().

=back

=head1 VARIABLES

=head1 SEE ALSO

L<Log::Any>

Other Log::Any::For::* modules.

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/Builtin-Logged>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-Builtin-Logged>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=Builtin-Logged>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
