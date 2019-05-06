MIME-Version: 1.0
References: <20190506191950.9521-1-jmoreira@suse.de> <20190506191950.9521-4-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-4-jmoreira@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 15:19:55 -0700
Message-ID: <CAGXu5jKt9NuGeHumTkO2aD1MoBdP-OwRTXu1_qq0r8_t=Y6sMw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] Fix twofish crypto functions prototype casts
Content-Type: text/plain; charset="UTF-8"
To: Joao Moreira <jmoreira@suse.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 6, 2019 at 12:20 PM Joao Moreira <jmoreira@suse.de> wrote:
> RFC: twofish_enc_blk_ctr_3way is assigned both to .ecb and to .ctr,
> what makes its declaration through the macro undoable, as thought in
> this patch. Suggestions on how to fix this are welcome.

This looks like a typo in the original code (due to the lack of type checking!)

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
...
#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
...
void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
                             le128 *iv)

static const struct common_glue_ctx twofish_ctr = {
...
               .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
...
        return glue_ctr_req_128bit(&twofish_ctr, req);

int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
                        struct skcipher_request *req)
...
                                gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);

The twofish_ctr structure is actually only ever using the .ctr
assignment in the code, but it's a union, so the assignment via .ecb
is the same as .ctr.

-- 
Kees Cook
