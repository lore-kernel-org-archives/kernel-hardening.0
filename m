Date: Thu, 2 Nov 2017 07:59:01 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171101205901.GN3585@eros>
References: <1509533299-5727-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509533299-5727-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH v2] scripts: add leaking_addresses.pl
To: kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 01, 2017 at 09:48:19PM +1100, Tobin C. Harding wrote:
> Currently we are leaking addresses from the kernel to user space. This
> script is an attempt to find those leakages. Script parses `dmesg`
> output and /proc and /sys files for hex strings that look like kernel
> addresses.
> 
> Only works for 64 bit kernels, the reason being that kernel addresses
> on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> possible. On 32 kernels we don't have this luxury.
> 
> Exclude vsyscall addresses.
> Suggested-by: Tim Starling <tstarling@wikimedia.org>
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> 
> ---
> 
> v2:
>  - Add regex's to prevent false positives.
>  - Clean up white space.
> 
>  MAINTAINERS                  |   5 +
>  scripts/leaking_addresses.pl | 297 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 302 insertions(+)
>  create mode 100755 scripts/leaking_addresses.pl
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e652a3e2929d..c1ad6d133a57 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7745,6 +7745,11 @@ S:	Maintained
>  F:	Documentation/scsi/53c700.txt
>  F:	drivers/scsi/53c700*
>  
> +LEAKING_ADDRESSES
> +M:	Tobin C. Harding <me@tobin.cc>
> +S:	Maintained
> +F:	scripts/leaking_addresses.pl
> +
>  LED SUBSYSTEM
>  M:	Richard Purdie <rpurdie@rpsys.net>
>  M:	Jacek Anaszewski <jacek.anaszewski@gmail.com>
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> new file mode 100755
> index 000000000000..9b00ce252e2d
> --- /dev/null
> +++ b/scripts/leaking_addresses.pl
> @@ -0,0 +1,297 @@
> +#!/usr/bin/env perl
> +#
> +# (c) 2017 Tobin C. Harding <me@tobin.cc>
> +# Licensed under the terms of the GNU GPL License version 2
> +#
> +# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
> +#  - Scans dmesg output.
> +#  - Walks directory tree and parses each file (for each directory in @DIRS).
> +#
> +# You can configure the behaviour of the script;
> +#
> +#  - By adding paths, for directories you do not want to walk;
> +#     absolute paths: @skip_walk_dirs_abs
> +#     directory names: @skip_walk_dirs_any
> +#
> +#  - By adding paths, for files you do not want to parse;
> +#     absolute paths: @skip_parse_files_abs
> +#     file names: @skip_parse_files_any
> +#
> +# The use of @skip_xxx_xxx_any causes files to be skipped where ever they occur.
> +# For example adding 'fd' to @skip_walk_dirs_any causes the fd/ directory to be
> +# skipped for all PID sub-directories of /proc
> +#
> +# The same thing can be achieved by passing command line options to --dont-walk
> +# and --dont-parse. If absolute paths are supplied to these options they are
> +# appended to the @skip_xxx_xxx_abs arrays. If file names are supplied to these
> +# options, they are appended to the @skip_xxx_xxx_any arrays.
> +#
> +# Use --debug to output path before parsing, this is useful to find files that
> +# cause the script to choke.
> +#
> +# You may like to set kptr_restrict=2 before running script
> +# (see Documentation/sysctl/kernel.txt).
> +
> +use warnings;
> +use strict;
> +use POSIX;
> +use File::Basename;
> +use File::Spec;
> +use Cwd 'abs_path';
> +use Term::ANSIColor qw(:constants);
> +use Getopt::Long qw(:config no_auto_abbrev);
> +
> +my $P = $0;
> +my $V = '0.01';
> +
> +# Directories to scan.
> +my @DIRS = ('/proc', '/sys');
> +
> +# Command line options.
> +my $help = 0;
> +my $debug = 0;
> +my @dont_walk = ();
> +my @dont_parse = ();
> +
> +# Do not parse these files (absolute path).
> +my @skip_parse_files_abs = ('/proc/kmsg',
> +			    '/proc/kcore',
> +			    '/proc/fs/ext4/sdb1/mb_groups',
> +			    '/proc/1/fd/3',
> +			    '/sys/kernel/debug/tracing/trace_pipe',
> +			    '/sys/kernel/security/apparmor/revision');
> +
> +# Do not parse thes files under any subdirectory.
> +my @skip_parse_files_any = ('0',
> +			    '1',
> +			    '2',
> +			    'pagemap',
> +			    'events',
> +			    'access',
> +			    'registers',
> +			    'snapshot_raw',
> +			    'trace_pipe_raw',
> +			    'ptmx',
> +			    'trace_pipe');
> +
> +# Do not walk these directories (absolute path).
> +my @skip_walk_dirs_abs = ();
> +
> +# Do not walk these directories under any subdirectory.
> +my @skip_walk_dirs_any = ('self',
> +			  'thread-self',
> +			  'cwd',
> +			  'fd',
> +			  'stderr',
> +			  'stdin',
> +			  'stdout');
> +
> +sub help
> +{
> +	my ($exitcode) = @_;
> +
> +	print << "EOM";
> +Usage: $P [OPTIONS]
> +Version: $V
> +
> +Options:
> +
> +	--dont-walk=<dir>      Don't walk tree starting at <dir>.
> +	--dont-parse=<file>    Don't parse <file>.
> +	-d, --debug                Display debugging output.
> +	-h, --help, --version      Display this help and exit.
> +
> +If an absolute path is passed to --dont_XXX then this path is skipped. If a
> +single filename is passed then this file/directory will be skipped when
> +appearing under any subdirectory.
> +
> +Example:
> +
> +	# Just scan dmesg output.
> +	scripts/leaking_addresses.pl --dont_walk_abs /proc --dont_walk_abs /sys
> +
> +Scans the running (64 bit) kernel for potential leaking addresses.
> +
> +EOM
> +	exit($exitcode);
> +}
> +
> +GetOptions(
> +	'dont-walk=s'		=> \@dont_walk,
> +	'dont-parse=s'		=> \@dont_parse,
> +	'd|debug'		=> \$debug,
> +	'h|help'		=> \$help,
> +	'version'		=> \$help
> +) or help(1);
> +
> +help(0) if ($help);
> +
> +push_to_global();
> +
> +parse_dmesg();
> +walk(@DIRS);
> +
> +exit 0;
> +
> +sub debug_arrays
> +{
> +	print 'dirs_any: ' . join(", ", @skip_walk_dirs_any) . "\n";
> +	print 'dirs_abs: ' . join(", ", @skip_walk_dirs_abs) . "\n";
> +	print 'parse_any: ' . join(", ", @skip_parse_files_any) . "\n";
> +	print 'parse_abs: ' . join(", ", @skip_parse_files_abs) . "\n";
> +}
> +
> +sub dprint
> +{
> +	printf(STDERR @_) if $debug;
> +}
> +
> +sub push_in_abs_any
> +{
> +	my ($in, $abs, $any) = @_;
> +
> +	foreach my $path (@$in) {
> +		if (File::Spec->file_name_is_absolute($path)) {
> +			push @$abs, $path;
> +		} elsif (index($path,'/') == -1) {
> +			push @$any, $path;
> +		} else {
> +			print 'path error: ' . $path;
> +		}
> +	}
> +}
> +
> +# Push command line options to global arrays.
> +sub push_to_global
> +{
> +	push_in_abs_any(\@dont_walk, \@skip_walk_dirs_abs, \@skip_walk_dirs_any);
> +	push_in_abs_any(\@dont_parse, \@skip_parse_files_abs, \@skip_parse_files_any);
> +}
> +
> +# True if argument potentially contains a kernel address.
> +sub may_leak_address
> +{
> +        my ($line) = @_;
> +
> +        if ($line =~ '\b(0x)?(f|F){16}\b' or
> +                $line =~ '\b(0x)?0{16}\b') {
> +                return 0;
> +        }
> +
> +        if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
> +            $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
> +		return 0;
> +        }
> +
> +        # vsyscall memory region, we should probably check against a range here
> +        if ($line =~ '\bf{10}600000\b' or
> +            $line =~ '\bf{10}601000\b') {
> +                return 0;
> +        }
> +
> +        # Signal masks.
> +        if ($line =~ '^SigBlk:' or
> +            $line =~ '^SigCgt:') {
> +                return 0;
> +        }
> +
> +        # Potential kernel address.
> +        if ($line =~ '\b(0x)?ffff[[:xdigit:]]{12}\b') {
> +		return 1;
> +        }
> +
> +        return 0;
> +}

This code is no good. It throws away correct results if the line
contains a false positive. We need something like

for each line
    for each match in the line        
        if match is not false positive                  
           return TRUE                           

return FALSE

Where <match> is '\b(0x)?ffff[[:xdigit:]]{12}\b'

thanks,
Tobin.
