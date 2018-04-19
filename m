Date: Thu, 19 Apr 2018 12:35:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/4] x86/crypto: camellia: Fix function prototypes
In-Reply-To: <CAGXu5jLerFuW=-uxpegBinAjJN0shPJkYAVaz9K7VWzVRmnOEQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1804191233500.1563@nanos.tec.linutronix.de>
References: <20180415041542.5364-1-jmoreira@suse.de> <20180415041542.5364-2-jmoreira@suse.de> <20180416061044.z6eb4psw2sbszemb@gmail.com> <CAGXu5jLerFuW=-uxpegBinAjJN0shPJkYAVaz9K7VWzVRmnOEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Joao Moreira <jmoreira@suse.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 18 Apr 2018, Kees Cook wrote:
> So, instead of the original series, how about something like this:
> 
> Switch function pointers to not use the function cast, and define a
> new GLUE_FUNC macro that kinda looks like the tricks used for
> syscalls:
> 
> static const struct common_glue_ctx camellia_enc = {
> ...
>         .funcs = { {
> ...
>                 .num_blocks = 1,
>                 .fn_u = { .ecb = camellia_enc_blk }
>         } }
> };
> 
> #define GLUE_FUNC(func, context) \
> static inline void func(void *ctx, u8 *dst, const u8 *src) \
> { __##func((context)ctx, dst, src); } \
> __##func(context ctx, u8 *dst, const u8 *src)
> 
> GLUE_FUNC(camellia_enc_blk, struct camellia_ctx *)
> {
> ...original function...
> }

I was about to suggest this before I read to the end of the mail. Yes, that
is much more palatable.

Thanks,

	tglx
