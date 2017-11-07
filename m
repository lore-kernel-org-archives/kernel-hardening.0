Date: Wed, 8 Nov 2017 07:39:33 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171107203933.GV18478@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <20171107155129.GE2652@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171107155129.GE2652@pathway.suse.cz>
Subject: [kernel-hardening] Re: [PATCH v4] scripts: add leaking_addresses.pl
To: Petr Mladek <pmladek@suse.com>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 07, 2017 at 04:51:29PM +0100, Petr Mladek wrote:
> On Tue 2017-11-07 21:32:11, Tobin C. Harding wrote:
> > Currently we are leaking addresses from the kernel to user space. This
> > script is an attempt to find some of those leakages. Script parses
> > `dmesg` output and /proc and /sys files for hex strings that look like
> > kernel addresses.
> > 
> > Only works for 64 bit kernels, the reason being that kernel addresses
> > on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> > possible. On 32 kernels we don't have this luxury.
> > 
> > Scripts is _slightly_ smarter than a straight grep, we check for false
> > positives (all 0's or all 1's, and vsyscall start/finish addresses).
> > 
> > Output is saved to file to expedite repeated formatting/viewing of
> > output.
> > 
> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > new file mode 100755
> > index 000000000000..282c0cc2bdea
> > --- /dev/null
> > +++ b/scripts/leaking_addresses.pl
> > +sub help
> > +{
> > +	my ($exitcode) = @_;
> > +
> > +	print << "EOM";
> > +Usage: $P COMMAND [OPTIONS]
> > +Version: $V
> > +
> > +Commands:
> > +
> > +	scan	Scan the kernel (savesg raw results to file and runs `format`).
> > +	format	Parse results file and format output.
> > +
> > +Options:
> > +	-o, --output=<path>	 Accepts absolute or relative filename or directory name.
> 
> IMHO, this is pretty non-standard. I would support only -o file. Then you do
> not need to solve problems with replacing an existing file. The user
> would know exactly what file will be generated.
> 
> 
> > +	    --suppress-dmesg	 Don't show dmesg results.
> 
> The apostrophe breaks highlighting of the rest of the code ;-)
> 
> 
> > +	    --squash-by-path	 Show one result per unique path.
> > +	    --raw	 	 Show raw results.
> > +	    --send-report	 Submit raw results for someone else to worry about.
> > +	-d, --debug              Display debugging output.
> > +	-h, --help, --version    Display this help and exit.
> > +
> > +Scans the running (64 bit) kernel for potential leaking addresses.
> > +}
> 
> This bracket should not be here. The help text is limited
> by "EOM" below.
> 
> 
> > +
> > +EOM
> > +	exit($exitcode);
> > +}
> 
> [...]
> 
> > +sub cache_path
> > +{
> > +        my ($paths, $line) = @_;
> > +
> > +        my $index = index($line, ':');
> 
> There are paths with the double dot, for example:
> /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input4/uevent
> Then the file name is wrongly detected, in my example as "pci0000"
> 
> It seems that searching for ": " sub-string works rather well.
> I mean using:
> 
> 	my $index = index($line, ': ');
> 
> > +        my $path = substr($line, 0, $index);
> > +
> > +        if (!$paths->{$path}) {
> > +                $paths->{$path} = ();
> > +        }
> > +        push @{$paths->{$path}}, $line;
> 
> It would make sense to use the same trick from cache_filename
> and remove path from the cached text. I mean:
> 
> 	$index += 2;            # skip ': '
> 	push @{$paths->{$path}}, substr($line, $index);
> 
> > +}
> > +
> > +sub cache_filename
> > +{
> > +        my ($files, $line) = @_;
> > +
> > +        my $index = index($line, ':');
> 
> Same problem with the double dot in the path name.
> The following helped me:
> 
> 	my $index = index($line, ': ');
> 
> > +        my $path = substr($line, 0, $index);
> > +        my $filename = basename($path);
> > +        if (!$files->{$filename}) {
> > +                $files->{$filename} = ();
> > +        }
> > +        $index += 2;            # skip ': '
> > +        push @{$files->{$filename}}, substr($line, $index);
> > +}
> 
> This is what caught my eye when trying the script.

Awesome. Thank you very much. All comments will be addressed for the
next spin.

thanks,
Tobin.
