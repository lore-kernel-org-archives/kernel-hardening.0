MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com> <1D62D311-DD73-43BD-9ED1-8B9450842B89@amacapital.net>
In-Reply-To: <1D62D311-DD73-43BD-9ED1-8B9450842B89@amacapital.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 14:03:13 -0800
Message-ID: <CAGXu5jL1Bx6_JfS9ei7dZA=9Hk4wBBQXRLtYPpqOAhRUoYDbuQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Elena Reshetova <elena.reshetova@intel.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 8, 2019 at 8:34 AM Andy Lutomirski <luto@amacapital.net> wrote:
> > On Feb 8, 2019, at 4:15 AM, Elena Reshetova <elena.reshetova@intel.com> wrote:
> > This feature should make considerably harder various
> > stack-based attacks that are based upon overflowing
> > a kernel stack into adjusted kernel stack with a
> > possibility to jump over a guard page.
> > Since the stack offset is randomized upon each
> > system call, it is very hard for attacker to reliably
> > land in any particular place on the adjusted stack.
> >
>
> I think we need a better justification. With VLAs gone, it should be statically impossible to overflow past a guard page.

I do agree, that the stack is a much more well-defended area right
now, and that the urgency for this feature is lower, but if it's easy
to implement, I think we should do it.

With VLAs universally gone, we can't get unbounded allocations that
lead to both linear overflows and indexed overflows. But this doesn't
mean a counter or index can't still go crazy -- it just means the
expected stack layout will no longer be attached to it.

With VMAP_STACK we stop linear overflows of the stack since we'll hit
a guard page. However, this does not stop indexed overflows where we
can jump the guard page. It is harder to control an indexed overflow
vs a linear overflow, but it's still possible. Adding more variability
to this, I think, has value in making attacks less reliable.

Also, I'd note that while this is currently an x86-only
implementation, it's not hard to extend to other architectures that
don't already have VMAP_STACK. (And while it is the default, not all
x86 builds have CONFIG_VMAP_STACK=y, though why you'd turn that off
and turn this on, I'm not sure.)

-- 
Kees Cook
