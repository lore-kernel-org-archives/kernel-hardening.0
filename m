Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 27 Nov 2015 09:05:54 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20151127080554.GB24991@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
 <5656D779.17137.12A1EA53@pageexec.freemail.hu>
 <20151126104229.GA8530@gmail.com>
 <5656F7A2.738.131F89C0@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5656F7A2.738.131F89C0@pageexec.freemail.hu>
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only
 memory
To: PaX Team <pageexec@freemail.hu>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


* PaX Team <pageexec@freemail.hu> wrote:

> On 26 Nov 2015 at 11:42, Ingo Molnar wrote:
> 
> > * PaX Team <pageexec@freemail.hu> wrote:
> > 
> > > On 26 Nov 2015 at 9:54, Ingo Molnar wrote:
> >
> > > e.g., imagine that the write was to a function pointer (even an entire ops 
> > > structure) or a boolean that controls some important feature for after-init 
> > > code. ignoring/dropping such writes could cause all kinds of logic bugs (if not 
> > > worse).
> > 
> > Well, the typical case is that it's a logic bug to _do_ the write: the structure 
> > was marked readonly for a reason but some init code re-runs during suspend or so.
> 
> that's actually not the typical case in my experience, but rather these two:
> 
> 1. initial mistake: someone didn't actually check whether the given object can
>    be __read_only
> 
> 2. code evolution: an object that was once written by __init code only (and
>    thus proactively subjected to __read_only) gets modified by non-init code
>    due to later changes
> 
> what you described above is a third case where there's a latent bug to begin 
> (unintended write) with that __read_only merely exposes but doesn't create 
> itself, unlike the two cases above (intended writes getting caught by wrong use 
> of __read_only).

You are right, I concede this part of the argument - what you describe is probably 
the most typical way to get ro-faults.

I do maintain the (sub-)argument that oopsing or relying on tooling help years 
down the line is vastly inferior to fixing up the problem and generating a 
one-time stack dump so that kernel developers have a chance to fix the bug. The 
sooner we detect and dump such information the more likely it is that such bugs 
don't get into end user kernel versions.

> my proposal would produce the exact same reports, the difference is in letting 
> the write attempt succeed vs. skipping it. this latter step is what is wrong 
> since it introduces at least a logic bug the same way the constprop optimization 
> created a logic bug.

Yes, you are right and I agree.

Does anyone want to submit such a patch for upstream? Looks like a good change.

Thanks,

	Ingo
