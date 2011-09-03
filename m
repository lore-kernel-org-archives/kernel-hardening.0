Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 3 Sep 2011 15:18:49 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110903111849.GA2743@albatros>
References: <20110812102954.GA3496@albatros>
 <20110812105824.GA7141@openwall.com>
 <20110825171934.GA3044@albatros>
 <20110902182929.GA23848@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902182929.GA23848@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 02, 2011 at 22:29 +0400, Solar Designer wrote:
> On Thu, Aug 25, 2011 at 09:19:34PM +0400, Vasiliy Kulikov wrote:
> > This patch changes mmap base address allocator logic to incline to
> > allocate addresses for executable pages from the first 16 Mbs of address
> 
> s/Mbs/MiB/ (or just MB, whereas Mb is sometimes used to denote megabits)

OK.

> > space.  These addresses start from zero byte (0x00AABBCC).  Using such
> > addresses breaks ret2libc exploits abusing string buffer overflows (or
> > does it much harder).
> 
> s,does it much harder,makes such attacks harder and/or less reliable,

OK.

> > As x86 architecture is little-endian, this zero byte is the last byte of
> > the address.  So it's possible to e.g. overwrite a return address on the
> > stack with the mailformed address.  However, now it's impossible to
> 
> s/mailformed/malformed/

Oops.

> > additionally overwrite function arguments, which are located after the
> > function address on the stack.  The attacker's best bet may be to find
> > an entry point not at function boundary that sets registers and then
> > proceeds with or branches to the desired library code.  The easiest way
> > to set registers and branch would be a function epilogue -
> > pop/pop/.../ret - but then there's the difficulty in passing the address
> > to ret to (we have just one NUL and we've already used it to get to this
> > code).  Similarly, even via such pop's we can't pass an argument that
> > contains a NUL in it - e.g., the address of "/bin/sh" in libc (it
> > contains a NUL most significant byte too) or a zero value for root's
> > uid.
> 
> The above was partially flawed logic on my part - as written above
> (without further detail), the pop/pop/.../ret thing doesn't apply
> because those pop's would read stack right after the just-used return
> address - that is, the same stack locations that we presumably could not
> write to in order to pass the arguments in a more straightforward
> fashion.  So this trick would be of no help, and thus its other
> limitations would be of no relevance.

Why not?  If function address contains NUL, the overflow stops at this
address.  If it doesn't contain NUL, but argument contain NUL, it is the
last argument an attacker can use (therefore, it would be the last
used code chunk).  So, it has some value even if he can somehow write
the ret address (e.g. it is out of 16 MBs).


> > If CONFIG_VM86=y, the first megabyte is excluded from the potential
> > range for mmap allocations as it might be used by vm86 code.  If
> > CONFIG_VM86=n, the allocation begins from the mmap_min_addr.  Regardless
> > of CONFIG_VM86 the base address is randomized with the same entropy size
> > as mm->mmap_base.
> 
> OK.  Shouldn't CONFIG_VM86 be a sysctl, though?

This is not a hardening setting that was present in -ow, but an existing
config to disable vm86/vm86_old at the compile time.  It was added for
EMBEDDED.


> > +#ifdef CONFIG_VM86
> > +/*
> > + * Don't touch any memory that can be used by vm86 apps.
> > + * Reserve the first Mb + 64 kb of guard pages.
> > + */
> > +#define ASCII_ARMOR_MIN_ADDR (0x00100000 + 0x00010000)
> 
> The extra 64 KiB are not "guard pages".  The rationale is that these
> are addresses available from VM86 mode, as well as from real mode with
> line A20 enabled on 286+ machines (dosemu may run DOS drivers and
> programs from that era).  This was a way to get slightly more of usable
> memory under DOS - IIRC, I had something like 900+ KB total DOS memory,
> 736 KB free after full bootup on a 386 (with proper drivers and
> configuration tweaks).  Not everyone was happy with a mere 640 KB, of
> which only 550 KB or so would be free after DOS bootup.
> 
> http://en.wikipedia.org/wiki/Real_mode#Addressing_capacity
> 
> "So, the actual amount of memory addressable by the 80286 and later x86
> CPUs in real mode is 1 MiB + 64 KiB - 16 B = 1114096 B."

Yes, my bad.

Thanks,

-- 
Vasiliy
