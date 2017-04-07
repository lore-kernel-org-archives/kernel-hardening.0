From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 07 Apr 2017 21:52:36 +0200
MIME-Version: 1.0
Message-ID: <58E7EE04.29218.6216C107@pageexec.freemail.hu>
In-reply-to: <alpine.DEB.2.20.1704071048360.1716@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>, <alpine.DEB.2.20.1704071048360.1716@nanos>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 Apr 2017 at 11:46, Thomas Gleixner wrote:

> On Fri, 7 Apr 2017, Mathias Krause wrote:
> > Well, doesn't look good to me. NMIs will still be able to interrupt
> > this code and will run with CR0.WP = 0.
> > 
> > Shouldn't you instead question yourself why PaX can do it "just" with
> > preempt_disable() instead?!
> 
> That's silly. Just because PaX does it, doesn't mean it's correct.

is that FUD or do you have actionable information to share?

> To be honest, playing games with the CR0.WP bit is outright stupid to begin with.

why is that? cr0.wp exists since the i486 and its behaviour fits my
purposes quite well, it's the best security/performance i know of.

> Whether protected by preempt_disable or local_irq_disable, to make that
> work it needs CR0 handling in the exception entry/exit at the lowest
> level.

correct.

> And that's just a nightmare maintainence wise as it's prone to be
> broken over time.

i've got 14 years of experience of maintaining it and i never saw it break.

> Aside of that it's pointless overhead for the normal case.

unless it's optional code as the whole feature already is.

> The proper solution is:
> 
> write_rare(ptr, val)
> {
>  mp = map_shadow_rw(ptr);
>  *mp = val;
>  unmap_shadow_rw(mp);
> }

this is not *the* proper solution, but only a naive one that suffers from
the exact same need that the cr0.wp approach does and has worse performance
impact. not exactly a win...

[continuing from your next mail in order to save round-trip time]

> I really do not care whether PaX wants to chase and verify that over and
> over.

verifying it is no different than verifying, say, swapgs use.

> I certainly don't want to take the chance to leak CR0.WP ever

why and where would cr0.wp leak?

> and I very much care about extra stuff to check in the entry/exit path.

your 'proper' solution needs (a lot more) extra stuff too.

> Why the heck should we care about rare writes being performant?

because you've been misled by the NIH crowd here that the PaX feature they
tried to (badly) extract from has anything to do with frequency of writes.
it does not. what it does do is provide an environment for variables that
are conceptually writable but for security reasons should be read-only most
of the time by most of the code (ditto for the grossly misunderstood and thus
misnamed ro-after-shit). now imagine locking down the page table hierarchy
with it...

> Making the world and some more writeable hardly qualifies as tightly
> focused.

you forgot to add 'for a window of a few insns' and that the map/unmap
approach does the same under an attacker controlled ptr.

> Making the mapping concept CPU local is not rocket science
> either. The question is whether it's worth the trouble.

it is for people who care about the integrity of the kernel, and all this
read-onlyness stuff implies that some do.
