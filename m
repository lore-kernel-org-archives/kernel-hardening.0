MIME-Version: 1.0
In-Reply-To: <20170712224726.GA10559@leverpostej>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org> <20170712224726.GA10559@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 13 Jul 2017 07:51:22 +0100
Message-ID: <CAKv+Gu_=LVVCe29aaubPrN7Y9sP8N+DLi5dEdpJ38T7Ns61N5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 00/10] arm64: allow virtually mapped stacks to be enabled
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@fedoraproject.org>, Will Deacon <will.deacon@arm.com>, Dave Martin <dave.martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 12 July 2017 at 23:47, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Ard,
>
> On Wed, Jul 12, 2017 at 03:44:13PM +0100, Ard Biesheuvel wrote:
>> This is a fairly quick'n'dirty attempt at enabling virtually mapped
>> stacks for arm64, after learning from Mark yesterday that progress
>> had more or less stalled on that front.
>
> Thanks for putting this together. If nothing else, this work needed a
> good kick.
>
> I had some rought comments on this, but in the process of wiring those
> up, I ended up writing an alternative [1] by cobblnig together prior
> attempts. Apologies for the NIH.
>

No worries. I deliberately refrained from any polishing of the code
because I was expecting debate not acks.

>> Since having actual patches to poke at is infinitely better than having
>> abstract discussions about how to approach it, I threw some code together
>> that:
>> 1. frees up sp_el0 by promoting register x18 to 'current' pointer while in
>>    the kernel; flames welcome :-) (#7)
>> 2. preparatory work to allow 1., i.e., to free up x18 and preserve/restore it
>>    correctly as a platform register (#2, #3, #4, #5, #6)
>
> From past experience [2], I know that Will is not a fan of reserving a
> GPR like this. There are a couple of other ways we can free up SP_EL0,
> though, so that isn't the end of the world.
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/518434.html
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/this-cpu-reg
>
>> 3. dump the entire task stack if regs->sp points elsewhere (#8)
>
> This sounds useful, but it's liable to fill a scrollbuffer and/or take a
> while to dump (especially with 64K stacks), so we might want a boot-time
> option to turn that on/off.
>
> Thanks,
> Mark.
