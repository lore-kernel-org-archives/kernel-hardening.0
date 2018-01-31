Date: Wed, 31 Jan 2018 15:21:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 02/12] array_idx: sanitize speculative array
 de-references
Message-ID: <20180131142138.GA9233@kroah.com>
References: <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com>
 <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <alpine.DEB.2.20.1801281931180.2126@nanos>
 <CAPcyv4hSZ7=+076s+fmJ0HQ293H4X8829-LTrbvd8ZqJygGV6A@mail.gmail.com>
 <CA+55aFxLEL+8YA4MYkeyeUH7K8rZwBmGe6Z9V8QS=TYCREWDTQ@mail.gmail.com>
 <CAPcyv4jTbH6As_SC2Po8j5mB6jKLcwMr3Yn=19aTN2yMgBR=iw@mail.gmail.com>
 <0575AF4FD06DD142AD198903C74E1CC87A6048F5@ORSMSX103.amr.corp.intel.com>
 <20180131080310.ebqtxe5p7j54wglj@gmail.com>
 <0575AF4FD06DD142AD198903C74E1CC87A605256@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0575AF4FD06DD142AD198903C74E1CC87A605256@ORSMSX103.amr.corp.intel.com>
To: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 31, 2018 at 02:13:45PM +0000, Van De Ven, Arjan wrote:
> > > short term there was some extremely rudimentary static analysis done. clearly
> > > that has extreme limitations both in insane rate of false positives, and missing
> > > cases.
> > 
> > What was the output roughly, how many suspect places that need
> > array_idx_nospec()
> > handling: a few, a few dozen, a few hundred or a few thousand?
> > 
> > I'm guessing 'static tool emitted hundreds of sites with many false positives
> > included, but the real sites are probably a few dozen' - but that's really just a
> > very, very wild guess.
> 
> your guess is pretty accurate; we ended up with some 15 or so places
> (the first patch kit Dan mailed out)

But in looking at that first patch set, I don't see many, if any, that
could be solved with your proposal of copy_from_user_struct().  The two
networking patches couldn't, the scsi one was just bizarre (seriously,
you had to trust the input from the hardware, if not, there's worse
things happening), and the networking drivers were dealing with other
data streams I think.

So while I love the idea of copy_from_user_struct(), I don't see it as
any type of "this will solve the issues we are trying to address here"
solution :(

I've been emailing the Coverity people recently about this, and they
say they are close to having a ruleset/test that can identify this data
pattern better than the original tool that Intel and others came up
with.  But as I haven't seen the output of it yet, I have no idea if
that's true or not.  Hopefully they will release it in a few days so we
can get an idea of if this is even going to be possible to automatically
scan for at all with their tool.

Other than Coverity, I don't know of any other tool that is trying to
even identify this pattern :(

> > Also, IMHO any tooling should very much be open source: this isn't the kind of
> > bug
> > that can be identified via code review, so there's no fall-back detection method
> > like we have for buffer overflows.
> 
> we absolutely need some good open source tooling; my personal
> preference will be a compiler plugin; that way you can use all the
> fancy logic inside the compilers for analysis, and you can make a "I
> don't care just fix it" option in addition to flagging for human
> inspection as the kernel would.

I thought gcc plugins were going to enable this type of analysis, or
maybe clang plugins, but I have yet to hear of anyone working on this.

thanks,

greg k-h
