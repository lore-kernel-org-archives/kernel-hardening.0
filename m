MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu89_deP8L=hy==6uv-szdGSBO7v9t+vKHT8rKUjARdc-w@mail.gmail.com>
References: <20170731192251.12491-1-ard.biesheuvel@linaro.org>
 <20170823145811.GA30753@arm.com> <CAKv+Gu89_deP8L=hy==6uv-szdGSBO7v9t+vKHT8rKUjARdc-w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 23 Aug 2017 09:48:03 -0700
Message-ID: <CAGXu5jLXFA4=X5mC9ph9dZ0ZJaVkGXd2p1Vh8jH_EE15kVL6Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4] arm64: kernel: implement fast refcount checking
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, "Likun (Hw)" <hw.likun@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 23, 2017 at 8:51 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 23 August 2017 at 15:58, Will Deacon <will.deacon@arm.com> wrote:
>> On Mon, Jul 31, 2017 at 08:22:51PM +0100, Ard Biesheuvel wrote:
>>> +static __always_inline void refcount_add(int i, refcount_t *r)
>>> +{
>>> +     __refcount_add_lt(i, &r->refs);
>>> +}
>>> +
>>> +static __always_inline void refcount_inc(refcount_t *r)
>>> +{
>>> +     __refcount_add_lt(1, &r->refs);
>>> +}
>>> +
>>> +static __always_inline void refcount_dec(refcount_t *r)
>>> +{
>>> +     __refcount_sub_le(1, &r->refs);
>>> +}
>>> +
>>> +static __always_inline __must_check bool refcount_sub_and_test(unsigned int i,
>>> +                                                            refcount_t *r)
>>> +{
>>> +     return __refcount_sub_lt(i, &r->refs) == 0;
>>> +}
>>> +
>>> +static __always_inline __must_check bool refcount_dec_and_test(refcount_t *r)
>>> +{
>>> +     return __refcount_sub_lt(1, &r->refs) == 0;
>>> +}
>>
>> Nit, but we can just follow the lib/refcount.c implementation here.
>
> Yes, and the same applies to Kees's version for x86, I suppose. We can
> do that as a separate fix.

Sorry, I didn't follow context here. What are these comments referring
to? The dec_and_test implementation?

>>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>>> index c7c7088097be..07bd026ec71d 100644
>>> --- a/arch/arm64/kernel/traps.c
>>> +++ b/arch/arm64/kernel/traps.c
>>> @@ -758,8 +758,37 @@ int __init early_brk64(unsigned long addr, unsigned int esr,
>>>       return bug_handler(regs, esr) != DBG_HOOK_HANDLED;
>>>  }
>>>
>>> +static int refcount_overflow_handler(struct pt_regs *regs, unsigned int esr)
>>> +{
>>> +     bool zero = regs->pstate & PSR_Z_BIT;
>>> +
>>> +     /* First unconditionally saturate the refcount. */
>>> +     *(int *)regs->regs[16] = INT_MIN / 2;
>>
>> Does this work even when racing against a concurrent refcount operation
>> that doesn't have a pre-check? I can't figure out how something like a
>> sub_lt operation on a saturated counter couldn't reset the value to zero.
>
> I hope Kees can clarify this, but as I understand it, this value was
> chosen right in the middle of the negative space so it would take many
> operations to get it to a sane value again, reducing the likelihood
> that a situation is created that may be exploited.

We can't protect against over-subtraction, since a legitimate
dec-to-zero can't be distinguished from an early dec-to-zero (the
resource will always get freed and potentially abused via
use-after-free). If you mean the case of racing many increments, it
would require INT_MIN / 2 threads perfectly performing an increment
simultaneously with another thread performing a dec_and_test(), which
is unrealistic in the face of saturation happening within a couple
instructions on all of those INT_MIN / 2 threads. So, while
theoretically possible, it is not a real-world condition. As I see it,
this is the trade off of these implementations vs REFCOUNT_FULL, which
has perfect saturation but high performance cost.

-Kees

-- 
Kees Cook
Pixel Security
