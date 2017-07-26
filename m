References: <20170725181536.21092-1-ard.biesheuvel@linaro.org>
 <0816933d-7e58-0773-1441-891823983ff9@huawei.com>
 <CAKv+Gu8djcgmovajhUUpniHwEVDupCWW3L__3JtqZ0GCM3=U2w@mail.gmail.com>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <34605822-8f95-f963-48c4-65d724eae0c7@huawei.com>
Date: Wed, 26 Jul 2017 17:21:38 +0800
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8djcgmovajhUUpniHwEVDupCWW3L__3JtqZ0GCM3=U2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v2] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>



在 2017/7/26 16:40, Ard Biesheuvel 写道:
> On 26 July 2017 at 05:11, Li Kun <hw.likun@huawei.com> wrote:
>> Hi Ard，
>>
>>
>> on 2017/7/26 2:15, Ard Biesheuvel wrote:
>>> +#define REFCOUNT_OP(op, asm_op, cond, l, clobber...)                   \
>>> +__LL_SC_INLINE int                                                     \
>>> +__LL_SC_PREFIX(__refcount_##op(int i, atomic_t *r))                    \
>>> +{                                                                      \
>>> +       unsigned long tmp;                                              \
>>> +       int result;                                                     \
>>> +                                                                       \
>>> +       asm volatile("// refcount_" #op "\n"                            \
>>> +"      prfm            pstl1strm, %2\n"                                \
>>> +"1:    ldxr            %w0, %2\n"                                      \
>>> +"      " #asm_op "     %w0, %w0, %w[i]\n"                              \
>>> +"      st" #l "xr      %w1, %w0, %2\n"                                 \
>>> +"      cbnz            %w1, 1b\n"                                      \
>>> +       REFCOUNT_CHECK(cond)                                            \
>>> +       : "=&r" (result), "=&r" (tmp), "+Q" (r->counter)                \
>>> +       : REFCOUNT_INPUTS(r) [i] "Ir" (i)                               \
>>> +       clobber);                                                       \
>>> +                                                                       \
>>> +       return result;                                                  \
>>> +}                                                                      \
>>> +__LL_SC_EXPORT(__refcount_##op);
>>> +
>>> +REFCOUNT_OP(add_lt, adds, mi,  , REFCOUNT_CLOBBERS);
>>> +REFCOUNT_OP(sub_lt_neg, adds, mi, l, REFCOUNT_CLOBBERS);
>>> +REFCOUNT_OP(sub_le_neg, adds, ls, l, REFCOUNT_CLOBBERS);
>>> +REFCOUNT_OP(sub_lt, subs, mi, l, REFCOUNT_CLOBBERS);
>>> +REFCOUNT_OP(sub_le, subs, ls, l, REFCOUNT_CLOBBERS);
>>> +
>> I'm not quite sure if we use b.lt to judge whether the result of adds is
>> less than zero is correct or not.
>> The b.lt means N!=V, take an extreme example, if we operate like below, the
>> b.lt will also be true.
>>
>> refcount_set(&ref_c,0x80000000);
>> refcount_dec_and_test(&ref_c);
>>
>> maybe we should use PL/NE/MI/EQ to judge the LT_ZERO or LE_ZERO condition ?
>>
> The lt/le is confusing here: the actual condition coded used are mi
> for negative and ls for negative or zero.
>
> I started out using lt and le, because it matches the x86 code, but I
> moved to mi and ls instead. (I don't think it makes sense to deviate
> from that just because the flags and predicates work a bit
> differently.)
>
> However, I see now that there is one instance of REFCOUNT_CHECK(lt)
> remaining (in refcount.h). That should mi as well.
Sorry for having  misunderstood your implementation.
If we want to catch the refcount_sub operate on negetive value(like -1 
to -2 ), i think b.ls can't achieve that.
I think (b.eq || b.mi ) may be better than b.ls for this case.

Best Regards,
Li Kun
>
> Thanks,
> Ard.

-- 
Best Regards
Li Kun
