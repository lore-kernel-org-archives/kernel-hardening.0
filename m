Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 16 Apr 2018 08:10:44 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/4] x86/crypto: camellia: Fix function prototypes
Message-ID: <20180416061044.z6eb4psw2sbszemb@gmail.com>
References: <20180415041542.5364-1-jmoreira@suse.de>
 <20180415041542.5364-2-jmoreira@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180415041542.5364-2-jmoreira@suse.de>
To: Joao Moreira <jmoreira@suse.de>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>


* Joao Moreira <jmoreira@suse.de> wrote:

> Convert the use of 'struct camellia_ctx *' to 'void *' in prototypes of
> functions which are referenced through 'struct common_glue_func_entry',
> making their prototypes match those of this struct and, consequently,
> turning them compatible with CFI requirements.
> 
> Whenever needed, cast 'void *' to 'struct camellia_ctx *'.

> +static inline void camellia_enc_blk(void *ctx, u8 *dst, const u8 *src)
>  {
> -	__camellia_enc_blk(ctx, dst, src, false);
> +	__camellia_enc_blk((struct camellia_ctx *) ctx, dst, src, false);
>  }

I don't see how this is an improvement: instead of having a proper type there's 
now an opaque type and an ugly (and dangerous) type cast.

What does "compatible with CFI requirements" mean?

Thanks,

	Ingo
