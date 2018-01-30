MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1801281931180.2126@nanos>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com> <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <alpine.DEB.2.20.1801281931180.2126@nanos>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 22:29:12 -0800
Message-ID: <CAPcyv4hSZ7=+076s+fmJ0HQ293H4X8829-LTrbvd8ZqJygGV6A@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] array_idx: sanitize speculative array de-references
Content-Type: text/plain; charset="UTF-8"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 10:36 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 28 Jan 2018, Dan Williams wrote:
>> On Sun, Jan 28, 2018 at 12:55 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> + */
>> >> +#define array_idx(idx, sz)                                           \
>> >> +({                                                                   \
>> >> +     typeof(idx) _i = (idx);                                         \
>> >> +     typeof(sz) _s = (sz);                                           \
>> >> +     unsigned long _mask = array_idx_mask(_i, _s);                   \
>> >> +                                                                     \
>> >> +     BUILD_BUG_ON(sizeof(_i) > sizeof(long));                        \
>> >> +     BUILD_BUG_ON(sizeof(_s) > sizeof(long));                        \
>> >> +                                                                     \
>> >> +     _i &= _mask;                                                    \
>> >> +     _i;                                                             \
>> >> +})
>> >> +#endif /* __NOSPEC_H__ */
>> >
>> > For heaven's sake, please name a size variable as 'size', not 'sz'. We don't have
>> > a shortage of characters and can deobfuscate common primitives, can we?
>> >
>> > Also, beyond the nits, I also hate the namespace here. We have a new generic
>> > header providing two new methods:
>> >
>> >         #include <linux/nospec.h>
>> >
>> >         array_idx_mask()
>> >         array_idx()
>> >
>> > which is then optimized for x86 in asm/barrier.h. That's already a non-sequitor.
>> >
>> > Then we introduce uaccess API variants with a _nospec() postfix.
>> >
>> > Then we add ifence() to x86.
>> >
>> > There's no naming coherency to this.
>>
>> Ingo, I love you, but please take the incredulity down a bit,
>> especially when I had 'nospec' in all the names in v1. Thomas, Peter,
>> and Alexei wanted s/nospec_barrier/ifence/ and
>
> Sorry, I never was involved in that discussion.
>
>> s/array_idx_nospec/array_idx/. You can always follow on with a patch
>> to fix up the names and placements to your liking. While they'll pick
>> on my name choices, they won't pick on yours, because I simply can't
>> be bothered to care about a bikeshed color at this point after being
>> bounced around for 5 revisions of this patch set.
>
> Oh well, we really need this kind of attitude right now. We are all fed up
> with that mess, but Ingo and I care about the details, consistency and
> general code quality beyond the current rush to get stuff solved. It's our
> damned job as maintainers.

Of course, and everything about the technical feedback and suggestions
was completely valid, on point, and made the patches that much better.
What wasn't appreciated and what I am tired of grinning and bearing is
the idea that it's only the maintainer that can show emotion, that
it's only the maintainer that can be exasperated and burnt out.

For example, I would have spun v6 the same day (same hour?) had the
mail started, "hey I'm late to the party, why aren't all these helpers
in a new _nospec namespace?". I might have pointed to the mails from
Peter about ifence being his preferred name for a speculation barrier
and Alexei's request to drop nospec [1] and moved on because naming is
a maintainer's prerogative.

> If you decide you don't care anymore, please let me know, so I can try to
> free up some cycles to pick up the stuff from where you decided to dump it.

Care is a two way street. I respect yours and Ingo's workload, please
respect mine.

[1]: https://lkml.org/lkml/2018/1/9/1232
