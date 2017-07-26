References: <20170725114901.31403-1-ard.biesheuvel@linaro.org>
 <CAGXu5jLNB5dmA0o=n_nn=4NRu3LjuNf5PGRopATuRiq0aJ1ECA@mail.gmail.com>
 <CAKv+Gu8L1M6iO-pELrVvouxgh+t1qjzD4fOu3Fw+LeiWMZWzpA@mail.gmail.com>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <c89c560c-c8b5-2079-6e19-0b85d9658ca3@huawei.com>
Date: Wed, 26 Jul 2017 09:47:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8L1M6iO-pELrVvouxgh+t1qjzD4fOu3Fw+LeiWMZWzpA@mail.gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH untested] arm64: kernel: implement fast refcount
 checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard and Kees,

Yes, i have been working on this for several days, but i think Ard's 
patch is better than mine in some ways.
So i'll help reviewing the patch and try to give some suggestions.
Never mind:)

on 2017/7/26 1:20, Ard Biesheuvel wrote:
> On 25 July 2017 at 18:13, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jul 25, 2017 at 4:49 AM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> Hi all,
>>>
>>> I had a stab at porting the fast refcount checks to arm64. It is slightly
>>> less straight-forward than x86 given that we need to support both LSE and
>>> LL/SC, and fallback to the latter if running a kernel built with support
>>> for the former on hardware that does not support it.
>>>
>>> It is build tested with and without LSE support, and boots fine on non-LSE
>>> hardware in both cases.
>> Ah! Very cool. Hopefully you and Li can compare notes; I think they've
>> been working on an implementation too.
>>
> I wasn't aware of that.
>
>>> Suggestions welcome as to how to test and/or benchmark this,
>> I'll post a patch for LKDTM that I've been using. It's more
>> comprehensive than the existing ATOMIC checks (which predated the
>> refcount-only protection).
>>
> OK. One thing I couldn't figure out: is refcount_t signed or not? The
> saturate tests set the initial value to UINT_MAX - 1, but this is
> interpreted as a negative value and so the refcount manipulations that
> are expected to succeed also fail in my case.

-- 
Best Regards
Li Kun
