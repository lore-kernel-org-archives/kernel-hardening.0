Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 5 Sep 2011 16:46:47 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110905124647.GA10247@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
 <20110825171934.GA3044@albatros>
 <20110902182929.GA23848@openwall.com>
 <20110903111849.GA2743@albatros>
 <20110903235728.GD29169@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903235728.GD29169@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Sep 04, 2011 at 03:57 +0400, Solar Designer wrote:
> On Sat, Sep 03, 2011 at 03:18:49PM +0400, Vasiliy Kulikov wrote:
> > On Fri, Sep 02, 2011 at 22:29 +0400, Solar Designer wrote:
> > > On Thu, Aug 25, 2011 at 09:19:34PM +0400, Vasiliy Kulikov wrote:
> > > > additionally overwrite function arguments, which are located after the
> > > > function address on the stack.  The attacker's best bet may be to find
> > > > an entry point not at function boundary that sets registers and then
> > > > proceeds with or branches to the desired library code.  The easiest way
> > > > to set registers and branch would be a function epilogue -
> > > > pop/pop/.../ret - but then there's the difficulty in passing the address
> > > > to ret to (we have just one NUL and we've already used it to get to this
> > > > code).  Similarly, even via such pop's we can't pass an argument that
> > > > contains a NUL in it - e.g., the address of "/bin/sh" in libc (it
> > > > contains a NUL most significant byte too) or a zero value for root's
> > > > uid.
> > > 
> > > The above was partially flawed logic on my part - as written above
> > > (without further detail), the pop/pop/.../ret thing doesn't apply
> > > because those pop's would read stack right after the just-used return
> > > address - that is, the same stack locations that we presumably could not
> > > write to in order to pass the arguments in a more straightforward
> > > fashion.  So this trick would be of no help, and thus its other
> > > limitations would be of no relevance.
> > 
> > Why not?
> 
> I am not sure what exactly your "why not" applies to.

Hmm, yes, looks like I've lost the thread some time ago :(  A good
description definitely needs much longer and scrupulous analysis.
Probably there is a public paper with a review/analysis/benefits of
ASCII-armor that we're able to refer in the patch description?  I cannot
find any rigorous paper, unfortunately.


> > > > If CONFIG_VM86=y, the first megabyte is excluded from the potential
> > > > range for mmap allocations as it might be used by vm86 code.  If
> > > > CONFIG_VM86=n, the allocation begins from the mmap_min_addr.  Regardless
> > > > of CONFIG_VM86 the base address is randomized with the same entropy size
> > > > as mm->mmap_base.
> > > 
> > > OK.  Shouldn't CONFIG_VM86 be a sysctl, though?
> > 
> > This is not a hardening setting that was present in -ow, but an existing
> > config to disable vm86/vm86_old at the compile time.  It was added for
> > EMBEDDED.
> 
> Oh, I was not aware of that.
> 
> solar@host:~/kernel/mainline/linux-3.0.4 $ fgrep -rl CONFIG_VM86 .
> ./arch/x86/kernel/Makefile
> ./arch/x86/kernel/entry_32.S
> ./arch/x86/include/asm/vm86.h
> ./arch/x86/include/asm/processor-flags.h
> 
> Looks like there's no Kconfig option for this - perhaps add it with a
> separate patch?

Since 2.6.x CONFIG_ prefix is not used in Kconfig files:

$ grep -w VM86 arch/x86/Kconfig
config VM86
    bool "Enable VM86 support" if EXPERT


Thanks,

-- 
Vasiliy
