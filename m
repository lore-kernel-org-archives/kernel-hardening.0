Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161110233004.GQ3568@worktop.programming.kicks-ass.net>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110204046.GW3117@twins.programming.kicks-ass.net> <20161110225031.GA26751@worktop>
 <CAGXu5j+yy8Y=_bDhsTgEugJnN5=u8_XMSOAnqJBab-1+9v8+CA@mail.gmail.com> <20161110233004.GQ3568@worktop.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 11 Nov 2016 10:00:27 -0800
Message-ID: <CAGXu5j++ZZDmgYqzvx104Bs2iQK+7V_Xn2VgTR7eoCwS2JR0tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Will Deacon <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 3:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Nov 10, 2016 at 03:07:37PM -0800, Kees Cook wrote:
>> , but basically this
>> is a race in the overflow protection, so it's not operationally a
>> problem. The process that caused the overflow still gets killed, and
>> if the system isn't already set up to panic on oops, this becomes a
>> resource leak instead of an exploitable condition.
>
> Now is this harmless? If you have two increments racing like:

Adding some annotation for values and the BUG:

>
    INT_MAX
>           inc
    INT_MIN
>           jno 1 // overflow
>
>                           inc
    INT_MIN+1
>                           jno 1 // !overflow
>
>           dec
    INT_MIN
>         1:              1:
    BUG
>
> The second thread will still affect your wrap and not BUG.

Agreed: the first thread will BUG and the second thread is still halfway to 0.

On systems that panic on BUG, things are protected. For the rest of
the systems, an alternative to "dec" on overflow is to sub (more than)
NR_CPUS, to keep the saturation below the overflow level. This means
that it is still detected (BUG) by at least 1 thread, and cannot reach
0 (to trigger the flaw) on all other threads, even if they all lose
the race.

Some further details on examining the race is here:

https://bugs.chromium.org/p/project-zero/issues/detail?id=856#c2

To me, this seems better than taking the cmpxchg performance hit.

-Kees

-- 
Kees Cook
Nexus Security
