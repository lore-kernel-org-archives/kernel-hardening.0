References: <20170731120144.14214-1-ard.biesheuvel@linaro.org>
 <a0b6690d-039e-04ed-9847-b4521935375f@huawei.com>
 <CAKv+Gu9nQf=+HcN0c3Uy3YjDqnh0Xci3N-LqyAVw-gjRPRWmXw@mail.gmail.com>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <e1fa5c49-fb8d-f7c1-8530-562a28d8910c@huawei.com>
Date: Tue, 1 Aug 2017 09:41:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9nQf=+HcN0c3Uy3YjDqnh0Xci3N-LqyAVw-gjRPRWmXw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v3] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>



在 2017/7/31 21:59, Ard Biesheuvel 写道:
> On 31 July 2017 at 14:17, Li Kun <hw.likun@huawei.com> wrote:
>>
>> 在 2017/7/31 20:01, Ard Biesheuvel 写道:
>>> +static __always_inline __must_check bool refcount_add_not_zero(unsigned
>>> int i,
>>> +                                                              refcount_t
>>> *r)
>>> +{
>>> +       unsigned long tmp;
>>> +       int result;
>>> +
>>> +       asm volatile("// refcount_add_not_zero \n"
>>> +"      prfm            pstl1strm, %2\n"
>>> +"1:    ldxr            %w[val], %2\n"
>>> +"      cbz             %w[val], 2f\n"
>>> +"      adds            %w[val], %w[val], %w[i]\n"
>>> +"      stxr            %w1, %w[val], %2\n"
>>> +"      cbnz            %w1, 1b\n"
>>> +       REFCOUNT_POST_CHECK_NEG
>>> +"2:"
>>> +       : [val] "=&r" (result), "=&r" (tmp), "+Q" (r->refs.counter)
>>> +       : REFCOUNT_INPUTS(&r->refs) [i] "Ir" (i)
>>> +       : REFCOUNT_CLOBBERS);
>>> +
>>> +       return result != 0;
>>> +}
>>> +
>> Could we use "cas" here instead of ll/sc ?
>>
> I don't see how, to be honest.
>
> Compare and swap only performs the store if the expected value is in
> the memory location. In this case, we don't know the old value, we
> only know we need to do something special if it is 0.
I think you are right:)
I thought wrongly, we could get the old value only after the 'cas' has 
excuted successfully.
Thanks a lot.

-- 
Best Regards
Li Kun
