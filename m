Date: Thu, 4 May 2017 19:09:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170504180917.GB19929@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
 <20170504154850.GE20461@leverpostej>
 <1493920184.1596.4.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493920184.1596.4.camel@gmail.com>
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 04, 2017 at 01:49:44PM -0400, Daniel Micay wrote:
> On Thu, 2017-05-04 at 16:48 +0100, Mark Rutland wrote:
> > Hi,
> > 
> > From a glance, in the arm64 vdso case, that's due to the definition of
> > vdso_start as a char giving it a single byte size.
> > 
> > We can/should probably use char[] for vdso_{start,end} on arm/arm64 as
> > we do for other linker symbols (and x86 and tile do for
> > vdso_{start,end}), i.e.
> 
> Yeah, I think that's the right approach, and this also applies to
> features like -fsanitize=object-size in UBSan. I worked around it by
> bypassing the function with __builtin_memcmp as I did for the other
> cases I ran into, but they should all be fixed properly upstream.

Sure.

> > With that fixed, I see we also need a fortify_panic() for the EFI
> > stub.
> > 
> > I'm not sure if the x86 EFI stub gets linked with the
> > boot/compressed/misc.c version below, and/or whether it's safe for
> > the EFI stub to call that.
> > 
> > ... with an EFI stub fortify_panic() hacked in, I can build an arm64
> > kernel with this applied. It dies at some point after exiting EFI
> > boot services; i don't know whether it made it out of the stub and
> > into the kernel proper.
> 
> Could start with #define __NO_FORTIFY above the #include sections there
> instead (or -D__NO_FORTIFY as a compiler flag), which will skip
> fortifying those for now.

Neat. Given there are a few files, doing the latter for the stub is the
simplest option.

> I'm successfully using this on a non-EFI ARM64 3.18 LTS kernel, so it
> should be close to working on other systems (but not necessarily with
> messy drivers). The x86 EFI workaround works.

FWIW, I've been playing atop of next-20170504, with a tonne of other
debug options enabled (including KASAN_INLINE).

>From a quick look with a JTAG debugger, the CPU got out of the stub and
into the kernel. It looks like it's dying initialising KASAN, where the
vectors appear to have been corrupted.

I have a rough idea of why that might be.

> > > It isn't particularly bad, but there are likely some issues that
> > > occur
> > > during regular use at runtime (none found so far).
> > 
> > It might be worth seeing if anyone can throw syzkaller and friends at
> > this.
> 
> It tends to find stack buffer overflows, etc. not detected by ASan, so
> that'd be nice. Can expand coverage a bit to some heap allocations
> with these, but I expect slab debugging and ASan already found most of
> what these would uncover:
> 
> https://github.com/thestinger/linux-hardened/commit/6efe84cdb88f73e8b8c59b59a8ea46fa4b1bdab1.patch
> https://github.com/thestinger/linux-hardened/commit/d342da362c5f852c1666dce461bc82521b6711e4.patch
> 
> Unfortunately, ksize means alloc_size on kmalloc is not 100% correct
> since the extra space from size class rounding falls outside of what it
> will claim to be the size of the allocation. C standard libraries with
> _FORTIFY_SOURCE seem to ignore this problem for malloc_usable_size. It
> doesn't have many uses though.

Perhaps I've misunderstood, but does that matter?

If a caller is relying on accessing padding, I'd say that's a bug.

Thanks,
Mark.
