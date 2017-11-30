Message-ID: <1512016896.19952.86.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 29 Nov 2017 20:41:36 -0800
In-Reply-To: <20171130041824.GT6217@eros>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
	 <1511921105-3647-5-git-send-email-me@tobin.cc>
	 <20171129152058.389361d3576e784f47326cac@linux-foundation.org>
	 <20171129232603.GO6217@eros> <1512014306.19952.80.camel@perches.com>
	 <20171130041824.GT6217@eros>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-11-30 at 15:18 +1100, Tobin C. Harding wrote:
> On Wed, Nov 29, 2017 at 07:58:26PM -0800, Joe Perches wrote:
> > On Thu, 2017-11-30 at 10:26 +1100, Tobin C. Harding wrote:
> > > On Wed, Nov 29, 2017 at 03:20:58PM -0800, Andrew Morton wrote:
> > > > On Wed, 29 Nov 2017 13:05:04 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:
> > > > 
> > > > > printk specifier %p now hashes all addresses before printing. Sometimes
> > > > > we need to see the actual unmodified address. This can be achieved using
> > > > > %lx but then we face the risk that if in future we want to change the
> > > > > way the Kernel handles printing of pointers we will have to grep through
> > > > > the already existent 50 000 %lx call sites. Let's add specifier %px as a
> > > > > clear, opt-in, way to print a pointer and maintain some level of
> > > > > isolation from all the other hex integer output within the Kernel.
> > > > > 
> > > > > Add printk specifier %px to print the actual unmodified address.
> > > > > 
> > > > > ...
> > > > > 
> > > > > +Unmodified Addresses
> > > > > +====================
> > > > > +
> > > > > +::
> > > > > +
> > > > > +	%px	01234567 or 0123456789abcdef
> > > > > +
> > > > > +For printing pointers when you _really_ want to print the address. Please
> > > > > +consider whether or not you are leaking sensitive information about the
> > > > > +Kernel layout in memory before printing pointers with %px. %px is
> > > > > +functionally equivalent to %lx. %px is preferred to %lx because it is more
> > > > > +uniquely grep'able. If, in the future, we need to modify the way the Kernel
> > > > > +handles printing pointers it will be nice to be able to find the call
> > > > > +sites.
> > > > > +
> > > > 
> > > > You might want to add a checkpatch rule which emits a stern
> > > > do-you-really-want-to-do-this warning when someone uses %px.
> > > > 
> > > 
> > > Oh, nice idea. It has to be a CHECK but right?
> > 
> > No, it has to be something that's not --strict
> > so a WARN would probably be best.
> > 
> > > By stern, you mean use stern language?
> > 
> > I hope he doesn't mean tweet.
> 
> /me says tweet tweet (like a bird)
> 
> > Something like:
> > ---
> >  scripts/checkpatch.pl | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 0ce249f157a1..9d789cbe7df5 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -5758,21 +5758,40 @@ sub process {
> >  		    defined $stat &&
> >  		    $stat =~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
> >  		    $1 !~ /^_*volatile_*$/) {
> > +			my $complete_extension = "";
> > +			my $extension = "";
> >  			my $bad_extension = "";
> >  			my $lc = $stat =~ tr@\n@@;
> >  			$lc = $lc + $linenr;
> > +			my $stat_real;
> >  		        for (my $count = $linenr; $count <= $lc; $count++) {
> >  				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
> >  				$fmt =~ s/%%//g;
> > -				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNO]).)/) {
> > -					$bad_extension = $1;
> > -					last;
> > +				while ($fmt =~ /(\%[\*\d\.]*p(\w))/g) {
> > +					$complete_extension = $1;
> > +					$extension = $2;
> > +					if ($extension !~ /[FfSsBKRraEhMmIiUDdgVCbGNOx]/) {
> > +						$bad_extension = $complete_extension;
> > +						last;
> > +					}
> > +					if ($extension eq "x") {
> > +						if (!defined($stat_real)) {
> > +							$stat_real = raw_line($linenr, 0);
> > +							for (my $count = $linenr + 1; $count <= $lc; $count++) {
> > +								$stat_real = $stat_real . "\n" . raw_line($count, 0);
> > +							}
> > +						}
> > +						WARN("VSPRINTF_POINTER_PX",
> > +						     "Using vsprintf pointer extension '$complete_extension' exposes kernel address for possible hacking\n" . "$here\n$stat_real\n");
> > +					}
> >  				}
> >  			}
> >  			if ($bad_extension ne "") {
> > -				my $stat_real = raw_line($linenr, 0);
> > -				for (my $count = $linenr + 1; $count <= $lc; $count++) {
> > -					$stat_real = $stat_real . "\n" . raw_line($count, 0);
> > +				if (!defined($stat_real)) {
> > +					$stat_real = raw_line($linenr, 0);
> > +					for (my $count = $linenr + 1; $count <= $lc; $count++) {
> > +						$stat_real = $stat_real . "\n" . raw_line($count, 0);
> > +					}
> >  				}
> >  				WARN("VSPRINTF_POINTER_EXTENSION",
> >  				     "Invalid vsprintf pointer extension '$bad_extension'\n" . "$here\n$stat_real\n");
> > 
> 
> Awesome. So moving forward, I should apply this code. Test it,

I didn't sign it and just trivially tested it.

So test it locally, see if it doesn't work
and check if the wording could be improved.

One possible negative is that if the format
contains multiple %px uses, then each use is
warned.

Maybe it should be
				if ($extension eq "x" && !defined($stat_real)) {
					...
					WARN("VSPRINTF_POINTER_PX", ...)
				}
so that only the first %px is warned.

If/when the %px series is applied, then this
can go in via whatever tree.
