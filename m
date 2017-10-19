Date: Thu, 19 Oct 2017 08:44:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171019084431.223c69f4@vmware.local.home>
In-Reply-To: <1508394884-13869-1-git-send-email-me@tobin.cc>
References: <1508394884-13869-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 19 Oct 2017 17:34:44 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> 
> My usual disclaimer; I am a long way from being a Perl monger, any tips,

I'm a semi Perl monger.

> however trivial, most welcome.
> 
> Parses dmesg output first then;
> 
> Algorithm walks the directory tree of /proc and /sys, opens each file
> for reading and parses file line by line. We therefore need to skip
> certain files;
> 
>  - binary files.
>  - relay large files of fixed format that _definitely_ won't leak.

"relay large files"? What do the files relay with? ;-)

>  - non-readable files.
> 
> Since I do not know procfs or sysfs extensively I set `DEBUG = 1` within
> the script (causes output of file name before parsing) and checked each
> file it choked on. Obviously this means there are going to be a bunch of
> other files not present on my system. Either more files to skip or a
> suggestion of a better way to do this most appreciated.
> 
> Like I said, happy to take suggestions, abuse, tweaks etc

abuse accepted.

> 
> Thanks in advance for taking the time to look at this. Oh, I didn't
> comment on my regex skills, no further comment required ;)
> 
> thanks,
> Tobin.
> 
>  scripts/leaking_addresses.pl | 139 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)
>  create mode 100755 scripts/leaking_addresses.pl
> 
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
> +
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

I wonder if it is OK to add to the banner or just afterward what the
word size of the computer is. You could also search for strings like
amd64 in the banner.

> +#
> +sub may_leak_address
> +{
> +    my $line = $_[0];

I usually do:

	my ($line) = $@;

But either is fine.

> +    my $regex = 'ffff[a-fA-F0-9]{12}';

try

 my $regex = '\b(0x)?ffff[[:xdigit:]]{12}\b';

The \b is to match non word characters.

  =ffffdeadbeef1234
  0xffffdeadbeef1234
  =0xffffdeadBEEF1234

all match

  aoeuffffdeeadbeef1234

does not match.

> +    my $mask = 'ffffffffffffffff';

 my $mask = '\b(0[xX])?(fF){16}\b'


> +
> +    if ($line =~ /$mask/) {
> +        return
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

Remove $line:

	while (<$cmd>) {
		if (may_leak_address($_)) {
			print 'dmesg: '. $_;
		}
	}

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
> +    my @skip_files = ('pagemap', 'events', 'access','registers', 'snapshot_raw',
> +                      'trace_pipe_raw', 'trace_pipe');
> +
> +    foreach(@skip_paths) {
> +        if ($_ eq $_[0]) {

does the above work? Shouldn't that be $path?

> +            return 1;

you could also do:

		return 1 if (/^$path$/);

> +        }
> +    }
> +
> +    my($filename, $dirs, $suffix) = fileparse($path);
> +
> +    foreach(@skip_files) {
> +        if ($_ eq $filename) {

	if (/^$filename$/) {

also works. You could also do:

	return 1 if (/^$filename$/);

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

To keep from having to do the above, I usually have:

sub dprint {
	return if ($DEBUG != 1);

	print $@;
}

May not even need the $@ part. But then you can just use dprint instead
of the test case and print.

> +
> +    open my $fh, $file or return;
> +
> +    while( my $line = <$fh>)  {

Again, you don't need the $line.

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

Does the above work? What about:

	my @dirs = @_;
?

Oh, you have a foreach(@dirs) calling the walk.
That's probably why it didn't work. Or is it because of the stack usage
below?

-- Steve

> +    my %seen;
> +
> +    while (my $pwd = shift @dirs) {
> +        if (!opendir(DIR,"$pwd")) {
> +            print STDERR "Cannot open $pwd\n";          
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
> +                push @dirs, "$path";
> +            } else {
> +                parse_file("$path");
> +            }
> +        }
> +    }
> +}
