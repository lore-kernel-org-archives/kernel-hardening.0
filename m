Date: Thu, 19 Oct 2017 17:19:49 +0200
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20171019151949.GC2795@pathway.suse.cz>
References: <1508394884-13869-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508394884-13869-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [RFC] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 2017-10-19 17:34:44, Tobin C. Harding wrote:
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> new file mode 100755
> index 000000000000..940547b716e3
> --- /dev/null
> +++ b/scripts/leaking_addresses.pl
> @@ -0,0 +1,139 @@
> +#!/usr/bin/env perl
> +#
> +# leaking_addresses.pl scan kernel for potential leaking addresses.
> +
> +use warnings;
> +use strict;
> +use File::Basename;
> +use feature 'say';

It seems that the 'say' feature is not used at the end.

> +my $DEBUG = 0;
> +my @dirs = ('/proc', '/sys');
> +
> +parse_dmesg();
> +
> +foreach(@dirs)
> +{
> +    walk($_);
> +}
> +
> +exit 0;
> +
> +#
> +# TODO
> +#
> +# - Add support for 32 bit architectures.
> +#
> +sub may_leak_address
> +{
> +    my $line = $_[0];
> +    my $regex = 'ffff[a-fA-F0-9]{12}';
> +    my $mask = 'ffffffffffffffff';
> +
> +    if ($line =~ /$mask/) {
> +        return

I would personally return 0; instead of nothing.
Well, I am used to reading C and not perl ;-)

Also I wonder if we really need to define the pattern
as a variable. It might be better to use it directly
in the regex and put a comment above, e.g.

	# Ignore addresses that say nothing
	if ($line =~ /ffffffffffffffff/ or
	    $line =~ /0000000000000000/) {
		return 0;


> +    }
> +
> +    if ($line =~ /$regex/) {
> +        return 1;
> +    }
> +    return;
> +}
> +
> +sub parse_dmesg
> +{
> +    my $line;
> +    open my $cmd, '-|', 'dmesg';
> +    while ($line = <$cmd>) {
> +        if (may_leak_address($line)) {
> +            print 'dmesg: ' . $line;
> +        }
> +    }
> +    close $cmd;
> +}
> +
> +# We should skip these files
> +sub skip_file
> +{
> +    my $path = $_[0];
> +
> +    my @skip_paths = ('/proc/kmsg', '/proc/kcore', '/proc/kallsyms',
> +                      '/proc/fs/ext4/sdb1/mb_groups', '/sys/kernel/debug/tracing/trace_pipe',
> +                      '/sys/kernel/security/apparmor/revision');

I would suggest to put each directory on a separate line.
It is easier to review and patch.

> +    my @skip_files = ('pagemap', 'events', 'access','registers', 'snapshot_raw',
> +                      'trace_pipe_raw', 'trace_pipe');

Same here.

> +
> +    foreach(@skip_paths) {
> +        if ($_ eq $_[0]) {
> +            return 1;
> +        }
> +    }
> +
> +    my($filename, $dirs, $suffix) = fileparse($path);
> +
> +    foreach(@skip_files) {
> +        if ($_ eq $filename) {
> +            return 1;
> +        }
> +    }
> +
> +    return;
> +}
> +
> +sub parse_file
> +{
> +    my $file = $_[0];
> +
> +    if (! -R $file) {
> +        return;
> +    }
> +
> +    if (skip_file($file)) {
> +        if ($DEBUG == 1) {
> +            print "skipping file: $file\n";
> +        }
> +        return;
> +    }
> +    if ($DEBUG == 1) {
> +        print "parsing $file\n";
> +    }
> +
> +    open my $fh, $file or return;
> +
> +    while( my $line = <$fh>)  {
> +        if (may_leak_address($line)) {
> +            print $file . ': ' . $line;
> +        }
> +    }
> +
> +    close $fh;
> +}
> +
> +# Recursively walk directory tree
> +sub walk
> +{
> +    my @dirs = ($_[0]);
> +    my %seen;
> +
> +    while (my $pwd = shift @dirs) {
> +        if (!opendir(DIR,"$pwd")) {
> +            print STDERR "Cannot open $pwd\n";          

I would print the error only when $DEBUG = 1.
If a directory cannot be opened, it does not leak anything.
Same for opened files.

IMHO, it would make sense to show only real problems.
Otherwise people would have troubles to interpret it.

> +            next;
> +        } 
> +        my @files = readdir(DIR);
> +        closedir(DIR);
> +        foreach my $file (@files) {
> +            next if ($file eq '.' or $file eq '..');
> +
> +            my $path = "$pwd/$file";
> +            next if (-l $path);
> +
> +            if (-d $path and !$seen{$path}) {
> +                $seen{$path} = 1;

How is it possible to see a path twice, please?

> +                push @dirs, "$path";
> +            } else {
> +                parse_file("$path");
> +            }
> +        }
> +    }
> +}

Best Regards,
Petr
