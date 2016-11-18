Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.20.1611181146330.26818@east.gentwo.org>
References: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au> <alpine.DEB.2.20.1611181146330.26818@east.gentwo.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 18 Nov 2016 09:55:08 -0800
Message-ID: <CAGXu5jKC8XTP=gjCGQYEEwSQEAWM66E8HedaEqZR3F=QSm+aTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: Christoph Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 18, 2016 at 9:47 AM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 17 Nov 2016, Michael Ellerman wrote:
>
>> Currently ZERO_OR_NULL_PTR() uses a trick of doing a single check that
>> x <= ZERO_SIZE_PTR, and ignoring the fact that it also matches 1-15.
>
> Well yes that was done so we do not add too many branches all over the
> kernel.....

There are actually very few callers of this macro. (Though it's
possible they're executed frequently.)

>> That no longer really works once we add the poison delta, so split it
>> into two checks. Assign x to a temporary to avoid evaluating it
>> twice (suggested by Kees Cook).
>
> And now you are doing just that.

In this case, what about the original < ZERO_SIZE_PTR check Michael
suggested? At least the one use in usercopy.c needs to be fixed, but
otherwise, it should be fine?

-Kees

-- 
Kees Cook
Nexus Security
