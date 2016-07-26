Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160726170052.GI4541@io.lakedaemon.net>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
 <20160726030201.6775-1-jason@lakedaemon.net> <20160726033032.GD4541@io.lakedaemon.net>
 <CAGXu5jJo=8LYRarF8WqJg+b8Jf6ngZ_P_400HmuAk_j5-N-TcA@mail.gmail.com> <20160726170052.GI4541@io.lakedaemon.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 26 Jul 2016 10:07:22 -0700
Message-ID: <CAGXu5jLT-pZc_67UeTJj-dCsRJteT2CCwaviGOKCXHnL8t-URw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC patch 1/6] random: Simplify API for random address requests
To: Jason Cooper <jason@lakedaemon.net>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Nick Kralevich <nnk@google.com>, Jeffrey Vander Stoep <jeffv@google.com>, alyzyn@android.com, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 26, 2016 at 10:00 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Hi Kees,
>
> On Mon, Jul 25, 2016 at 09:39:58PM -0700, Kees Cook wrote:
>> On Mon, Jul 25, 2016 at 8:30 PM, Jason Cooper <jason@lakedaemon.net> wrote:
>> > On Tue, Jul 26, 2016 at 03:01:55AM +0000, Jason Cooper wrote:
>> >> To date, all callers of randomize_range() have set the length to 0, and
>> >> check for a zero return value.  For the current callers, the only way
>> >> to get zero returned is if end <= start.  Since they are all adding a
>> >> constant to the start address, this is unnecessary.
>> >>
>> >> We can remove a bunch of needless checks by simplifying the API to do
>> >> just what everyone wants, return an address between [start, start +
>> >> range].
>> >>
>> >> While we're here, s/get_random_int/get_random_long/.  No current call
>> >> site is adversely affected by get_random_int(), since all current range
>> >> requests are < MAX_UINT.  However, we should match caller expectations
>
> merf. UINT_MAX.
>
>> >> to avoid coming up short (ha!) in the future.
>> >>
>> >> Signed-off-by: Jason Cooper <jason@lakedaemon.net>
>> >> ---
>> >>  drivers/char/random.c  | 17 ++++-------------
>> >>  include/linux/random.h |  2 +-
>> >>  2 files changed, 5 insertions(+), 14 deletions(-)
>> >>
>> >> diff --git a/drivers/char/random.c b/drivers/char/random.c
>> >> index 0158d3bff7e5..1251cb2cbab2 100644
>> >> --- a/drivers/char/random.c
>> >> +++ b/drivers/char/random.c
>> >> @@ -1822,22 +1822,13 @@ unsigned long get_random_long(void)
>> >>  EXPORT_SYMBOL(get_random_long);
>> >>
>> >>  /*
>> >> - * randomize_range() returns a start address such that
>> >> - *
>> >> - *    [...... <range> .....]
>> >> - *  start                  end
>> >> - *
>> >> - * a <range> with size "len" starting at the return value is inside in the
>> >> - * area defined by [start, end], but is otherwise randomized.
>> >> + * randomize_addr() returns a page aligned address within [start, start +
>> >> + * range]
>> >>   */
>> >>  unsigned long
>> >> -randomize_range(unsigned long start, unsigned long end, unsigned long len)
>> >> +randomize_addr(unsigned long start, unsigned long range)
>> >>  {
>> >> -     unsigned long range = end - len - start;
>> >> -
>> >> -     if (end <= start + len)
>> >> -             return 0;
>> >> -     return PAGE_ALIGN(get_random_int() % range + start);
>> >> +     return PAGE_ALIGN(get_random_long() % range + start);
>> >>  }
>> >
>> > bah!  old patch file.  This should have been:
>> >
>> > if (range == 0)
>> >         return start;
>> > else
>> >         return PAGE_ALIGN(get_random_long() % range + start);
>>
>> I think range should be limited to start + range < UINTMAX,
>
> ULONG_MAX?  I agree.

Heh, I am plagued by misspelling these constants, and yes, sorry, ULONG_MAX. :)

> if (range == 0 || ULONG_MAX - range < start)
>         return start;

Should it "abort" like this? I was thinking just cap the range, something like:

if (range > ULONG_MAX - start)
    range = ULONG_MAX - start

> else
>         return PAGE_ALIGN(get_random_long() % range + start);
>
> ?
>
>> and it should be very clear if the range is inclusive or exclusive.
>
> Sorry, I was reading the original comment, '[start, end]'  with square
> brackets denoting inclusive.
>
> Regardless, the math in randomize_range() was just undoing the math at
> each of the call sites.  This proposed change to randomize_addr()
> doesn't alter the current state of affairs wrt inclusive, exclusive.
>
>> start = 0, range = 4096. does this mean 1 page, or 2 pages possible?
>
> ooh, good spot.  What we have right now is [start, start + range), which
> is matching previous behavior.  But does not match the old comment,
> [start, end].  It should have been [start, end).
>
> So, you're correct, I need to clarify this in the comments.

Okay, cool. Thanks! I'm glad to have this clean-up. :)

-Kees

>
> thx,
>
> Jason.



-- 
Kees Cook
Chrome OS & Brillo Security
