Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 3 Feb 2016 17:02:21 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <56B272B8.2050808@redhat.com>
Message-ID: <alpine.DEB.2.20.1602031658060.6707@east.gentwo.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org> <20160126070320.GB28254@js1304-P5Q-DELUXE> <56B24B01.30306@redhat.com> <CAGXu5jJK1UhNX7h2YmxxTrCABr8oS=Y2OBLMr4KTxk7LctRaiQ@mail.gmail.com> <56B272B8.2050808@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC][PATCH 0/3] Speed up SLUB poisoning + disable checks
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Laura Abbott <labbott@fedoraproject.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

> The fast path uses the per cpu caches. No locks are taken and there
> is no IRQ disabling. For concurrency protection this comment
> explains it best:
>
> /*
>  * The cmpxchg will only match if there was no additional
>  * operation and if we are on the right processor.
>  *
>  * The cmpxchg does the following atomically (without lock
>  * semantics!)
>  * 1. Relocate first pointer to the current per cpu area.
>  * 2. Verify that tid and freelist have not been changed
>  * 3. If they were not changed replace tid and freelist
>  *
>  * Since this is without lock semantics the protection is only
>  * against code executing on this cpu *not* from access by
>  * other cpus.
>  */
>
> in the slow path, IRQs and locks have to be taken at the minimum.
> The debug options disable ever loading the per CPU caches so it
> always falls back to the slow path.

You could add the use of per cpu lists to the slow paths as well in
order
to increase performance. Then weave in the debugging options.

But the performance of the fast path is critical to the overall
performance of the kernel as a whole since this is a heavily used code
path for many subsystems.
