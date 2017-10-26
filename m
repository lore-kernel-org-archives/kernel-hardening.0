Date: Fri, 27 Oct 2017 10:57:39 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171026235739.GL12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <1508986436-31966-2-git-send-email-me@tobin.cc>
 <1508993843.10651.22.camel@perches.com>
 <20171026062734.GH12341@eros>
 <1509005139.10651.39.camel@perches.com>
 <20171026093728.GJ12341@eros>
 <1509029239.10651.51.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509029239.10651.51.camel@perches.com>
Subject: [kernel-hardening] Re: [PATCH V8 1/2] printk: remove tabular output for NULL pointer
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 07:47:19AM -0700, Joe Perches wrote:
> On Thu, 2017-10-26 at 20:37 +1100, Tobin C. Harding wrote:
> > On Thu, Oct 26, 2017 at 01:05:39AM -0700, Joe Perches wrote:
> > > On Thu, 2017-10-26 at 17:27 +1100, Tobin C. Harding wrote:
> > > > Hi Joe,
> > > > 
> > > > thanks for your review.
> > > > 
> > > > On Wed, Oct 25, 2017 at 09:57:23PM -0700, Joe Perches wrote:
> > > > > On Thu, 2017-10-26 at 13:53 +1100, Tobin C. Harding wrote:
> > > > > > Currently pointer() checks for a NULL pointer argument and then if so
> > > > > > attempts to print "(null)" with _some_ standard width. This width cannot
> > > > > > correctly be ascertained here because many of the printk specifiers
> > > > > > print pointers of varying widths.
> > > > > 
> > > > > I believe this is not a good change.
> > > > > Only pointers without a <foo> extension call pointer()
> > > > 
> > > > Sorry, I don't understand what you mean here. All the %p<foo> specifier code is
> > > > handled by pointer()?
> > > 
> > > Sorry, I was imprecise/wrong.
> > > 
> > > None of the %p<foo> extensions except %pK and %p<invalid_foo>
> > > actually use this bit of the pointer() call.
> > 
> > 	if (!ptr && *fmt != 'K') {
> > 		/*
> > 		 * Print (null) with the same width as a pointer so it makes
> > 		 * tabular output look nice.
> > 		 */
> > 		if (spec.field_width == -1)
> > 			spec.field_width = default_width;
> > 		return string(buf, end, "(null)", spec);
> > 	}
> > 
> > Is there something I'm missing here? This code reads like its all %p<foo>
> > (including %p and %p<invalid_foo>) except %pK that hit this block when
> > a NULL pointer is passed in.
> 
> The idea for aligning is described in commit 5e0579812834a
> 
> $ git log --stat -p -1 --format=email 5e0579812834a
> From 5e0579812834ab7fa072db4a15ebdff68d62e2e7 Mon Sep 17 00:00:00 2001
> From: Joe Perches <joe@perches.com>
> Date: Tue, 26 Oct 2010 14:22:50 -0700
> Subject: [PATCH] vsprintf.c: use default pointer field size for "(null)"
>  strings
> 
> It might be nicer to align the output.
> 
> For instance, ACPI messages sometimes have "(null)" pointers.
> 
> $ dmesg | grep "(null)"  -A 1 -B 1
> [    0.198733] ACPI: Dynamic OEM Table Load:
> [    0.198745] ACPI: SSDT (null) 00239 (v02  PmRef  Cpu0Ist 00003000 INTL 20051117)
> [    0.199294] ACPI: SSDT 7f596e10 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    0.200708] ACPI: Dynamic OEM Table Load:
> [    0.200721] ACPI: SSDT (null) 001C7 (v02  PmRef  Cpu0Cst 00003001 INTL 20051117)
> [    0.201950] ACPI: SSDT 7f597f10 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
> [    0.203386] ACPI: Dynamic OEM Table Load:
> [    0.203398] ACPI: SSDT (null) 000D0 (v02  PmRef  Cpu1Ist 00003000 INTL 20051117)
> [    0.203871] ACPI: SSDT 7f595f10 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)
> [    0.205301] ACPI: Dynamic OEM Table Load:
> [    0.205315] ACPI: SSDT (null) 00083 (v02  PmRef  Cpu1Cst 00003000 INTL 20051117)

Does this give the correct level of control? Would it not be better to
control the output of NULL pointers in the code that prints them. The
other side of the coin is that with padding a random single debug
message ends up with unwanted white space, e.g

 [    0.205315] foo: This pointer (null)         some useful error message 

Just thoughts.

> > > All of the other valid %p<foo> extension uses do not end up
> > > at this block being executed so it's effectively only regular
> > > pointers being output by number()
> 
> Because passing NULL to any of the %p<foo> extensions
> excluding %pK is probably a defect.

This implies that passing NULL to %p is a defect also, does it not. Like
already stated, if it is not a defect, the calling code is in a better
position to decide on the formatting, unless we printed
	<-    (null)    ->

with the correct spacing for all architectures, this seems a bit
extravagant though.

> > > > > > Remove the attempt to print NULL pointers with a correct width.
> > > > > 
> > > > > the correct width for a %p is the default width.
> > > > 
> > > > It is the default width if we are printing addresses. Once we hash 64
> > > > bit address to a 32 bit identifier then we don't have a default width.
> > > 
> > > Perhaps that 32 bit identifier should use leading 0's for
> > > the default width.
> > 
> > That's a fair comment.
> > 
> > > aside:
> > > 
> > > Why hash 64 bits to 32?
> > > Why shouldn't the hash width be 64 bits on 64 bit systems?
> > 
> > Quoted from Linus in an earlier thread discussing this change
> > 
> > 	Date: Thu, 12 Oct 2017 11:37:22 -0700 Linus Torvalds wrote:
> > 
> > 	In fact, I'd prefer mapping the pointer to a 32-bit value, even on
> > 	64-bit architectures. When people use these things for debugging and
> > 	for identifying which device node or socket or whatever they are
> > 	tracking, we're generally talking a (small) handful of different
> > 	devices or whatever.
> 
> I wonder about this and userland programs and API breakage.
> 
> I'd expect there could be cases of userland parsers that
> expect a certain width for pointer fields.
> 
> $ git grep -E "\bseq_.*%p\W" | wc -l
> 112

This is a good point. Making %p now prefix with 0x could also
potentially break things for the same reason. Perhaps your suggestion of
having leading 0's in front of the 32 bit identifier on 64 bit machines
solves a number of these problems (without the 0x prefix).

1. It leaves the output layout unchanged, no userland breakages.
2. It still has the advantages of a 32 bit hash mentioned by Linus.
3. It makes explicit that something funny is going on with the address,
   multiple addresses with 32 leading 0's will stand out.


thanks,
Tobin.
