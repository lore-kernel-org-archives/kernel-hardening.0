Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 10 Dec 2016 16:16:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20161210081643.GA384@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161210060316.GC6846@zzz>
Subject: Re: [kernel-hardening] Re: Remaining crypto API regressions with
 CONFIG_VMAP_STACK
To: Eric Biggers <ebiggers3@gmail.com>
Cc: kernel-hardening@lists.openwall.com, luto@amacapital.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@kernel.org, smueller@chronox.de
List-ID: <kernel-hardening.lists.openwall.com>

Why did you drop me from the CC list when you were replying to
my email?

Eric Biggers <ebiggers3@gmail.com> wrote:
> On Sat, Dec 10, 2016 at 01:32:08PM +0800, Herbert Xu wrote:
>
>> Are you sure? Any instance of *_ON_STACK must only be used with
>> sync algorithms and most drivers under drivers/crypto declare
>> themselves as async.
> 
> Why exactly is that?  Obviously, it wouldn't work if you returned from the stack
> frame before the request completed, but does anything stop someone from using an
> *_ON_STACK() request and then waiting for the request to complete before
> returning from the stack frame?

The *_ON_STACK variants (except SHASH of course) were simply hacks
to help legacy crypto API users to cope with the new async interface.
In general we should avoid using the sync interface when possible.

It's a bad idea for the obvious reason that most of our async
algorithms want to DMA and that doesn't work very well when you're
using memory from the stack.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
