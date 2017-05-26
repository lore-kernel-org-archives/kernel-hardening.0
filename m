Message-ID: <1495787706.2392.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 26 May 2017 04:35:06 -0400
In-Reply-To: <CAGXu5jJQpiSHVw-6OeS92i2UU+QFDeXN9Wrs-V_8YKD_fHuqNg@mail.gmail.com>
References: <20170522231025.30463-1-danielmicay@gmail.com>
	 <CAGXu5jJQpiSHVw-6OeS92i2UU+QFDeXN9Wrs-V_8YKD_fHuqNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] add the option of fortified string.h functions
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-05-25 at 20:40 -0700, Kees Cook wrote:
> On Mon, May 22, 2017 at 4:10 PM, Daniel Micay <danielmicay@gmail.com>
> wrote:
> > diff --git a/arch/x86/include/asm/string_64.h
> > b/arch/x86/include/asm/string_64.h
> > index 733bae07fb29..3c5b26e07b85 100644
> > --- a/arch/x86/include/asm/string_64.h
> > +++ b/arch/x86/include/asm/string_64.h
> > @@ -77,6 +77,11 @@ int strcmp(const char *cs, const char *ct);
> >  #define memcpy(dst, src, len) __memcpy(dst, src, len)
> >  #define memmove(dst, src, len) __memmove(dst, src, len)
> >  #define memset(s, c, n) __memset(s, c, n)
> > +
> > +#ifndef __NO_FORTIFY
> > +#define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc.
> > */
> > +#endif
> > +
> >  #endif
> > 
> >  #define __HAVE_ARCH_MEMCPY_MCSAFE 1
> 
> Ah-ha, this same KASAN exclusion is missing for string_32.h, which is
> what I think akpm tripped over in build tests.
> 
> -Kees

It's not KASAN-related but rather some cruft that's still around in the
32-bit x86 header. It unnecessarily defines memcpy as __builtin_memcpy
even though the built-in is already used on modern GCC, while the 64-bit 
header only does a similar define for GCC < 4.3. I'll just make it stop
doing that with fortify enabled.
