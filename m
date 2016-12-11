Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161210123725.GC21421@kroah.com>
References: <20161209183659.25727-1-Jason@zx2c4.com> <20161210123725.GC21421@kroah.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun, 11 Dec 2016 16:30:31 +0100
Message-ID: <CAHmME9qFjeiSFkXfyQQgpRyQCj7dDV9r+UM7S8W=QBsQX+=McQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] siphash: add cryptographically secure
 hashtable function
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>, "Daniel J . Bernstein" <djb@cr.yp.to>, Herbert Xu <herbert@gondor.apana.org.au>, George Spelvin <linux@horizon.com>, Scott Bauer <sbauer@eng.utah.edu>, ak@linux.intel.com, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Greg,

Thanks for the review. Responses to your suggestions are inline below:

On Sat, Dec 10, 2016 at 1:37 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> Please use u64 and u8 instead of the userspace uint64_t and uint8_t
> types for kernel code.  Yes, the ship has probably sailed for trying to
> strictly enforce it, but it's a good idea to do where ever possible.

I didn't know this was a rule. Since I had seen a hodgepodge
throughout the kernel I just sort of assumed it was a free for all.
I've fixed this up for v2, and I've also gone through all of my other
[not yet submitted] code and made this change.

> Any specific license for this code?  It's good to at the least say what
> it is.  Yes, we know it will default to GPLv2 only as part of the whole
> kernel tree, but it's good to be explicit for when someone wants to copy
> this code for their own projects...

Public domain, actually. I'll add notice of this to the header.

> Don't we have this in kernel.h somewhere?  Ah, yeah, it's rol64() in
> bitops.h, no need to define it again please.

Thanks!

>
>> +#define U8TO64(p) le64_to_cpu(*(__le64 *)(p))
>
> Why the crazy casting behind a macro?

le64_to_cpup doesn't take the right type. But I agree the macro is not
the nicest way to do this. Instead, I'll copy what
crypto/chacha20_generic.c does and define locally le64_to_cpuvp which
takes a void pointer:

static inline u64 le64_to_cpuvp(const void *p)
{
        return le64_to_cpup(p);
}

>> +__attribute__((optimize("unroll-loops")))
>
> Care to document why this attribute is needed?  Older versions of gcc
> doesn't know how to handle it properly?  Faster with newer versions?
> Black magic?  :)

It tells gcc to unroll the loops. Comparing the assembly, it looks
like on x86_64, gcc does twice as many rounds per loop iteration when
asked to unroll the loops. This allows the code to remain neat and
straightforward, while instructing gcc to do the gnarly part.

Is this too much rice? Have I been Gentoo-ing for too long? Or are
limited uses of unroll-loops acceptable?

> s/uint64_t/u64/g please.

Done.

> EXPORT_SYMBOL_GPL()?  I have to ask, sorry :)

Since it's public domain, EXPORT_SYMBOL() is fine.

If you have some reason for preferring GPL2 over public domain, I'm
happy to make the change. Maybe you want to preclude the new&shiny
from proprietary modules? That's fine with me, if you desire it being
that way.

>
>
> pr_info()?

Ack.

>
>> +                     ret = -1;
>
> Pick a real error number?

I started to do this, but couldn't make up my mind, and then resigned
to -1. I'll redouble my efforts to pick something decent.

> pr_info()?

Ack.

> Don't we have a "do crypto/library/whatever selftests at boot" config
> option that this little test could be put under?  It would be great to
> not have to manually add DEBUG to the build to verify this works on a
> specific arch.

There is crypto/testmgr.c, but it's designed for testing things that
use the actual crypto API. Clearly for a hashtable function, nobody
would accept the overhead of the enormous crypto API, so siphash has
to remain an ordinary fast function call. Also, it lives in lib/, not
in crypto/. For that reason, I thought that Herbert might object if I
clutter up his testmgr with non crypto API functions. I'll CC him on
this email to double check.

> This looks really nice, but we don't usually add stuff into lib/ unless
> there is an actual user of the code :)
>
> Have you tried converting any of the existing hash users to use this
> instead?  If you did that, and it shows a solution for the known
> problems with our existing hashes (as you point out above), I doubt
> there would be any objection for this patch at all.

Here's where the controversy begins! As we've seen from this thread,
there are two hurdles:

1. Convincing people that the cryptographic properties of siphash are
important, and jhash does not have these. I think JP Aumasson's email
described things pretty clearly, and this isn't really up for debate
anymore.
2. Convincing people that for a particular use case, siphash _is_
sufficiently fast, and that any potential (tiny) slowdown, compared to
insecure function like jhash, is either a) not worth having a
known-vulnerability or b) not even measurably relavent for the actual
real life workload.

I suspect that the debates about (2.a) and (2.b) will need to be duked
out one-by-one for a bit of time. I thought that since this will be
more of an evolutionary change, it'd be best to at least get the
primitives into lib/ so they can actually be used.

For example, I found some patches from George Spelvin (CC'd) trying to
get this added a few years back, for reasons related to extfs code. I
found a discussion between Scott Bauer (CC'd) and Andy&Andi (CC'd)
about adding siphash for the purpose of SROP mitigation, but not doing
so because there wasn't the primitive in lib/.

Seeing that siphash is both a solution to current existing problems,
future security mechanisms, and current things people clearly seem to
want, I thought it might be worthwhile to add this straight-up.

But if you really really want me to submit this alongside a patch
series of places that could be changed, I guess I could take the time
to pick out the most uncontroversial places -- some network stack /
netfilter places, some userspace API hashtable DoS places, etc -- but
I fear that's going to drag so many different consumers into the fold
that in the end nothing will get merged. So I think this might be a
good case for an exception with /lib, as a means of making forward
progress in general. Feel free to disagree, though; you know best.

Regards,
Jason
