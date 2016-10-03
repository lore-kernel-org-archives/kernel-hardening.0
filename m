Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <57F2B105.9050400@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com> <57F2B105.9050400@intel.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 3 Oct 2016 18:49:01 -0400
Message-ID: <CAEXv5_jdQM0X1XNtxNVJi4Ftf8w4P4WN6sy_MK64=0Gmo8oWKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for HARDENED_ATOMIC
To: Dave Hansen <dave.hansen@intel.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 3, 2016 at 3:27 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 10/02/2016 11:41 PM, Elena Reshetova wrote:
>>  static __always_inline void atomic_add(int i, atomic_t *v)
>>  {
>> -     asm volatile(LOCK_PREFIX "addl %1,%0"
>> +     asm volatile(LOCK_PREFIX "addl %1,%0\n"
>> +
>> +#ifdef CONFIG_HARDENED_ATOMIC
>> +                  "jno 0f\n"
>> +                  LOCK_PREFIX "subl %1,%0\n"
>> +                  "int $4\n0:\n"
>> +                  _ASM_EXTABLE(0b, 0b)
>> +#endif
>> +
>> +                  : "+m" (v->counter)
>> +                  : "ir" (i));
>> +}
>
> Rather than doing all this assembly and exception stuff, could we just do:
>
> static __always_inline void atomic_add(int i, atomic_t *v)
> {
>         if (atomic_add_unless(v, a, INT_MAX))
>                 BUG_ON_OVERFLOW_FOO()...
> }
>
> That way, there's also no transient state where somebody can have
> observed the overflow before it is fixed up.  Granted, this
> cmpxchg-based operation _is_ more expensive than the fast-path locked addl.

I'm not opposed to this, as this would allow us to eliminate the race
on x86 and this doesn't really change how things work on a fundamental
level here.  The overflow detection mechanism essentially remains the
same: __atomic_add_unless still would use exception dispatching as the
means of signaling that an overflow has occurred:

static __always_inline int __atomic_add_unless(atomic_t *v, int a, int u)
{
    int c, old, new;
    c = atomic_read(v);
    for (;;) {
        if (unlikely(c == (u)))
            break;
        asm volatile("addl %2,%0\n"

 #ifdef CONFIG_HARDENED_ATOMIC
            "jno 0f\n"
            "subl %2,%0\n"
            "int $4\n0:\n"
            _ASM_EXTABLE(0b, 0b)
#endif
            : "=r" (new)
            : "0" (c), "ir" (a));
        old = atomic_cmpxchg((v), c, new);
        if (likely(old == c))
            break;
            c = old;
    }
    return c;
}

I'm unsure about the performance implications of cmpxchg, though, so I
agree with Kees: we should subject this feature (and this series as a
whole) to benchmarking.
