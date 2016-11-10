Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 10 Nov 2016 22:46:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161110214630.GC3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net>
 <CAGXu5j+s8vw7+B9XvA_Q3obSGwTS7t+rjG9Ncj6_yb9mweXrBg@mail.gmail.com>
 <20161110211622.GY3117@twins.programming.kicks-ass.net>
 <CAGXu5jJieT36Vy+pH=yZ9xFvuFMeJNWiK8dKKZ1=8CbCx-Sa8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJieT36Vy+pH=yZ9xFvuFMeJNWiK8dKKZ1=8CbCx-Sa8w@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 01:32:50PM -0800, Kees Cook wrote:
> > Also, I hate how #ifdef CONFIG_HARDENED_ATOMIC is sprinkled all over, it
> > makes a huge trainwreck of that file.
> 
> I guess the question was "prefer copy/pasting" vs "sprinkled ifdef". I
> tend to opt for reducing copy/paste, but this is just a code
> organization issue. Likely, then, would be to have two separate
> implementations in different .c files and have the Makefile select the
> desired version.

No, no .c files, this stuff wants to be inline, esp. the unannotated
versions, those typically are a single instruction.

And you don't need to copy/paste, just: #define atomic_wrap_t atomic_t
and use the 'normal' functions.

> > Ideally there'd be only a single #ifdef CONFIG_HARNDED_ATOMIC.
> >
> > I'm also not sure about atomic*_wrap() as an interface, these functions
> > already have far too long names. We could simply overload the existing
> > functions and select based off the argument type.
> 
> There was a concern over catching type errors when building without
> CONFIG_HARDENED_ATOMIC. Again, this is just a code organization issue
> -- I think whatever people prefer is fine. In theory, 0-day will
> quickly catch the corner cases, but I'd love it if the types couldn't
> get mixed up.
> 
> Out of curiosity, how would the arg-type selection look? Are there
> other examples of this already in the kernel?

See static_branch_likely() / static_branch_unlikely().
