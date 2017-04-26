From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 26 Apr 2017 04:01:28 +0200
MIME-Version: 1.0
Message-ID: <58FFFF78.5586.1FBAC458@pageexec.freemail.hu>
In-reply-to: <1493160997-126108-1-git-send-email-keescook@chromium.org>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v2 0/2] x86, refcount: Implement fast refcount overflow
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Apr 2017 at 15:56, Kees Cook wrote:

> This protection is a modified version of the x86 PAX_REFCOUNT
> implementation from PaX/grsecurity. This speeds up the refcount_t API by
> duplicating the existing atomic_t implementation with a single instruction
> added to detect if the refcount has wrapped past INT_MAX (or below 0)
> resulting in a signed value.

'signed value' sounds somewhat ambiguous given that in C a signed type (such
as the one beneath refcount_t) can have both negative and positive values yet
you didn't mean the latter here i guess.

> Various differences from PaX:
> - uses "js" instead of "jo" to trap all signed results instead of just
>   under/overflow transitions

there're differences in my 4.11 port but this isn't one of them.
