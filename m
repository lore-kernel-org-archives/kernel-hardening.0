Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161004124156.GE2040@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com> <20161004124156.GE2040@pc.thejh.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 4 Oct 2016 11:51:09 -0700
Message-ID: <CAGXu5j+6dBJ17UK-=DH7Vz-8qJSPnQ=CCyq4mjAiUJHEd9HfnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for HARDENED_ATOMIC
To: Jann Horn <jann@thejh.net>
Cc: Dave Hansen <dave.hansen@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 4, 2016 at 5:41 AM, Jann Horn <jann@thejh.net> wrote:
> On Mon, Oct 03, 2016 at 12:27:01PM -0700, Dave Hansen wrote:
>> On 10/02/2016 11:41 PM, Elena Reshetova wrote:
>> >  static __always_inline void atomic_add(int i, atomic_t *v)
>> >  {
>> > -   asm volatile(LOCK_PREFIX "addl %1,%0"
>> > +   asm volatile(LOCK_PREFIX "addl %1,%0\n"
>> > +
>> > +#ifdef CONFIG_HARDENED_ATOMIC
>> > +                "jno 0f\n"
>> > +                LOCK_PREFIX "subl %1,%0\n"
>> > +                "int $4\n0:\n"
>> > +                _ASM_EXTABLE(0b, 0b)
>> > +#endif
>> > +
>> > +                : "+m" (v->counter)
>> > +                : "ir" (i));
>> > +}
>>
>> Rather than doing all this assembly and exception stuff, could we just do:
>>
>> static __always_inline void atomic_add(int i, atomic_t *v)
>> {
>>       if (atomic_add_unless(v, a, INT_MAX))
>>               BUG_ON_OVERFLOW_FOO()...
>> }
>>
>> That way, there's also no transient state where somebody can have
>> observed the overflow before it is fixed up.  Granted, this
>> cmpxchg-based operation _is_ more expensive than the fast-path locked addl.
>
> I think we need some numbers, so I copypasted a bunch of kernel code together
> so that I can benchmark this stuff in userspace without having a full kernel
> implementation of refcounting protection. My code is at the bottom of
> the mail - please test this on other CPUs, these are just numbers from my
> machine.
>
> The following numbers are from tests on a
> "Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz" CPU.
>
> First, I'm testing the single-threaded (uncontended) case:
>
> $ gcc -o atomic_user_test atomic_user_test.c -std=gnu99 -Wall -pthread -ggdb
> $ time ./atomic_user_test 1 1 1000000000 # single-threaded, no protection
> real    0m9.281s
> user    0m9.251s
> sys     0m0.004s
> $ time ./atomic_user_test 1 2 1000000000 # single-threaded, racy protection
> real    0m9.385s
> user    0m9.365s
> sys     0m0.003s
> $ time ./atomic_user_test 1 3 1000000000 # single-threaded, cmpxchg protection
> real    0m12.399s
> user    0m12.375s
> sys     0m0.000s
>
> The cmpxchg protection is something like 30% slower than the racy one. The
> cmpxchg protection needs something like 12.4ns per operation, or around 45
> cycles per operation. (Well, probably actually a bit less, considering that
> the loop also costs some time.) My guess is that this wouldn't be noticeable.
>
> Now, I'm testing the multi-threaded (contended) case, with two threads that
> only try to increment the same counter over and over again - so this is a
> pretty extreme worst-case microbenchmark:
>
> $ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
> real    0m9.550s
> user    0m18.988s
> sys     0m0.000s
> $ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protection
> real    0m9.249s
> user    0m18.430s
> sys     0m0.004s
> $ time ./atomic_user_test 2 3 1000000000 # multi-threaded, cmpxchg protection
> real    1m47.331s
> user    3m34.390s
> sys     0m0.024s
>
> Here, the cmpxchg-protected counter is around 11 times as slow as the
> unprotected counter, with around 107ns per average increment. That's around
> 380 cycles per increment.
>
> I guess we probably don't care all that much about the few extra cycles in
> the uncontended case.
> So I think the big question now is how important the performance of the
> high-contention case is.

What I find quite exciting about this benchmark is that they're the
absolute worst-case: the process is doing nothing but atomic
operations (which won't be the case for general kernel workloads) and
the fact that the racy protection is basically lost in the noise is
great.

Now, cmpxchg looks bad here, but is, again, in the worst-case
environment. I'll be curious to see kernel workloads with it, though.

As for the "racy" part, I'm not too concerned about it. (I would like
it not to race, but given a choice, I would rather this protection was
enabled by default.) As-is, with two threads fighting for a race, it
can be hard to win the race, and even if there's a success, one will
still Oops, so it's still better than what we have today: no
notification of failure and an exploitable condition. (And, frankly,
the act of racing and _failing_ is both threads Oopsing, so performing
a racy would be extremely noisy on systems where they're not already
set to panic on the first Oops...)

Just to make sure I'm not imagining the wrong thing, the race looks like this:

CPU0  CPU1
inc->0
            inc->1
dec->0
Oops
            carry on

-Kees

-- 
Kees Cook
Nexus Security
