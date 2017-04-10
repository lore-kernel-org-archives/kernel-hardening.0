MIME-Version: 1.0
In-Reply-To: <58EA988F.29293.6C80F08B@pageexec.freemail.hu>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com>
 <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com> <58EA988F.29293.6C80F08B@pageexec.freemail.hu>
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 9 Apr 2017 17:31:36 -0700
Message-ID: <CALCETrX+iQVjupq9NU5kOPypBBOSRziuvdGdnzCxTUXQkcFJcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: PaX Team <pageexec@freemail.hu>
Cc: Daniel Micay <danielmicay@gmail.com>, Andy Lutomirski <luto@kernel.org>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 9, 2017 at 1:24 PM, PaX Team <pageexec@freemail.hu> wrote:
>
>> In the context of virtually mapped stacks / KSTACKOVERFLOW, this
>> naturally leads to different solutions.  The upstream kernel had a
>> bunch of buggy drivers that played badly with virtually mapped stacks.
>> grsecurity sensibly went for the approach where the buggy drivers kept
>> working.  The upstream kernel went for the approach of fixing the
>> drivers rather than keeping a compatibility workaround.  Different
>> constraints, different solutions.
>
> except that's not what happened at all. spender's first version did just
> a vmalloc for the kstack like the totally NIH'd version upstream does
> now. while we always anticipated buggy dma users and thus had code that
> would detect them so that we could fix them, we quickly figured that the
> upstream kernel wasn't quite up to snuff as we had assumed and faced with
> the amount of buggy code, we went for the current vmap approach which
> kept users' systems working instead of breaking them.
>
> you're trying to imply that upstream fixed the drivers but as the facts
> show, that's not true. you simply unleashed your code on the world and
> hoped(?) that enough suckers would try it out during the -rc window. as
> we all know several releases and almost a year later, that was a losing
> bet as you still keep fixing those drivers (and something tells me that
> we haven't seen the end of it). this is simply irresponsible engineering
> for no technical reason.

I consider breaking buggy drivers (in a way that they either generally
work okay or that they break with a nice OOPS depending on config) to
be better than having a special case in what's supposed to be a fast
path to keep them working.  I did consider forcing the relevant debug
options on for a while just to help shake these bugs out the woodwork
faster.

>
>> In the case of rare writes or pax_open_kernel [1] or whatever we want
>> to call it, CR3 would work without arch-specific code, and CR0 would
>> not.  That's an argument for CR3 that would need to be countered by
>> something.  (Sure, avoiding leaks either way might need arch changes.
>> OTOH, a *randomized* CR3-based approach might not have as much of a
>> leak issue to begin with.)
>
> i have yet to see anyone explain what they mean by 'leak' here but if it
> is what i think it is then the arch specific entry/exit changes are not
> optional but mandatory. see below for randomization.

By "leak" I mean that a bug or exploit causes unintended code to run
with CR0.WP or a special CR3 or a special PTE or whatever loaded.  PaX
hooks the entry code to avoid leaks.

>> At boot, choose a random address A.
>
> what is the threat that a random address defends against?

Makes it harder to exploit a case where the CR3 setting leaks.

>
>>  Create an mm_struct that has a
>> single VMA starting at A that represents the kernel's rarely-written
>> section.  Compute O = (A - VA of rarely-written section).  To do a
>> rare write, use_mm() the mm, write to (VA + O), then unuse_mm().
>
> the problem is that the amount of __read_only data extends beyond vmlinux,
> i.e., this approach won't scale. another problem is that it can't be used
> inside use_mm and switch_mm themselves (no read-only task structs or percpu
> pgd for you ;) and probably several other contexts.

Can you clarify these uses that extend beyond vmlinux?  I haven't
looked at the grsecurity patch extensively.  Are you talking about the
BPF JIT stuff?  If so, I think that should possibly be handled a bit
differently, since I think the normal
write-to-rare-write-vmlinux-sections primitive should preferably *not*
be usable to write to executable pages.  Using a real mm_struct for
this could help.

>
> last but not least, use_mm says this about itself:
>
>     (Note: this routine is intended to be called only
>     from a kernel thread context)
>
> so using it will need some engineering (or the comment be fixed).

Indeed.

>> It has the added benefit that writes to non-rare-write data using the
>> rare-write primitive will fail.
>
> what is the threat model you're assuming for this feature? based on what i
> have for PaX (arbitrary read/write access exploited for data-only attacks),
> the above makes no sense to me...
>

If I use the primitive to try to write a value to the wrong section
(write to kernel text, for example), IMO it would be nice to OOPS
instead of succeeding.

Please keep in mind that, unlike PaX, uses of a pax_open_kernel()-like
function will may be carefully audited by a friendly security expert
such as yourself.  It would be nice to harden the primitive to a
reasonable extent against minor misuses such as putting it in a
context where the compiler will emit mov-a-reg-with-WP-set-to-CR0;
ret.
