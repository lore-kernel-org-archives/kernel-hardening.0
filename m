Date: Thu, 29 Jun 2017 12:05:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CAGXu5jJEi_CS-CB=-4369TFRyeN4oQdmGS+HV-zoi4rSPpq3Jw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1706291204460.17478@east.gentwo.org>
References: <20170623015010.GA137429@beast> <CAGXu5jJEi_CS-CB=-4369TFRyeN4oQdmGS+HV-zoi4rSPpq3Jw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] mm: Add SLUB free list pointer obfuscation
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <labbott@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 25 Jun 2017, Kees Cook wrote:

> The difference gets lost in the noise, but if the above is sensible,
> it's 0.07% slower. ;)

Hmmm... These differences add up. Also in a repetative benchmark like that
you do not see the impact that the additional cacheline use in the cpu
cache has on larger workloads. Those may be pushed over the edge of l1 or
l2 capacity at some point which then causes drastic regressions.
