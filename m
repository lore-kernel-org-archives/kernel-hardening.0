Date: Tue, 25 Apr 2017 11:05:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170425090558.vi4ihaqedlmph7va@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast>
 <58FDF8C4.5120.17D092B7@pageexec.freemail.hu>
 <20170424133323.cf3xyd3mmwp6ixaz@hirez.programming.kicks-ass.net>
 <58FE1687.5511.1844D4FC@pageexec.freemail.hu>
 <CAGXu5jK5s0KBAfwHPhobiSCn6b0QA4Wb=w=eJG4KyukwbdHTzg@mail.gmail.com>
 <20170424220128.j7nnhuohqdqbiki7@hirez.programming.kicks-ass.net>
 <CAGXu5j+tbPr04Jiv4yjJJO3h89fDxy-iWAeuoDZ2N+XDY58umw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+tbPr04Jiv4yjJJO3h89fDxy-iWAeuoDZ2N+XDY58umw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Kees Cook <keescook@chromium.org>
Cc: PaX Team <pageexec@freemail.hu>, LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 03:37:32PM -0700, Kees Cook wrote:
> On Mon, Apr 24, 2017 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> > It does not. It just got free'ed. Nothing will stop the free from
> > happening (or already having happened).
> 
> Well, yes, but that's kind of my point. Detecting inc-from-0 is "too
> late" to offer a protection. It offers notification of a bug, rather
> than stopping an exploit from happening.

Well, your setup (panic_on_warn et al) would have it panic the box. That
will effectively stop the exploit by virtue of stopping everything.

And warn/bug/panic etc.. are I think a better option that silently
letting it happen.
