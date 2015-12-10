Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAB9W1A0veUktvSrdwMSaN=kqypGdE6_RLXFGkD79scfkPPevpw@mail.gmail.com>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
	<20151210000005.GA99337@davidb.org>
	<CAGXu5jLLXK3N6pbZOie5uj276x=dtc_tuTz312rnhF8yrmxHYQ@mail.gmail.com>
	<20151210002651.GC99337@davidb.org>
	<CAGXu5jJYRCZ1-frx3+pUPabm3XRFFU8T4gsCQaSc73aA4Q--3g@mail.gmail.com>
	<CAB9W1A0veUktvSrdwMSaN=kqypGdE6_RLXFGkD79scfkPPevpw@mail.gmail.com>
Date: Thu, 10 Dec 2015 09:49:13 -0800
Message-ID: <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 9:14 AM, Stephen Smalley
<stephen.smalley@gmail.com> wrote:
> On Wed, Dec 9, 2015 at 7:41 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Dec 9, 2015 at 4:26 PM, David Brown <david.brown@linaro.org> wrote:
>>> On Wed, Dec 09, 2015 at 04:14:20PM -0800, Kees Cook wrote:
>>>> I'd love to see CONFIG_CPU_SW_DOMAIN_PAN into the AOSP 3.18 android kernel
>>>> too.
>>>
>>> I'll put this on my list to investigate.  Sadly, it looks like there
>>> is a bit of a window of ARM CPUs where neither solution will work;
>>> Basically the pre V8.1 64-bit.
>>
>> The LPAE support for PAN emulation exists in grsecurity, if someone
>> wanted to look at how to extract it and add it to
>> CONFIG_CPU_SW_DOMAIN_PAN (or similar).
>
> Are you looking for this:
> http://marc.info/?l=linux-arm-kernel&m=144308911409429&w=2
>
> Haven't seen any follow up on it though...

Ah yes! Thank you!

https://patchwork.kernel.org/patch/7250401/
https://patchwork.kernel.org/patch/7250391/
https://patchwork.kernel.org/patch/7250421/
https://patchwork.kernel.org/patch/7250441/

Catalin, where does this stand? Also, what options do ARMv8 (not
ARMv8.1) devices have for PAN if they're running 64-bit?

The matrix for PAN seems to be:

ARMv7 32-bit non-LPAE: CONFIG_CPU_SW_DOMAIN_PAN
ARMv7 32-bit LPAE: Catalin's series (CPU_TTBR0_PAN)
ARMv8 32-bit: Catalin's series?
ARMv8 64-bit: ??
ARMv8.1: hardware PAN
x86 pre-late-Broadwell: nothing upstream (though UDEREF in PaX exists)
x86 Broadwell+: hardware PAN (SMAP)
powerpc: ??
MIPS: ??

Corrections appreciated. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
