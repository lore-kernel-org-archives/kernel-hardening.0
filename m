Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 31 Jan 2018 09:03:10 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v5 02/12] array_idx: sanitize speculative array
 de-references
Message-ID: <20180131080310.ebqtxe5p7j54wglj@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
 <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <alpine.DEB.2.20.1801281931180.2126@nanos>
 <CAPcyv4hSZ7=+076s+fmJ0HQ293H4X8829-LTrbvd8ZqJygGV6A@mail.gmail.com>
 <CA+55aFxLEL+8YA4MYkeyeUH7K8rZwBmGe6Z9V8QS=TYCREWDTQ@mail.gmail.com>
 <CAPcyv4jTbH6As_SC2Po8j5mB6jKLcwMr3Yn=19aTN2yMgBR=iw@mail.gmail.com>
 <0575AF4FD06DD142AD198903C74E1CC87A6048F5@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0575AF4FD06DD142AD198903C74E1CC87A6048F5@ORSMSX103.amr.corp.intel.com>
To: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Van De Ven, Arjan <arjan.van.de.ven@intel.com> wrote:

> > > IOW, is there some work on tooling/analysis/similar? Not asking for
> > > near-term, but more of a "big picture" question..
> 
> short term there was some extremely rudimentary static analysis done. clearly 
> that has extreme limitations both in insane rate of false positives, and missing 
> cases.

What was the output roughly, how many suspect places that need array_idx_nospec() 
handling: a few, a few dozen, a few hundred or a few thousand?

I'm guessing 'static tool emitted hundreds of sites with many false positives 
included, but the real sites are probably a few dozen' - but that's really just a 
very, very wild guess.

Our whole mindset and approach with these generic APIs obviously very much depends 
on the order of magnitude:

- For array users up to a few dozen per 20 MLOC code base accumulated over 20
  years, and with no more than ~1 new site per kernel release we can probably
  do what we do for buffer overflows: static analyze and fix via 
  array_idx_nospec().

- If it's more than a few dozen then intuitively I'd also be very much in favor of
  compiler help: for example trickle down __user annotations that Sparse uses some
  more and let the compiler sanitize indices or warn about them - without hurting 
  performance of in-kernel array handling.

- If it's "hundreds" then probably both the correctness and the maintenance
  aspects won't scale well to a 20+ MLOC kernel code base - in that case we _have_
  to catch the out of range values at a much earlier stage, at the system call and
  other system ABI level, and probably need to do it via a self-maintaining 
  approach such as annotations/types that also warns about 'unsanitized' uses. But 
  filtering earlier has its own problems as well: mostly the layering violations 
  (high level interfaces often don't know the safe array index range) can create 
  worse bugs and more fragility than what is being fixed ...

- If it's "thousands" then it _clearly_ won't scale and we probably need compiler 
  help: i.e. a compiler that tracks ranges and automatically sanitizes indices. 
  This will have some performance effect, but should result in almost immediate 
  correctness.

Also, IMHO any tooling should very much be open source: this isn't the kind of bug 
that can be identified via code review, so there's no fall-back detection method 
like we have for buffer overflows.

Anyway, the approach taken very much depends on the order of magnitude of such 
affected array users we are targeting ...

Thanks,

	Ingo
