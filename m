From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 10 Apr 2017 21:55:45 +0200
MIME-Version: 1.0
Message-ID: <58EBE341.4772.718CC141@pageexec.freemail.hu>
In-reply-to: <alpine.DEB.2.20.1704100913520.1810@nanos>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <58E7EE04.29218.6216C107@pageexec.freemail.hu>, <alpine.DEB.2.20.1704100913520.1810@nanos>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mathias Krause <minipli@googlemail.com>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10 Apr 2017 at 10:26, Thomas Gleixner wrote:

> On Fri, 7 Apr 2017, PaX Team wrote:
> > On 7 Apr 2017 at 11:46, Thomas Gleixner wrote:
> > > That's silly. Just because PaX does it, doesn't mean it's correct.
> > 
> > is that FUD or do you have actionable information to share?
> 
> That has absolutely nothing to do with FUD. I'm merily not accepting
> argumentations which say: PaX can do it "just"....

you implied that what PaX does may not be correct. if you can't back that
up with facts and technical arguments then it is FUD. your turn.

> That has exactly zero technical merit and it's not asked too much to
> provide precise technical arguments why one implementation is better than
> some other.

exactly. start with explaining what is not correct in PaX with "precise
technical arguments".

> > > To be honest, playing games with the CR0.WP bit is outright stupid to begin with.
> > 
> > why is that? cr0.wp exists since the i486 and its behaviour fits my
> > purposes quite well, it's the best security/performance i know of.
> 
> Works for me has never be a good engineering principle.

good thing i didn't say that. on the other hand you failed to provide "precise
technical arguments" for why "playing games with the CR0.WP bit is outright
stupid to begin with". do you have any to share and discuss?

> > > And that's just a nightmare maintainence wise as it's prone to be
> > > broken over time.
> > 
> > i've got 14 years of experience of maintaining it and i never saw it break.
> 
> It's a difference whether you maintain a special purpose patch set out of
> tree for a subset of architectures - I certainly know what I'm talking
> about - or keeping stuff sane in the upstream kernel.

there's no difference to me, i keep my stuff sane regardless. of course what
you do with your out-of-tree code is your business but don't extrapolate it
to mine. now besides argumentum ad verecundiam do you have "precise technical
arguments" as to why maintaining a cr0.wp based approach would be "a nightmare
maintainence wise as it's prone to be broken over time."?

> > > I certainly don't want to take the chance to leak CR0.WP ever
> >
> > why and where would cr0.wp leak?
> 
> It's bound to happen due to some subtle mistake

i don't see what subtle mistake you're thinking of here. can you give me
an example?

> and up to the point where you catch it (in the scheduler or entry/exit path)
> the world is writeable.

where such a leak is caught depends on what subtle mistake you're talking
about, so let's get back to this point once you answered that question.

> And that will be some almost never executed error path which can
> be triggered by a carefully crafted attack.

open/close calls have nothing to do with error paths or even conditional
execution, they're always executed as a sequence so this situation cannot
occur.

> A very restricted writeable region is definitely preferred over full
> world writeable then, right? 

it doesn't matter when the attacker has an arbitrary read/write primitive
which he can just use to modify that 'very restricted writeable region'
to whatever he needs to cover first. now if all the data managing this
region were also protected then it'd matter but that's never going to
happen in the upstream kernel.

> > > Making the world and some more writeable hardly qualifies as tightly
> > > focused.
> > 
> > you forgot to add 'for a window of a few insns' and that the map/unmap
> 
> If it'd be guaranteed to be a few instructions, then I wouldn't be that
> worried.

it is, by definition assignments to otherwise __read_only data are (have to
be) bracketed with open/close instrumentation.

> The availability of make_world_writeable() as an unrestricted
> usable function makes me nervous as hell.

i can't imagine the nightmares you must have lived through for the two decades
during which the kernel was all wide open... spass beiseite, we can address
these fears of yours once you explain just what kind of error situations you
have in mind and why they don't also apply to say text_poke().

> We've had long standing issues where kmap_atomic() got leaked through a
> hard to spot almost never executed error handling path. And the same is
> bound to happen with this, just with a way worse outcome. 

the lifetime and use of kmaps is very different so you'll have to explain
in more detail why the problems they had apply here as well.

> > approach does the same under an attacker controlled ptr.
> 
> Which attacker controlled pointer?

i meant the one passed to the map/unmap code, attacker control over it means
the whole world is effectively writable again (Andy's vma approach would restrict
this to just the interesting read-only data except the whole thing is irrelevant
until all participating data (vma, page tables, etc) are also protected).
