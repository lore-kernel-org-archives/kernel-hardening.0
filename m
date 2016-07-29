Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jul 2016 18:20:14 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160729182014.GW4541@io.lakedaemon.net>
References: <20160728204730.27453-1-jason@lakedaemon.net>
 <20160728204730.27453-2-jason@lakedaemon.net>
 <1469782754.16837.20.camel@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1469782754.16837.20.camel@opteya.com>
Subject: [kernel-hardening] Re: [PATCH 1/7] random: Simplify API for random address requests
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: william.c.roberts@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux@arm.linux.org.uk, akpm@linux-foundation.org, keescook@chromium.org, tytso@mit.edu, arnd@arndb.de, gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com, ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, viro@zeniv.linux.org.uk, nnk@google.com, jeffv@google.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Yann,

First, thanks for the review!

On Fri, Jul 29, 2016 at 10:59:14AM +0200, Yann Droneaud wrote:
> Le jeudi 28 juillet 2016 à 20:47 +0000, Jason Cooper a écrit :
> > To date, all callers of randomize_range() have set the length to 0,
> > and check for a zero return value.  For the current callers, the only
> > way to get zero returned is if end <= start.  Since they are all
> > adding a constant to the start address, this is unnecessary.
> > 
> > We can remove a bunch of needless checks by simplifying the API to do
> > just what everyone wants, return an address between [start, start +
> > range).
> > 
> > While we're here, s/get_random_int/get_random_long/.  No current call
> > site is adversely affected by get_random_int(), since all current
> > range requests are < UINT_MAX.  However, we should match caller
> > expectations to avoid coming up short (ha!) in the future.
> > 
> > Address generation within [start, start + range) behavior is
> > preserved.
> > 
> > All current callers to randomize_range() chose to use the start
> > address if randomize_range() failed.  Therefore, we simplify things
> > by just returning the start address on error.
> > 
> > randomize_range() will be removed once all callers have been
> > converted over to randomize_addr().
> > 
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> >  drivers/char/random.c  | 26 ++++++++++++++++++++++++++
> >  include/linux/random.h |  1 +
> >  2 files changed, 27 insertions(+)
> > 
> > diff --git a/drivers/char/random.c b/drivers/char/random.c
> > index 0158d3bff7e5..3610774bcc53 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1840,6 +1840,32 @@ randomize_range(unsigned long start, unsigned
> > long end, unsigned long len)
> >  	return PAGE_ALIGN(get_random_int() % range + start);
> >  }
> >  
> > +/**
> > + * randomize_addr - Generate a random, page aligned address
> > + * @start:	The smallest acceptable address the caller will take.
> > + * @range:	The size of the area, starting at @start, within which the
> > + *		random address must fall.
> > + *
> > + * Before page alignment, the random address generated can be any value from
> > + * @start, to @start + @range - 1 inclusive.
> > + *
> > + * If @start + @range would overflow, @range is capped.
> > + *
> > + * Return: A page aligned address within [start, start + range).
> 
> PAGE_ALIGN(start + range - 1) can be greater than start + range ..

Ok, so I need to reword my Return desription. :)

> In the worst case, when start = 0, range = ULONG_MAX, the result would
> be 0.
> 
> In order to stay in the bounds, the start address must be rounded up,
> and the random offset must be rounded down.

Well, I'm trying to preserve existing behavior.  Of which, it seems to
be presumed that start was page aligned.  Since it was used unaltered in
all cases when randomize_range failed.

I'll add that to the kerneldoc.

> Something I haven't found the time to send was looking like this:
> 
>   unsigned long base = PAGE_ALIGN(start);
> 
>   range -= (base - start);

I think the above two lines are unnecessary due to my comment above.

>   range >>= PAGE_SHIFT;
> 
>   return base + ((get_random_int() % range) << PAGE_SHIFT);

However, this is interesting.  Instead of a random address, you're
picking a random page.  If we combine this with the requirement that
start be page aligned, we can remove the PAGE_ALIGN().  Which neatly
handles your first listed concern.

> >   On error,
> > + * @start is returned.
> > + */
> > +unsigned long
> > +randomize_addr(unsigned long start, unsigned long range)
> > +{
> > +	if (range == 0)
> > +		return start;
> > +
> > +	if (start > ULONG_MAX - range)
> > +		range = ULONG_MAX - start;
> > +
> > +	return PAGE_ALIGN(get_random_long() % range + start);

On digging in to this, I found the following scenario:

start=ULONG_MAX, range=ULONG_MAX
	range=0 by our second test
	UB by get_random_long() % 0

This should be mitigated by swapping the tests.  So, we would have:

unsigned long
randomize_addr(unsigned long start, unsigned long range)
{
	if (start > ULONG_MAX - range)
		range = ULONG_MAX - start;

	range >>= PAGE_SHIFT;

	if (range == 0)
		return start;

	return start + ((get_random_long() % range) << PAGE_SHIFT);
}

Look better?

thx,

Jason.
