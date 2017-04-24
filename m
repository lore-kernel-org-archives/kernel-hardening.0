MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <8737cxswuk.fsf@concordia.ellerman.id.au>
References: <1492698980-19510-1-git-send-email-mpe@ellerman.id.au>
 <1492995750.2418.4.camel@gmail.com> <8737cxswuk.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Apr 2017 10:56:04 -0700
Message-ID: <CAGXu5jLgCGKfyjP=yW4A_E6vCCtuiKdLeb1f80K6cyxpEA2Y=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2] powerpc/mm: Add support for
 runtime configuration of ASLR limits
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Balbir Singh <bsingharora@gmail.com>, "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>, Bhupesh Sharma <bhsharma@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 7:29 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Balbir Singh <bsingharora@gmail.com> writes:
>
>> On Fri, 2017-04-21 at 00:36 +1000, Michael Ellerman wrote:
>>> Add powerpc support for mmap_rnd_bits and mmap_rnd_compat_bits, which are two
>>> sysctls that allow a user to configure the number of bits of randomness used for
>>> ASLR.
> ...
>>
>> Could we please suggest that this should not be sent to stable or back-ported
>> as the 128T default is new?
>
> I'm not sure I follow. I didn't tag it for stable. Do you mean we should
> explicitly mark it as not-for-stable?
>
> If someone sends it to stable@vger I'll be pinged before it goes in and
> nak it, if someone wants to backport it (incorrectly) to their own tree
> then good luck to them :)
>
>>> diff --git a/arch/powerpc/mm/mmap.c b/arch/powerpc/mm/mmap.c
>>> index a5d9ef59debe..6141cfff634e 100644
>>> --- a/arch/powerpc/mm/mmap.c
>>> +++ b/arch/powerpc/mm/mmap.c
>>> @@ -59,13 +59,14 @@ static inline int mmap_is_legacy(void)
>>>
>>>  unsigned long arch_mmap_rnd(void)
>>>  {
>>> -    unsigned long rnd;
>>> +    unsigned long shift, rnd;
>>>
>>> -    /* 8MB for 32bit, 1GB for 64bit */
>>> +    shift = mmap_rnd_bits;
>>> +#ifdef CONFIG_COMPAT
>>>      if (is_32bit_task())
>>> -            rnd = get_random_long() % (1<<(23-PAGE_SHIFT));
>>> -    else
>>> -            rnd = get_random_long() % (1UL<<(30-PAGE_SHIFT));
>>> +            shift = mmap_rnd_compat_bits;
>>> +#endif
>>> +    rnd = get_random_long() % (1 << shift);
>>
>> Nitpick, 1 should be 1UL?

Nice catch!

> No, shift can only be 29 at most IIRC?

The largest value in the kconfigs is 33?

> But it's a bit fragile, so I'll change it.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
