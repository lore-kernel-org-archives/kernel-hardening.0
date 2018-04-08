Date: Sun, 8 Apr 2018 17:18:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/6] crypto: ctr - avoid VLA use
Message-ID: <20180408091823.4m6xw477ly6yfnzt@gondor.apana.org.au>
References: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
 <1523126303-23205-3-git-send-email-s.mesoraca16@gmail.com>
 <20180408031935.GC25197@gondor.apana.org.au>
 <CAJHCu1LQuvcxsfTYddN5o3=pMzj6mtnBKvTG9O378pv3w_Q24Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHCu1LQuvcxsfTYddN5o3=pMzj6mtnBKvTG9O378pv3w_Q24Q@mail.gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 08, 2018 at 10:58:48AM +0200, Salvatore Mesoraca wrote:
>
> Fair enough.
> After removing the individual checks the modification to the single files
> will be just a couple of lines, is it OK for you if I collapse all of them in
> just a single commit?

Sure.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
