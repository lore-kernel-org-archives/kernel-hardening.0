From: "PaX Team" <pageexec@freemail.hu>
Date: Sun, 09 Apr 2017 22:24:47 +0200
MIME-Version: 1.0
Message-ID: <58EA988F.29293.6C80F08B@pageexec.freemail.hu>
In-reply-to: <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com>, <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Daniel Micay <danielmicay@gmail.com>, Andy Lutomirski <luto@kernel.org>
Cc: Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 Apr 2017 at 22:07, Andy Lutomirski wrote:
> grsecurity and PaX are great projects.  They have a lot of good ideas,
> and they're put together quite nicely.  The upstream kernel should
> *not* do things differently from they way they are in grsecurity/PaX
> just because it wants to be different.  Conversely, the upstream
> kernel should not do things the same way as PaX just to be more like
> PaX.

so weit so gut.

> Keep in mind that the upstream kernel and grsecurity/PaX operate under
> different constraints.  The upstream kernel tries to keep itself clean

so do we.

> and to make tree-wide updates rather that keeping compatibility stuff
> around.

so do we (e.g., fptr fixes for RAP, non-refcount atomic users, etc).

>  PaX and grsecurity presumably want to retain some degree of
> simplicity when porting to newer upstream versions.

s/simplicity/minimality/ as the code itself can be complex but that'll be
of the minimal complexity we can come up with.

> In the context of virtually mapped stacks / KSTACKOVERFLOW, this
> naturally leads to different solutions.  The upstream kernel had a
> bunch of buggy drivers that played badly with virtually mapped stacks.
> grsecurity sensibly went for the approach where the buggy drivers kept
> working.  The upstream kernel went for the approach of fixing the
> drivers rather than keeping a compatibility workaround.  Different
> constraints, different solutions.

except that's not what happened at all. spender's first version did just
a vmalloc for the kstack like the totally NIH'd version upstream does
now. while we always anticipated buggy dma users and thus had code that
would detect them so that we could fix them, we quickly figured that the
upstream kernel wasn't quite up to snuff as we had assumed and faced with
the amount of buggy code, we went for the current vmap approach which
kept users' systems working instead of breaking them.

you're trying to imply that upstream fixed the drivers but as the facts
show, that's not true. you simply unleashed your code on the world and
hoped(?) that enough suckers would try it out during the -rc window. as
we all know several releases and almost a year later, that was a losing
bet as you still keep fixing those drivers (and something tells me that
we haven't seen the end of it). this is simply irresponsible engineering
for no technical reason.

> In the case of rare writes or pax_open_kernel [1] or whatever we want
> to call it, CR3 would work without arch-specific code, and CR0 would
> not.  That's an argument for CR3 that would need to be countered by
> something.  (Sure, avoiding leaks either way might need arch changes.
> OTOH, a *randomized* CR3-based approach might not have as much of a
> leak issue to begin with.)

i have yet to see anyone explain what they mean by 'leak' here but if it
is what i think it is then the arch specific entry/exit changes are not
optional but mandatory. see below for randomization.

[merging in your other mail as it's the same topic]

> No one has explained how CR0.WP is weaker or slower than my proposal.

you misunderstood, Daniel was talking about your use_mm approach.

> Here's what I'm proposing:
> 
> At boot, choose a random address A.

what is the threat that a random address defends against?

>  Create an mm_struct that has a
> single VMA starting at A that represents the kernel's rarely-written
> section.  Compute O = (A - VA of rarely-written section).  To do a
> rare write, use_mm() the mm, write to (VA + O), then unuse_mm().

the problem is that the amount of __read_only data extends beyond vmlinux,
i.e., this approach won't scale. another problem is that it can't be used
inside use_mm and switch_mm themselves (no read-only task structs or percpu
pgd for you ;) and probably several other contexts.

last but not least, use_mm says this about itself:

    (Note: this routine is intended to be called only
    from a kernel thread context)

so using it will need some engineering (or the comment be fixed).

> This should work on any arch that has an MMU that allows this type of
> aliasing and that doesn't have PA-based protections on the rarely-written
> section.

you didn't address the arch-specific changes needed in the enter/exit paths.

> It'll be considerably slower than CR0.WP on a current x86 kernel, but,
> with PCID landed, it shouldn't be much slower.

based on my experience with UDEREF on amd64, unfortunately PCID isn't all
it's cracked up to be (IIRC, it maybe halved the UDEREF overhead instead of
basically eliminating it as i had anticipated, and that was on snb, ivb and
later do even worse).

> It has the added benefit that writes to non-rare-write data using the
> rare-write primitive will fail.

what is the threat model you're assuming for this feature? based on what i
have for PaX (arbitrary read/write access exploited for data-only attacks),
the above makes no sense to me...
