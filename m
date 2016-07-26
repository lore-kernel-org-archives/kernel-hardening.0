Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 15:55:28 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160726155528.GH4541@io.lakedaemon.net>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
 <20160726030201.6775-1-jason@lakedaemon.net>
 <CAGXu5jKpJwurH5wgsMmaWC4mZLFTRLTT_r4ny3iohSBS2WUDEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKpJwurH5wgsMmaWC4mZLFTRLTT_r4ny3iohSBS2WUDEw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC patch 1/6] random: Simplify API for random address requests
To: Kees Cook <keescook@chromium.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Nick Kralevich <nnk@google.com>, Jeffrey Vander Stoep <jeffv@google.com>, Mark Salyzyn <salyzyn@android.com>, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 25, 2016 at 09:44:27PM -0700, Kees Cook wrote:
> On Mon, Jul 25, 2016 at 8:01 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> > To date, all callers of randomize_range() have set the length to 0, and
> > check for a zero return value.  For the current callers, the only way
> > to get zero returned is if end <= start.  Since they are all adding a
> > constant to the start address, this is unnecessary.
> >
> > We can remove a bunch of needless checks by simplifying the API to do
> > just what everyone wants, return an address between [start, start +
> > range].
> >
> > While we're here, s/get_random_int/get_random_long/.  No current call
> > site is adversely affected by get_random_int(), since all current range
> > requests are < MAX_UINT.  However, we should match caller expectations
> > to avoid coming up short (ha!) in the future.
> >
> > Signed-off-by: Jason Cooper <jason@lakedaemon.net>
> > ---
> >  drivers/char/random.c  | 17 ++++-------------
> >  include/linux/random.h |  2 +-
> >  2 files changed, 5 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/char/random.c b/drivers/char/random.c
> > index 0158d3bff7e5..1251cb2cbab2 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -1822,22 +1822,13 @@ unsigned long get_random_long(void)
> >  EXPORT_SYMBOL(get_random_long);
> >
> >  /*
> > - * randomize_range() returns a start address such that
> > - *
> > - *    [...... <range> .....]
> > - *  start                  end
> > - *
> > - * a <range> with size "len" starting at the return value is inside in the
> > - * area defined by [start, end], but is otherwise randomized.
> > + * randomize_addr() returns a page aligned address within [start, start +
> > + * range]
> >   */
> >  unsigned long
> > -randomize_range(unsigned long start, unsigned long end, unsigned long len)
> > +randomize_addr(unsigned long start, unsigned long range)
> 
> Also, this series isn't bisectable since randomize_range gets removed
> here before the callers are updated. Perhaps add a macro that calls
> randomize_addr with a BUG_ON for len != 0? (And then remove it in the
> last patch?)

No, I was thinking just add randomize_addr() in the first patch, convert
all the callers, then the last patch would remove randomize_range().

That way the last patch can be a cleanup in a later merge window if
needed.

thx,

Jason.
