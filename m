Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110225031.GA26751@worktop>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net> <20161110225031.GA26751@worktop>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 10 Nov 2016 15:07:37 -0800
Message-ID: <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 2:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 10, 2016 at 09:40:46PM +0100, Peter Zijlstra wrote:
>> On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
>> >  static __always_inline void atomic_add(int i, atomic_t *v)
>> >  {
>> > +   asm volatile(LOCK_PREFIX "addl %1,%0\n"
>> > +
>> > +#ifdef CONFIG_HARDENED_ATOMIC
>> > +                "jno 0f\n"
>> > +                LOCK_PREFIX "subl %1,%0\n"
>> > +                "int $4\n0:\n"
>> > +                _ASM_EXTABLE(0b, 0b)
>>
>>
>> This is unreadable gunk.
>
> Worse, this is fundamentally racy and therefore not a proper atomic at
> all.

The race was discussed earlier as well (and some of that should
already have been covered in the commit message), but basically this
is a race in the overflow protection, so it's not operationally a
problem. The process that caused the overflow still gets killed, and
if the system isn't already set up to panic on oops, this becomes a
resource leak instead of an exploitable condition.

> The only way to do this is a cmpxchg loop and not issue the result on
> overflow. Of course, that would completely suck performance wise, but
> having a non atomic atomic blows more.

There was some work to examine this performance impact, and it didn't
look terrible, but this race-on-overflow isn't viewed as a meaningful
risk in the refcount situation.

-Kees

-- 
Kees Cook
Nexus Security
