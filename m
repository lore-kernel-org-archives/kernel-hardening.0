Date: Fri, 23 Mar 2018 23:36:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: ctr - avoid VLA use
Message-ID: <20180323153652.GA1760@gondor.apana.org.au>
References: <1521112738-13250-1-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1521112738-13250-1-git-send-email-s.mesoraca16@gmail.com>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 12:18:58PM +0100, Salvatore Mesoraca wrote:
>
> +#define MAX_BLOCKSIZE 16
> +
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +#define MAX_ALIGNMASK 15
> +#else
> +#define MAX_ALIGNMASK 0
> +#endif
> +

Hmm, this won't work.  Just because you have efficient unaligned
access in general doesn't mean that every implementation can live
with unaligned access.  In particular, on x86 there are quite a
few implementations that require alignment or they will fault.

So please just make it 15 unconditionally.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
