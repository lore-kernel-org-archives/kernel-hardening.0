MIME-Version: 1.0
In-Reply-To: <1493160997-126108-3-git-send-email-keescook@chromium.org>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org> <1493160997-126108-3-git-send-email-keescook@chromium.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 26 Apr 2017 02:25:23 +0200
Message-ID: <CAG48ez0udSMcD2GhgVj4amsqwVJ8qEw31A8SDnDjzgjMjAsHbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow protection
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 26, 2017 at 12:56 AM, Kees Cook <keescook@chromium.org> wrote:
> This protection is a modified version of the x86 PAX_REFCOUNT
> implementation from PaX/grsecurity. This speeds up the refcount_t API by
> duplicating the existing atomic_t implementation with a single instruction
> added to detect if the refcount has wrapped past INT_MAX (or below 0)
> resulting in a signed value.
[...]
> +static __always_inline void refcount_dec(refcount_t *r)
> +{
> +       asm volatile(LOCK_PREFIX "decl %0\n\t"
> +               REFCOUNT_CHECK_UNDERFLOW(4)
> +               : [counter] "+m" (r->refs.counter)
> +               : : "cc", "cx");
> +}

What purpose do checks on decrement now have? The mitigation is only
intended to deal with (positive) overflows, right? AFAICS if you hit this code,
similar to the inc-from-0 case, you're already in a UAF situation?
