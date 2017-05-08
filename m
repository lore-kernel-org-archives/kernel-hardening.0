Message-ID: <1494259725.2340.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 08 May 2017 12:08:45 -0400
In-Reply-To: <20170508114123.GB5480@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
	 <20170504154850.GE20461@leverpostej> <1493920184.1596.4.camel@gmail.com>
	 <20170504180917.GB19929@leverpostej> <20170505103839.GB699@leverpostej>
	 <1494005884.5150.6.camel@gmail.com> <20170508114123.GB5480@leverpostej>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-05-08 at 12:41 +0100, Mark Rutland wrote:
> On Fri, May 05, 2017 at 01:38:04PM -0400, Daniel Micay wrote:
> > On Fri, 2017-05-05 at 11:38 +0100, Mark Rutland wrote:
> > > On Thu, May 04, 2017 at 07:09:17PM +0100, Mark Rutland wrote:
> > > > On Thu, May 04, 2017 at 01:49:44PM -0400, Daniel Micay wrote:
> > > > > On Thu, 2017-05-04 at 16:48 +0100, Mark Rutland wrote:
> > > > > > ... with an EFI stub fortify_panic() hacked in, I can build
> > > > > > an
> > > > > > arm64 kernel with this applied. It dies at some point after
> > > > > > exiting EFI boot services; i don't know whether it made it
> > > > > > out
> > > > > > of the stub and into the kernel proper.
> > > > > 
> > > > > Could start with #define __NO_FORTIFY above the #include
> > > > > sections there instead (or -D__NO_FORTIFY as a compiler flag),
> > > > > which will skip fortifying those for now.
> > > > 
> > > > Neat. Given there are a few files, doing the latter for the stub
> > > > is the simplest option.
> > > > 
> > > > > I'm successfully using this on a non-EFI ARM64 3.18 LTS
> > > > > kernel,
> > > > > so it should be close to working on other systems (but not
> > > > > necessarily with messy drivers). The x86 EFI workaround works.
> > > > 
> > > > FWIW, I've been playing atop of next-20170504, with a tonne of
> > > > other debug options enabled (including KASAN_INLINE).
> > > > 
> > > > From a quick look with a JTAG debugger, the CPU got out of the
> > > > stub and into the kernel. It looks like it's dying initialising
> > > > KASAN, where the vectors appear to have been corrupted.
> > > 
> > > ... though it's a worring that __memcpy() is overridden. I think
> > > we
> > > need to be more careful with the way we instrument the string
> > > functions.
> > 
> > I don't think there's any way for the fortify code to be
> > intercepting
> > __memcpy. There's a memcpy function in
> > arch/x86/boot/compressed/string.c
> > defined via __memcpy and that appears to be working.
> 
> Just to check, are there additional patches to disable fortification
> of
> the KASAN code? With that, things seem fine.
> 
> > A shot in the dark is that it might not happen if a __real_memcpy
> > alias via __RENAME is used instead of __builtin_memcpy, but I'm not
> > sure how or why this is breaking in the first place.
> 
> Using a RENAME(__real_memcpy), and a call to that didn't help.
> 
> With the rename removed (i.e. just an extern __real_memcpy()), it
> called
> __real_memcpy as expected.
> 
> I think there's some unintended interaction with <asm/string.h>:
> 
> ---->8----
> #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
> 
> /*
>  * For files that are not instrumented (e.g. mm/slub.c) we
>  * should use not instrumented version of mem* functions.
>  */
> 
> #define memcpy(dst, src, len) __memcpy(dst, src, len)
> #define memmove(dst, src, len) __memmove(dst, src, len)
> #define memset(s, c, n) __memset(s, c, n)
> #endif
> ---->8----
> 
> If I *only* comment out the memcpy define above, KASAN's memcpy()
> calls
> __memcpy() as we expect.
> 
> Looking at the assembly, I see memmove() and memset() have the same
> issue, and messing with their <asm/string.h> defintion helps.
> 
> Looking at the preprocessed source, the fortified memcpy ends up as:
> 
> extern inline __attribute__((always_inline))
> __attribute__((no_instrument_function)) __attribute__((always_inline))
> __attribute__((gnu_inline)) void *__memcpy(void *p, const void *q,
> __kernel_size_t size)
> {
>  size_t p_size = __builtin_object_size(p, 0);
>  size_t q_size = __builtin_object_size(q, 0);
>  if (__builtin_constant_p(size) && (p_size < size || q_size < size))
>   __buffer_overflow();
>  if (p_size < size || q_size < size)
>   fortify_panic(__func__);
>  return __builtin_memcpy(p, q, size);
> }
> 
> ... i.e. we override __memcpy() rather than memcpy().
> 
> In KASAN, we undef memcpy before providing KASAN's version, so it
> keeps
> its intended name, ending up as:
> 
> void *memcpy(void *dest, const void *src, size_t len)
> {
>  check_memory_region((unsigned long)src, len, false, (unsigned
> long)__builtin_return_address(0));
>  check_memory_region((unsigned long)dest, len, true, (unsigned
> long)__builtin_return_address(0));
> 
>  return __memcpy(dest, src, len);
> }
> 
> ... then __memcpy() gets inlined and the builtin stuff resolved,
> calling
> memcpy().
> 
> This'll require some thought.
>
> > > FWIW, with that, and the previous bits, I can boot a next-20170504
> > > kernel with this applied.
> > > 
> > > However, I get a KASAN splat from the SLUB init code, even though
> > > that's deliberately not instrumented by KASAN:
> 
> [...]
> 
> > I'm not sure about this either. I'd like to avoid needing !KASAN
> > since
> > these are useful when paired together for finding bugs...
> 
> Likewise! I'd like to have both enabled for my fuzzing config.

Ah, it's happening because of that same #define issue. The wrapper ends
up overriding __memcpy in uninstrumented functions but then it ends up
calling __builtin_memcpy which makes it instrumented again.

An initial solution would be adding #define __NO_FORTIFY to that #if
block where memcpy and friends are redefined to disable KASan. It isn't
ideal, but it only impacts KASan builds and only where KASan is being
disabled. Alternatively, it could #define something for the fortify
wrappers to force them to use an alias for __memcpy instead of
__builtin_memcpy but I don't think it's worth the complexity for a tiny
bit of extra coverage in KASan builds. I'll take the easy path.
