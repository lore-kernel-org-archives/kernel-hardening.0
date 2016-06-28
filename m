Reply-To: kernel-hardening@lists.openwall.com
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org>
References: <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org> <cover.1466974736.git.luto@kernel.org> <cover.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <697.1467100340.1@warthog.procyon.org.uk>
Date: Tue, 28 Jun 2016 08:52:20 +0100
Message-ID: <699.1467100340@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v4 02/29] rxrpc: Avoid using stack memory in SG lists in rxkad
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

Andy Lutomirski <luto@kernel.org> wrote:

> -	skcipher_request_set_crypt(req, &sg[1], &sg[0], sizeof(tmpbuf), iv.x);
> +	skcipher_request_set_crypt(req, &sg, &sg, sizeof(tmpbuf), iv.x);

Don't the sg's have to be different?  Aren't they both altered by the process
of reading/writing from them?

> 	struct rxrpc_skb_priv *sp;
> ...
> +	swap(tmpbuf.xl, *(__be64 *)sp);
> +
> +	sg_init_one(&sg, sp, sizeof(tmpbuf));

????  I assume you're assuming that the rxrpc_skb_priv struct contents can
arbitrarily replaced temporarily...

And using an XCHG-equivalent instruction?  This won't work on a 32-bit arch
(apart from one that sports CMPXCHG8 or similar).

>  /*
> - * load a scatterlist with a potentially split-page buffer
> + * load a scatterlist
>   */
> -static void rxkad_sg_set_buf2(struct scatterlist sg[2],
> +static void rxkad_sg_set_buf2(struct scatterlist sg[1],
>  			      void *buf, size_t buflen)
>  {
> -	int nsg = 1;
> -
> -	sg_init_table(sg, 2);
> -
> +	sg_init_table(sg, 1);
>  	sg_set_buf(&sg[0], buf, buflen);
> -	if (sg[0].offset + buflen > PAGE_SIZE) {
> -		/* the buffer was split over two pages */
> -		sg[0].length = PAGE_SIZE - sg[0].offset;
> -		sg_set_buf(&sg[1], buf + sg[0].length, buflen - sg[0].length);
> -		nsg++;
> -	}
> -
> -	sg_mark_end(&sg[nsg - 1]);
> -
> -	ASSERTCMP(sg[0].length + sg[1].length, ==, buflen);
>  }

This should be a separate patch.

David
