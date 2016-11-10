Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110211622.GY3117@twins.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net> <CAGXu5j+s8vw7+B9XvA_Q3obSGwTS7t+rjG9Ncj6_yb9mweXrBg@mail.gmail.com>
 <20161110211622.GY3117@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Nov 2016 13:32:50 -0800
Message-ID: <CAGXu5jJieT36Vy+pH=yZ9xFvuFMeJNWiK8dKKZ1=8CbCx-Sa8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 1:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 10, 2016 at 01:04:20PM -0800, Kees Cook wrote:
>> On Thu, Nov 10, 2016 at 12:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
>> >>  static __always_inline void atomic_add(int i, atomic_t *v)
>> >>  {
>> >> +     asm volatile(LOCK_PREFIX "addl %1,%0\n"
>> >> +
>> >> +#ifdef CONFIG_HARDENED_ATOMIC
>> >> +                  "jno 0f\n"
>> >> +                  LOCK_PREFIX "subl %1,%0\n"
>> >> +                  "int $4\n0:\n"
>> >> +                  _ASM_EXTABLE(0b, 0b)
>> >
>> >
>> > This is unreadable gunk.
>> >
>> >> +#endif
>> >> +
>> >>                    : "+m" (v->counter)
>> >>                    : "ir" (i));
>> >>  }
>>
>> How would you suggest it be made readable? Or rather, what don't you
>> like about it?
>
> Try and find the label the jno jumps to.. I had to try 3 times.
>
> Also, I hate how #ifdef CONFIG_HARDENED_ATOMIC is sprinkled all over, it
> makes a huge trainwreck of that file.

I guess the question was "prefer copy/pasting" vs "sprinkled ifdef". I
tend to opt for reducing copy/paste, but this is just a code
organization issue. Likely, then, would be to have two separate
implementations in different .c files and have the Makefile select the
desired version.

> Ideally there'd be only a single #ifdef CONFIG_HARNDED_ATOMIC.
>
> I'm also not sure about atomic*_wrap() as an interface, these functions
> already have far too long names. We could simply overload the existing
> functions and select based off the argument type.

There was a concern over catching type errors when building without
CONFIG_HARDENED_ATOMIC. Again, this is just a code organization issue
-- I think whatever people prefer is fine. In theory, 0-day will
quickly catch the corner cases, but I'd love it if the types couldn't
get mixed up.

Out of curiosity, how would the arg-type selection look? Are there
other examples of this already in the kernel?

-Kees

-- 
Kees Cook
Nexus Security
