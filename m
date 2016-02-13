Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160213003147.GA12074@davidb.org>
References: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
	<CAKv+Gu8ArOYqxDGKb=Tv3NsiB2qWWCdD_zMx55m6+hEwLJR4CA@mail.gmail.com>
	<20160213003147.GA12074@davidb.org>
Date: Sat, 13 Feb 2016 10:00:56 +0100
Message-ID: <CAKv+Gu-5OdN7C_SvDytsoSn2QFkVZmonv2ffjpiuEXJA8tc0GA@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] arm64: vdso: Mark vDSO code as read-only
To: David Brown <david.brown@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 February 2016 at 01:31, David Brown <david.brown@linaro.org> wrote:
> On Thu, Feb 11, 2016 at 03:19:20PM +0100, Ard Biesheuvel wrote:
>
>>> diff --git a/arch/arm64/kernel/vdso/vdso.S
>>> b/arch/arm64/kernel/vdso/vdso.S
>>> index 60c1db5..db7c0f2 100644
>>> --- a/arch/arm64/kernel/vdso/vdso.S
>>> +++ b/arch/arm64/kernel/vdso/vdso.S
>>> @@ -24,6 +24,7 @@
>>>         __PAGE_ALIGNED_DATA
>>
>>
>> ^^ You can get rid of this now as well
>
>
> Can we?  The page is getting mapped to userspace, and if we didn't
> page align it, we could leak kernel read-only data to every userspace
> process.
>

That's what the .balign is for. __PAGE_ALIGNED_DATA only sets the
section, and you're overriding that right after.
