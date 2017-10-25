Date: Wed, 25 Oct 2017 21:05:59 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171025100559.GH15832@eros>
References: <CAHmME9rZE0oSOq6KecY1pTMsJa4dK2sCyuMRZbFjnamZkHXViA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rZE0oSOq6KecY1pTMsJa4dK2sCyuMRZbFjnamZkHXViA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 25, 2017 at 06:00:21AM +0200, Jason A. Donenfeld wrote:
> On Wed, Oct 25, 2017 at 5:49 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > static_branch_disable(&no_ptr_secret) : Doesn't sleep, just atomic read
> > and set and maybe a WARN_ONCE.
> 
> Are you sure about that? I just looked myself, and though there is a
> !HAVE_JUMP_LABEL ifdef that does what you described, there's also a
> HAVE_JUMP_LABEL that takes a mutex, which sleeps:
> 
> static_branch_disable
>   static_key_disable
>     cpus_read_lock
>       percpu_down_read
>         percpu_down_read_preempt_disable
>           might_sleep

Hilarious, the actual function name is 'might_sleep' and I missed it. I
love being wrong, it means I'm learning. Thanks for taking the time to
point this out.

> > Now for the 'executes from process context' stuff.
> 
> Er, sorry, I meant to write non-process context in my original
> message, which is generally where you're worried about sleeping.

Tomorrow I'm going to re-read 'sleeping' sections from ldd3 and Love.

> > If the callback mechanism is utilized (i.e print before randomness is
> > ready) then the call back will be executed the next time the randomness
> > pool gets added to
> 
> So it sounds to me like this might be called in non-process context.
> Disaster. I realize the static_key thing was my idea in the original
> email, so sorry for leading you astray.

You bastard.

> But moving to do this in
> early_initcall wound up fixing other issues too, so all and all a net
> good in going this direction.

I wanted to know how to do this since Linus said 'boot time variable' in
one of the first comments on this topic. So I'm super glad you pointed
it out.

> Two options: you stick with static_branch, because it's cool and speed
> is fun, and work around all of the above with a call to queue_work so
> that static_branch_enable is called only from process context.
> 
> Or, you give up on static_key, because it's not actually super
> necessary, and instead just use an atomic, and reason that using `if
> (unlikely(!atomic_read(&whatever)))` is probably good enough. In this
> option, the code would be pretty much the same as v7, except you'd
> s/static_branch/atomic_t/, and change the helpers, etc. This is
> probably the more reasonable way.

I'm going to sleep, then re-reading these bits.

thanks Jason, appreciate your input big time.

Cheers,
Tobin.
