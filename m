From: "PaX Team" <pageexec@freemail.hu>
Date: Mon, 10 Apr 2017 21:47:31 +0200
MIME-Version: 1.0
Message-ID: <58EBE153.31145.71853724@pageexec.freemail.hu>
In-reply-to: <CALCETrX+iQVjupq9NU5kOPypBBOSRziuvdGdnzCxTUXQkcFJcQ@mail.gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>, <58EA988F.29293.6C80F08B@pageexec.freemail.hu>, <CALCETrX+iQVjupq9NU5kOPypBBOSRziuvdGdnzCxTUXQkcFJcQ@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 9 Apr 2017 at 17:31, Andy Lutomirski wrote:

> On Sun, Apr 9, 2017 at 1:24 PM, PaX Team <pageexec@freemail.hu> wrote:
> >
> I consider breaking buggy drivers (in a way that they either generally
> work okay

do they work okay when the dma transfer goes to a buffer that crosses
physically non-contiguous page boundaries?

> or that they break with a nice OOPS depending on config) to
> be better than having a special case in what's supposed to be a fast
> path to keep them working.  I did consider forcing the relevant debug
> options on for a while just to help shake these bugs out the woodwork
> faster.

that's a false dichotomy, discovering buggy drivers is orthogonal to (not)
breaking users' systems as grsec shows. and how did you expect to 'shake
these bugs out' when your own suggestion at the time was for distros to
not enable this feature 'for a while'?

> > i have yet to see anyone explain what they mean by 'leak' here but if it
> > is what i think it is then the arch specific entry/exit changes are not
> > optional but mandatory. see below for randomization.
> 
> By "leak" I mean that a bug or exploit causes unintended code to run
> with CR0.WP or a special CR3 or a special PTE or whatever loaded.

how can a bug/exploit cause something like this?

>  PaX hooks the entry code to avoid leaks. 

PaX doesn't instrument enter/exit paths to prevent state leaks into interrupt
context (it's a useful sideeffect though), rather it's needed for correctness
if the kernel can be interrupted at all while it's open (address space switching
will need to handle this too but you have yet to address it).

> >> At boot, choose a random address A.
> >
> > what is the threat that a random address defends against?
> 
> Makes it harder to exploit a case where the CR3 setting leaks.

if an attacker has the ability to cause this leak (details of which are subject
to the question i asked above) then why wouldn't he simply also make use of the
primitives to modify his target via the writable vma without ever having to know
the randomized address? i also wonder what exploit power you assume for this
attack and whether that is already enough to simply go after page tables, etc
instead of figuring out the alternative address space.

> > the problem is that the amount of __read_only data extends beyond vmlinux,
> > i.e., this approach won't scale. another problem is that it can't be used
> > inside use_mm and switch_mm themselves (no read-only task structs or percpu
> > pgd for you ;) and probably several other contexts.
> 
> Can you clarify these uses that extend beyond vmlinux?

one obvious candidate is modules. how do you want to handle them? then there's
a whole bunch of dynamically allocated data that is a candidate for __read_only
treatment.

> > what is the threat model you're assuming for this feature? based on what i
> > have for PaX (arbitrary read/write access exploited for data-only attacks),
> > the above makes no sense to me...
> 
> If I use the primitive to try to write a value to the wrong section
> (write to kernel text, for example), IMO it would be nice to OOPS
> instead of succeeding.

this doesn't tell me what power you're assuming the attacker has. is it
my generic arbitrary read-write ability or something more restricted and
thus less realistic? i.e., how does the attacker get to 'use the primitive'
and (presumably) also control the ptr/data?

as for your specific example, kernel text isn't 'non-rare-write data' that
you spoke of before, but that aside, what prevents an attacker from computing
his target ptr so that after your accessor rebases it, it'd point back to his
intended target instead? will you range-check (find_vma eventually?) each time?
how will you make all this code safe from races from another task? the more
checks you make, the more likely that something sensitive will spill to memory
and be a target itself in order to hijack the sensitive write.

> Please keep in mind that, unlike PaX, uses of a pax_open_kernel()-like
> function will may be carefully audited by a friendly security expert
> such as yourself.  It would be nice to harden the primitive to a
> reasonable extent against minor misuses such as putting it in a
> context where the compiler will emit mov-a-reg-with-WP-set-to-CR0;
> ret.

i don't understand what's there to audit. if you want to treat a given piece
of data as __read_only then you have no choice but to allow writes to it via
the open/close mechanism and the compiler can tell you just where those
writes are (and even do the instrumentation when you get tired of doing it
by hand).
