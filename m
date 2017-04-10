Date: Mon, 10 Apr 2017 10:26:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <58E7EE04.29218.6216C107@pageexec.freemail.hu>
Message-ID: <alpine.DEB.2.20.1704100913520.1810@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>, <alpine.DEB.2.20.1704071048360.1716@nanos> <58E7EE04.29218.6216C107@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement
 __arch_rare_write_begin/unmap()
To: PaX Team <pageexec@freemail.hu>
Cc: Mathias Krause <minipli@googlemail.com>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 7 Apr 2017, PaX Team wrote:
> On 7 Apr 2017 at 11:46, Thomas Gleixner wrote:
> 
> > On Fri, 7 Apr 2017, Mathias Krause wrote:
> > > Well, doesn't look good to me. NMIs will still be able to interrupt
> > > this code and will run with CR0.WP = 0.
> > > 
> > > Shouldn't you instead question yourself why PaX can do it "just" with
> > > preempt_disable() instead?!
> > 
> > That's silly. Just because PaX does it, doesn't mean it's correct.
> 
> is that FUD or do you have actionable information to share?

That has absolutely nothing to do with FUD. I'm merily not accepting
argumentations which say: PaX can do it "just"....

That has exactly zero technical merit and it's not asked too much to
provide precise technical arguments why one implementation is better than
some other.

> > To be honest, playing games with the CR0.WP bit is outright stupid to begin with.
> 
> why is that? cr0.wp exists since the i486 and its behaviour fits my
> purposes quite well, it's the best security/performance i know of.

Works for me has never be a good engineering principle.

> > Whether protected by preempt_disable or local_irq_disable, to make that
> > work it needs CR0 handling in the exception entry/exit at the lowest
> > level.
> 
> correct.
> 
> > And that's just a nightmare maintainence wise as it's prone to be
> > broken over time.
> 
> i've got 14 years of experience of maintaining it and i never saw it break.

It's a difference whether you maintain a special purpose patch set out of
tree for a subset of architectures - I certainly know what I'm talking
about - or keeping stuff sane in the upstream kernel.

> > I certainly don't want to take the chance to leak CR0.WP ever
>
> why and where would cr0.wp leak?

It's bound to happen due to some subtle mistake and up to the point where
you catch it (in the scheduler or entry/exit path) the world is
writeable. And that will be some almost never executed error path which can
be triggered by a carefully crafted attack. A very restricted writeable
region is definitely preferred over full world writeable then, right?

> > Why the heck should we care about rare writes being performant?
> 
> because you've been misled by the NIH crowd here that the PaX feature they
> tried to (badly) extract from has anything to do with frequency of writes.

It would be apprectiated if you could keep your feud out of this. It's
enough to tell me that 'rare write' is a misleading term and why.

> > Making the world and some more writeable hardly qualifies as tightly
> > focused.
> 
> you forgot to add 'for a window of a few insns' and that the map/unmap

If it'd be guaranteed to be a few instructions, then I wouldn't be that
worried. The availability of make_world_writeable() as an unrestricted
usable function makes me nervous as hell. We've had long standing issues
where kmap_atomic() got leaked through a hard to spot almost never executed
error handling path. And the same is bound to happen with this, just with a
way worse outcome.

> approach does the same under an attacker controlled ptr.

Which attacker controlled pointer?

Thanks,

	tglx
