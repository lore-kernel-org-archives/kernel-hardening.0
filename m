Date: Thu, 26 Oct 2017 10:11:16 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171025231116.GC12341@eros>
References: <CAHmME9rZE0oSOq6KecY1pTMsJa4dK2sCyuMRZbFjnamZkHXViA@mail.gmail.com>
 <20171025222727.GB12341@eros>
 <CAHmME9rdfLNZD1bhvA4Xh=kdEN-7-FSV8aU0y_ky3Ts2zoPd4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rdfLNZD1bhvA4Xh=kdEN-7-FSV8aU0y_ky3Ts2zoPd4Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 12:59:08AM +0200, Jason A. Donenfeld wrote:
> On Thu, Oct 26, 2017 at 12:27 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > How good is unlikely()?
> 
> It places that branch way at the bottom of the function so that it's
> less likely to pollute the icache.
> 
> > It doesn't _feel_ right adding a check on every call to printk just to
> > check for a condition that was only true for the briefest time when the
> > kernel booted. But if unlikely() is good then I guess it doesn't hurt.
> >
> > I'm leaning towards the option 1, but then all those text books I read
> > are telling me to implement the simplest solution first then if we need
> > to go faster implement the more complex solution.
> >
> > This is a pretty airy fairy discussion now, but if you have an opinion
> > I'd love to hear it.
> 
> I don't think adding a single branch there really matters that much,
> considering how many random other branches there are all over the
> printk code. However, if you really want to optimize on the little
> bits, and sensibly don't want to go with the overcomplex
> workqueue-to-statickey thing, you could consider using a plain vanilla
> `bool has_gotten_random_ptr_secret` instead of using the atomic_t. The
> reason is that there's only ever one single writer, changing from a 0
> to a 1. Basically the only thing doing the atomic_t got you was a
> cache flush surrounding the read (and the write) so that assigning
> has_gotten_random_ptr_secret=true would take effect _immediately_.
> However, since you might not necessarily about that, going with a bool
> instead will save you an expensive cache flush, while potentially
> being a microsecond out of date the first time it's used. Seems like
> an okay trade off to me. (That kind of cache latency, also, is a few
> orders of magnitude better than using a work queue for the statickey
> stuff.)

Awesome. Patch to follow.

thanks,
Tobin.
