Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2016 21:46:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160623194617.GS30154@twins.programming.kicks-ass.net>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <20160623191123.GE30935@twins.programming.kicks-ass.net>
 <CA+55aFzuNg5pfv_S_55u1tGhfUEux16wwiUSeCStKfha2MrxBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzuNg5pfv_S_55u1tGhfUEux16wwiUSeCStKfha2MrxBQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 12:34:24PM -0700, Linus Torvalds wrote:
> On Thu, Jun 23, 2016 at 12:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > Didn't we talk about using SLAB_DESTROY_BY_RCU for task_struct before?
> > If that is possible, a reuse in per-cpu cache is equally possible.
> >
> > All we really want to guarantee is that the memory remains a
> > task_struct, it need not remain the same task, right?
> 
> No, we can't do SLAB_DESTROY_BY_RCU for the task_struct itself,
> because the RCU list traversal does expect that the thread and task
> lists are stable even if it walks into a "stale" struct task_struct.

Indeed.

OK, so the situation we talked about before is different, we wanted to
do SLAB_DESTROY_BY_RCU on top of the existing delayed_put_task_struct()
to get a double grace period.

The problem was for things like rq->curr, which isn't RCU managed as
such, we could still do:

	rcu_read_lock();
	task = rq->curr;

and rely on task being _a_ task_struct, even though it might not be the
self-same task we thought we had.

So yes, not an option and I was stitching together two half remembered
situations to create utter nonsense.
