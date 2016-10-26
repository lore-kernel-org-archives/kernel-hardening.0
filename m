Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_hkJVbN4QtYsMP7D2gcrOEOqMaCVoB-DiEKm65HEiwWZQ@mail.gmail.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-13-git-send-email-elena.reshetova@intel.com>
 <20161026050631.GZ19531@linaro.org> <CAEXv5_h5ezZwXcC-sTND_WxPwjNx3Yz-0M40WzqdC_gF-cP20g@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BF8DFB@IRSMSX102.ger.corp.intel.com>
 <CAGXu5j+uUH9fRbFSkVGeAc1Z6+oLHPLLFFvkU6KDC6nuDX-8Lw@mail.gmail.com> <CAEXv5_hkJVbN4QtYsMP7D2gcrOEOqMaCVoB-DiEKm65HEiwWZQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 26 Oct 2016 14:52:45 -0700
Message-ID: <CAGXu5jJPimDmQT62UkWxZ8CW4DKPF-wjurdLa4Jz=+U6Cak0WA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: David Windsor <dwindsor@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 2:48 PM, David Windsor <dwindsor@gmail.com> wrote:
> On Wed, Oct 26, 2016 at 4:51 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Oct 26, 2016 at 4:15 AM, Reshetova, Elena
>> <elena.reshetova@intel.com> wrote:
>>>>> +static __always_inline int __atomic_add_unless_wrap(atomic_wrap_t *v,
>>>>> +                                                 int a, int u)
>>>>> +{
>>>>> +     int c, old, new;
>>>>> +     c = atomic_read_wrap(v);
>>>>> +     for (;;) {
>>>>> +             if (unlikely(c == (u)))
>>>>> +                     break;
>>>>> +
>>>>> +             asm volatile("addl %2,%0\n"
>>>>> +
>>>>> +#ifdef CONFIG_HARDENED_ATOMIC
>>>>> +                          "jno 0f\n"
>>>>> +                          "subl %2,%0\n"
>>>>> +                          "int $4\n0:\n"
>>>>> +                          _ASM_EXTABLE(0b, 0b)
>>>>> +#endif
>>>>
>>>> Is this a mistake? We don't need a check here.
>>>
>>>>Yes, this appears to be a mistake.
>>>
>>> Clear copy paste mistake. Fixed now. Thanks again!
>>
>> What was the mistake here?
>>
>
> It's an function that allows wrapping to occur: overflow protection
> shouldn't happen here.

Oh! Yes, of course. My eyes missed the _wrap part. :)

-Kees

-- 
Kees Cook
Nexus Security
