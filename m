MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180416061044.z6eb4psw2sbszemb@gmail.com>
References: <20180415041542.5364-1-jmoreira@suse.de> <20180415041542.5364-2-jmoreira@suse.de>
 <20180416061044.z6eb4psw2sbszemb@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Apr 2018 09:07:31 -0700
Message-ID: <CAGXu5jLerFuW=-uxpegBinAjJN0shPJkYAVaz9K7VWzVRmnOEQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/crypto: camellia: Fix function prototypes
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Joao Moreira <jmoreira@suse.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 15, 2018 at 11:10 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Joao Moreira <jmoreira@suse.de> wrote:
>
>> Convert the use of 'struct camellia_ctx *' to 'void *' in prototypes of
>> functions which are referenced through 'struct common_glue_func_entry',
>> making their prototypes match those of this struct and, consequently,
>> turning them compatible with CFI requirements.
>>
>> Whenever needed, cast 'void *' to 'struct camellia_ctx *'.
>
>> +static inline void camellia_enc_blk(void *ctx, u8 *dst, const u8 *src)
>>  {
>> -     __camellia_enc_blk(ctx, dst, src, false);
>> +     __camellia_enc_blk((struct camellia_ctx *) ctx, dst, src, false);
>>  }
>
> I don't see how this is an improvement: instead of having a proper type there's
> now an opaque type and an ugly (and dangerous) type cast.

I agree with your instinct, as the existing best-practice in the
kernel is to always use correct types and avoid casts to let the
compiler check things, avoid nasty surprises, etc, but for callbacks
with context pointers, we're already just hiding the casts in various
places. For example, even without this patch:

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);

#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))

static const struct common_glue_ctx camellia_enc = {
...
        .funcs = { {
...
                .num_blocks = 1,
                .fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
        } }
};

While it is nicely wrapped up in macros, this is actually casting away
the _entire_ function prototype, not just the first argument. The
"camellia_enc_blk" function could point to anything (even "void
(*func)(void)") and the compiler wouldn't complain. And this was done
just to mask the ctx argument.

> What does "compatible with CFI requirements" mean?

As Joao mentioned, he wrote this up pretty well in his 0/n patch:
https://lkml.kernel.org/r/20180415041542.5364-1-jmoreira@suse.de

To further clarify, fine-grained function-prototype-checking CFI makes
sure that indirect function call sites only call functions with a
matching expected prototype (to protect against having function
pointers rewritten during an attack, etc). In this case, callers of
.fn_u.ecb() expect the target function to have the prototype "void
(*func)(void *ctx, u8 *dst, const u8 *src)" (as defined by struct
common_glue_ctx), however, camellia_enc_blk() is "void (*func)(struct
camellia_ctx *ctx, u8 *dst, const u8 *src)" and will trip the CFI
check.

If we rearrange our macro magic to defining the callbacks rather than
defining the function pointers, I think we'll gain several things:

- we will cast only the ctx argument instead of the entire function prototype
- we'll retain (and improve) source-code robustness against generally miscasting
- CFI will be happy

So, instead of the original series, how about something like this:

Switch function pointers to not use the function cast, and define a
new GLUE_FUNC macro that kinda looks like the tricks used for
syscalls:

static const struct common_glue_ctx camellia_enc = {
...
        .funcs = { {
...
                .num_blocks = 1,
                .fn_u = { .ecb = camellia_enc_blk }
        } }
};

#define GLUE_FUNC(func, context) \
static inline void func(void *ctx, u8 *dst, const u8 *src) \
{ __##func((context)ctx, dst, src); } \
__##func(context ctx, u8 *dst, const u8 *src)

GLUE_FUNC(camellia_enc_blk, struct camellia_ctx *)
{
...original function...
}


-Kees

-- 
Kees Cook
Pixel Security
