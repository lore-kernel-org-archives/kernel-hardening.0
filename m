Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8DFB@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
 <1476959131-6153-13-git-send-email-elena.reshetova@intel.com>
 <20161026050631.GZ19531@linaro.org> <CAEXv5_h5ezZwXcC-sTND_WxPwjNx3Yz-0M40WzqdC_gF-cP20g@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BF8DFB@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 26 Oct 2016 13:51:05 -0700
Message-ID: <CAGXu5j+uUH9fRbFSkVGeAc1Z6+oLHPLLFFvkU6KDC6nuDX-8Lw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: David Windsor <dwindsor@gmail.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 26, 2016 at 4:15 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>>> +static __always_inline int __atomic_add_unless_wrap(atomic_wrap_t *v,
>>> +                                                 int a, int u)
>>> +{
>>> +     int c, old, new;
>>> +     c = atomic_read_wrap(v);
>>> +     for (;;) {
>>> +             if (unlikely(c == (u)))
>>> +                     break;
>>> +
>>> +             asm volatile("addl %2,%0\n"
>>> +
>>> +#ifdef CONFIG_HARDENED_ATOMIC
>>> +                          "jno 0f\n"
>>> +                          "subl %2,%0\n"
>>> +                          "int $4\n0:\n"
>>> +                          _ASM_EXTABLE(0b, 0b)
>>> +#endif
>>
>> Is this a mistake? We don't need a check here.
>
>>Yes, this appears to be a mistake.
>
> Clear copy paste mistake. Fixed now. Thanks again!

What was the mistake here?

-Kees

-- 
Kees Cook
Nexus Security
