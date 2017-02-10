MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170209102703.GB6500@twins.programming.kicks-ass.net>
References: <20170207083405.GV6500@twins.programming.kicks-ass.net>
 <20170207111011.GB28790@leverpostej> <20170207123630.GR6515@twins.programming.kicks-ass.net>
 <20170207135020.GA26173@leverpostej> <20170207150737.GM25813@worktop.programming.kicks-ass.net>
 <20170207160300.GB26173@leverpostej> <20170207173036.GS6515@twins.programming.kicks-ass.net>
 <20170207175542.GC26173@leverpostej> <20170208091250.GT6515@twins.programming.kicks-ass.net>
 <CAGXu5j+vSECyQgF2a5UWe1-FOMNFyZTLkM0o30Z7KOm=-EKuGQ@mail.gmail.com> <20170209102703.GB6500@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 10 Feb 2017 15:39:19 -0800
Message-ID: <CAGXu5jKdxqOOEixhgUrzLDZ7GHF0gQQLShwXkjvC_VJUCXHp0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 4/4] refcount: Report failures
 through CHECK_DATA_CORRUPTION
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 9, 2017 at 2:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Feb 08, 2017 at 01:20:26PM -0800, Kees Cook wrote:
>
>> Ooooh, that is intense. And the trampolines (EX_REG_HANDLERs) are all
>> just there to catch whatever register gcc decides to stuff the value
>> into? *cover face* Sure, okay. :)
>
> Right, they shouldn't be big functions, but barring whole program LTO
> there's just no knowing which are unused.
>
>> I wonder how many existing WARN callsites could be repurposed to use this?
>
> At the very least all WARN/BUG instances with trivial @format argument
> that are inlined I think. For example, things like:
>
> static inline some_function()
> {
>         /* ... */
>         WARN(cond, "blah blah blah\n");
>         /* ... */
> }
>
> where the format has no arguments. Here we can out-of-line the printk()
> stuff, which, as is the purpose here, shrinks the size of the inline.

Unless there is some other unholy macros trick, I think we'd need a
separate "WARN_CONST" or something macro to do this (i.e.
WARN_CONST(const, const_str) instead of WARN(cond, fmt, ...)), since
detecting a single-item vararg in a macro is very weird/impossible to
do. Hrmm.

-Kees

-- 
Kees Cook
Pixel Security
