Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Feb 2016 17:31:47 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160213003147.GA12074@davidb.org>
References: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
 <CAKv+Gu8ArOYqxDGKb=Tv3NsiB2qWWCdD_zMx55m6+hEwLJR4CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8ArOYqxDGKb=Tv3NsiB2qWWCdD_zMx55m6+hEwLJR4CA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH] arm64: vdso: Mark vDSO code as
 read-only
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 11, 2016 at 03:19:20PM +0100, Ard Biesheuvel wrote:

>> diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
>> index 60c1db5..db7c0f2 100644
>> --- a/arch/arm64/kernel/vdso/vdso.S
>> +++ b/arch/arm64/kernel/vdso/vdso.S
>> @@ -24,6 +24,7 @@
>>         __PAGE_ALIGNED_DATA
>
>^^ You can get rid of this now as well

Can we?  The page is getting mapped to userspace, and if we didn't
page align it, we could leak kernel read-only data to every userspace
process.

David
