MIME-Version: 1.0
References: <20190506191950.9521-1-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 14:54:19 -0700
Message-ID: <CAGXu5jJ40OaniqR+rwu2npRNM4hGjbZoReWF=vhE99hB1Dqbow@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] x86/crypto: Fix crypto function casts
Content-Type: text/plain; charset="UTF-8"
To: Joao Moreira <jmoreira@suse.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 6, 2019 at 12:20 PM Joao Moreira <jmoreira@suse.de> wrote:
> It is possible to indirectly invoke functions with prototypes that do not
> match those of the respectively used function pointers by using void types.
> This feature is frequently used as a way of relaxing function invocation,
> making it possible that different data structures are passed to different
> functions through the same pointer.
>
> Despite the benefits, this can lead to a situation where functions with a
> given prototype are invoked by pointers with a different prototype, what is
> undesirable as it may prevent the use of heuristics such as prototype
> matching-based Control-Flow Integrity, which can be used to prevent
> ROP-based attacks.
>
> One way of fixing this situation is through the use of helper functions
> with prototypes that match the one in the respective invoking pointer.
>
> Given the above, the current efforts to improve the Linux security, and the
> upcoming kernel support to compilers with CFI features, fix the prototype
> casting of x86/crypto algorithms camellia, cast6, serpent and twofish with
> the use of a macro that generates the helper function.
>
> This patch does not introduce semantic changes to the cryptographic
> algorithms, yet, if someone finds relevant, the affected algorithms were
> tested with the help of tcrypt.ko without any visible harm.

Awesome; thanks for working on this! I'm looking through the patches
now and pondering solutions to the RFC in twofish. I'll send notes in
a bit...

-- 
Kees Cook
