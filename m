Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Nov 2016 12:19:42 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CAGXu5jKC8XTP=gjCGQYEEwSQEAWM66E8HedaEqZR3F=QSm+aTg@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1611181219250.27160@east.gentwo.org>
References: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au> <alpine.DEB.2.20.1611181146330.26818@east.gentwo.org> <CAGXu5jKC8XTP=gjCGQYEEwSQEAWM66E8HedaEqZR3F=QSm+aTg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


On Fri, 18 Nov 2016, Kees Cook wrote:
> In this case, what about the original < ZERO_SIZE_PTR check Michael
> suggested? At least the one use in usercopy.c needs to be fixed, but
> otherwise, it should be fine?

Looks like it.
