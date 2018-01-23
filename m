Date: Tue, 23 Jan 2018 10:17:49 +0000
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20180123101748.GA2604@arm.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180121104019.GS17719@n2100.armlinux.org.uk>
 <CAPcyv4iY9PWULZfGnKnTiD4tVxHSw4QfSwUBV4d=1KfnUjbgWw@mail.gmail.com>
 <CA+55aFyqAGRE4+QteYyvNyMzepFXHVVBn=A07Adj-yBs=tS_Ww@mail.gmail.com>
 <CAPcyv4gjDrTnC_xeuVWjonvF7_L1Y-OOQndMRyVDdaLmcC7NMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gjDrTnC_xeuVWjonvF7_L1Y-OOQndMRyVDdaLmcC7NMg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4.1 02/10] asm/nospec, array_ptr: sanitize speculative
 array de-references
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 22, 2018 at 10:52:54AM -0800, Dan Williams wrote:
> On Mon, Jan 22, 2018 at 10:37 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Note that 'idx' itself can have any range (that's kind of the _point_,
> > after all: checking that idx is in some range). But the logic only
> > works for a positive array size.
> >
> > Which honestly is not really a limitation, but it's worth spelling out, I think.

Agreed. We should be absolutely clear about when this thing works and when
it doesn't.

> > In particular, if you have a user pointer, and a 3G:1G split in
> > user:kernel address space, you camn *not* do something like
> >
> >     uptr = array_ptr(NULL, userptr, TASK_SIZE);
> >
> > to get a sanitized user pointer, because TASK_SIZE is not positive in 'long'.
> >
> > Hmm?
> 
> We could at least have a BUILD_BUG_ON when 'size' is a
> builtin_contstant and greater than LONG_MAX. Alternatively we could
> require archs to provide the equivalent of the x86 array_ptr_mask()
> that does not have the LONG_MAX limitation?

I'd rather avoid imposing that limitation and instead just treat uaccess
specially. It looks like we can satisfy the current definition of
array_ptr_mask with three instructions, but I'm not sure how we could get it
working on arm64 if we needed to deal with arbitrary sizes (particularly as
we're trying to avoid conditional instructions).

Will
