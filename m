From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5jLgCGKfyjP=yW4A_E6vCCtuiKdLeb1f80K6cyxpEA2Y=Q@mail.gmail.com>
References: <1492698980-19510-1-git-send-email-mpe@ellerman.id.au> <1492995750.2418.4.camel@gmail.com> <8737cxswuk.fsf@concordia.ellerman.id.au> <CAGXu5jLgCGKfyjP=yW4A_E6vCCtuiKdLeb1f80K6cyxpEA2Y=Q@mail.gmail.com>
Date: Tue, 25 Apr 2017 08:44:18 +1000
Message-ID: <87a8752zp9.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH v2] powerpc/mm: Add support for runtime configuration of ASLR limits
To: Kees Cook <keescook@chromium.org>
Cc: Balbir Singh <bsingharora@gmail.com>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, Bhupesh Sharma <bhsharma@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:
> On Mon, Apr 24, 2017 at 7:29 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Balbir Singh <bsingharora@gmail.com> writes:
>>>> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
>>>> index a5d9ef59debe..6141cfff634e 100644
>>>> --- a/arch/powerpc/mm/mmap.c
>>>> +++ b/arch/powerpc/mm/mmap.c
>>>> @@ -59,13 +59,14 @@ static inline int mmap_is_legacy(void)
>>>>
>>>>  unsigned long arch_mmap_rnd(void)
>>>>  {
>>>> -    unsigned long rnd;
>>>> +    unsigned long shift, rnd;
>>>>
>>>> -    /* 8MB for 32bit, 1GB for 64bit */
>>>> +    shift = mmap_rnd_bits;
>>>> +#ifdef CONFIG_COMPAT
>>>>      if (is_32bit_task())
>>>> -            rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
>>>> -    else
>>>> -            rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
>>>> +            shift = mmap_rnd_compat_bits;
>>>> +#endif
>>>> +    rnd = get_random_long() % (1 << shift);
>>>
>>> Nitpick, 1 should be 1UL?
>
> Nice catch!
>
>> No, shift can only be 29 at most IIRC?
>
> The largest value in the kconfigs is 33?

Yeah you're right, for the 4K page kernel it can be 33.

Will fix.

cheers
