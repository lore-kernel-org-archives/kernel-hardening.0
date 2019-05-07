MIME-Version: 1.0
References: <20190507161321.34611-1-keescook@chromium.org> <20190507170039.GB1399@sol.localdomain>
In-Reply-To: <20190507170039.GB1399@sol.localdomain>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 May 2019 14:07:51 -0700
Message-ID: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Content-Type: text/plain; charset="UTF-8"
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 7, 2019 at 10:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Given the above, the current efforts to improve the Linux security,
> > and the upcoming kernel support to compilers with CFI features, this
> > creates macros to be used to build the needed function definitions,
> > to be used in camellia, cast6, serpent, twofish, and aesni.
>
> So why not change the function prototypes to be compatible with common_glue_*_t
> instead, rather than wrapping them with another layer of functions?  Is it
> because indirect calls into asm code won't be allowed with CFI?

I don't know why they're not that way to begin with. But given that
the casting was already happening, this is just moving it to a place
where CFI won't be angry. :)

> >   crypto: x86/crypto: Use new glue function macros
>
> This one should be "x86/serpent", not "x86/crypto".

Oops, yes, that's my typo. I'll fix for v4. Do the conversions
themselves look okay (the changes are pretty mechanical)? If so,
Herbert, do you want a v4 with the typo fix, or do you want to fix
that up yourself?

Thanks!

-- 
Kees Cook
