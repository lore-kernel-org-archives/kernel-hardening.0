Date: Fri, 7 Jul 2017 12:06:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CAGXu5jLmU2vrP2ftQd=EvC7-OEzV+Nm7zYEf=6C0kZuoUEBXvA@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1707071205490.14728@east.gentwo.org>
References: <20170706002718.GA102852@beast> <alpine.DEB.2.20.1707060841170.23867@east.gentwo.org> <CAGXu5jKHkKgF90LXbFvrc3fa2PAaaaYHvCbiBM-9aN16TrHL=g@mail.gmail.com> <alpine.DEB.2.20.1707061052380.26079@east.gentwo.org> <1499363602.26846.3.camel@redhat.com>
 <CAGXu5jKQJ=9B-uXV-+BB7Y0EQJ_Xpr3OvUHr6c57TceFvNkxbw@mail.gmail.com> <alpine.DEB.2.20.1707070844100.11769@east.gentwo.org> <CAGXu5jLmU2vrP2ftQd=EvC7-OEzV+Nm7zYEf=6C0kZuoUEBXvA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v3] mm: Add SLUB free list pointer obfuscation
To: Kees Cook <keescook@chromium.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Daniel Mack <daniel@zonque.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Linux-MM <linux-mm@kvack.org>, Tycho Andersen <tycho@docker.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 7 Jul 2017, Kees Cook wrote:

> If we also added a >0 offset, that would make things even less
> deterministic. Though I wonder if it would make the performance impact
> higher. The XOR patch right now is very light.

There would be barely any performance impact if you keep the offset within
a cacheline since most objects start on a cacheline boundary. The
processor has to fetch the cacheline anyways.
