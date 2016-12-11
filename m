Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Dec 2016 21:43:45 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161211204345.GA1558@kroah.com>
References: <20161209183659.25727-1-Jason@zx2c4.com>
 <20161210123725.GC21421@kroah.com>
 <CAHmME9qFjeiSFkXfyQQgpRyQCj7dDV9r+UM7S8W=QBsQX+=McQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9qFjeiSFkXfyQQgpRyQCj7dDV9r+UM7S8W=QBsQX+=McQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH] siphash: add cryptographically secure
 hashtable function
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, Herbert Xu <herbert@gondor.apana.org.au>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, ak@linux.intel.com, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 11, 2016 at 04:30:31PM +0100, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> Thanks for the review. Responses to your suggestions are inline below:
> 
> On Sat, Dec 10, 2016 at 1:37 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > Please use u64 and u8 instead of the userspace uint64_t and uint8_t
> > types for kernel code.  Yes, the ship has probably sailed for trying to
> > strictly enforce it, but it's a good idea to do where ever possible.
> 
> I didn't know this was a rule. Since I had seen a hodgepodge
> throughout the kernel I just sort of assumed it was a free for all.
> I've fixed this up for v2, and I've also gone through all of my other
> [not yet submitted] code and made this change.
> 
> > Any specific license for this code?  It's good to at the least say what
> > it is.  Yes, we know it will default to GPLv2 only as part of the whole
> > kernel tree, but it's good to be explicit for when someone wants to copy
> > this code for their own projects...
> 
> Public domain, actually. I'll add notice of this to the header.

Hm, there really is no such license as "Public domain" that works in all
countries, sorry.  You will note it's not one of the "valid module
license list" we have in module.h because of that.

So, I don't know where you got the code from, but perhaps "Dual BSD/GPL"
is the correct one for you?

Note, I'm not a lawyer, so this isn't legal advice about the license of
code, but I do spend way too much time with lawyers dealing with license
issues...

> >> +#define U8TO64(p) le64_to_cpu(*(__le64 *)(p))
> >
> > Why the crazy casting behind a macro?
> 
> le64_to_cpup doesn't take the right type. But I agree the macro is not
> the nicest way to do this. Instead, I'll copy what
> crypto/chacha20_generic.c does and define locally le64_to_cpuvp which
> takes a void pointer:
> 
> static inline u64 le64_to_cpuvp(const void *p)
> {
>         return le64_to_cpup(p);
> }

Ah much better.

> >> +__attribute__((optimize("unroll-loops")))
> >
> > Care to document why this attribute is needed?  Older versions of gcc
> > doesn't know how to handle it properly?  Faster with newer versions?
> > Black magic?  :)
> 
> It tells gcc to unroll the loops. Comparing the assembly, it looks
> like on x86_64, gcc does twice as many rounds per loop iteration when
> asked to unroll the loops. This allows the code to remain neat and
> straightforward, while instructing gcc to do the gnarly part.
> 
> Is this too much rice? Have I been Gentoo-ing for too long? Or are
> limited uses of unroll-loops acceptable?

Given that this would be the first use of it in the kernel, it might be
too much rice :)

Unless you can show real numbers that it actually matters, I wouldn't do
it, it's not worth the hassle.  That's the same rule for when you use
likely()/unlikely(), if you can not measure it, don't use it as you
almost always get it wrong, the compiler is smarter, and keeps getting
better over time.

> > s/uint64_t/u64/g please.
> 
> Done.
> 
> > EXPORT_SYMBOL_GPL()?  I have to ask, sorry :)
> 
> Since it's public domain, EXPORT_SYMBOL() is fine.
> 
> If you have some reason for preferring GPL2 over public domain, I'm
> happy to make the change. Maybe you want to preclude the new&shiny
> from proprietary modules? That's fine with me, if you desire it being
> that way.

Nope, I just have to ask :)

If it's dual licensed, a normal EXPORT_SYMBOL() is just fine, I have no
objection to that at all.

thanks,

greg k-h
