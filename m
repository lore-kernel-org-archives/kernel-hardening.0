Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151210184211.GH26759@e104818-lin.cambridge.arm.com>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
	<20151210000005.GA99337@davidb.org>
	<CAGXu5jLLXK3N6pbZOie5uj276x=dtc_tuTz312rnhF8yrmxHYQ@mail.gmail.com>
	<20151210002651.GC99337@davidb.org>
	<CAGXu5jJYRCZ1-frx3+pUPabm3XRFFU8T4gsCQaSc73aA4Q--3g@mail.gmail.com>
	<CAB9W1A0veUktvSrdwMSaN=kqypGdE6_RLXFGkD79scfkPPevpw@mail.gmail.com>
	<CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
	<20151210184211.GH26759@e104818-lin.cambridge.arm.com>
Date: Thu, 10 Dec 2015 15:52:16 -0800
Message-ID: <CAGXu5j+LHBaZ12+zsiK+tt3R83+uTHKO_og3AJRhWP+tHDxUOA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Self Introduction
To: David Brown <david.brown@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 10:42 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, Dec 10, 2015 at 09:49:13AM -0800, Kees Cook wrote:
>> On Thu, Dec 10, 2015 at 9:14 AM, Stephen Smalley
>> <stephen.smalley@gmail.com> wrote:
>> > On Wed, Dec 9, 2015 at 7:41 PM, Kees Cook <keescook@chromium.org> wrote:
>> >> On Wed, Dec 9, 2015 at 4:26 PM, David Brown <david.brown@linaro.org> wrote:
>> >>> On Wed, Dec 09, 2015 at 04:14:20PM -0800, Kees Cook wrote:
>> >>>> I'd love to see CONFIG_CPU_SW_DOMAIN_PAN into the AOSP 3.18 android kernel
>> >>>> too.
>> >>>
>> >>> I'll put this on my list to investigate.  Sadly, it looks like there
>> >>> is a bit of a window of ARM CPUs where neither solution will work;
>> >>> Basically the pre V8.1 64-bit.
>> >>
>> >> The LPAE support for PAN emulation exists in grsecurity, if someone
>> >> wanted to look at how to extract it and add it to
>> >> CONFIG_CPU_SW_DOMAIN_PAN (or similar).
>> >
>> > Are you looking for this:
>> > http://marc.info/?l=linux-arm-kernel&m=144308911409429&w=2
>> >
>> > Haven't seen any follow up on it though...
>>
>> Ah yes! Thank you!
>>
>> https://patchwork.kernel.org/patch/7250401/
>> https://patchwork.kernel.org/patch/7250391/
>> https://patchwork.kernel.org/patch/7250421/
>> https://patchwork.kernel.org/patch/7250441/
>>
>> Catalin, where does this stand?
>
> I haven't done any further improvements to them, nor have I received any
> feedback. I'll rebase them against latest kernel if anyone else is
> willing to test. I had a plan to run some benchmarks and see how
> performance is affected (including the CPU_SW_DOMAIN_PAN) before pushing
> again for upstreaming but I haven't had the time.

David, getting back to something that might good to get your help
with: would you be able to test Catalin's LPAE TTBR0 PAN series on
real hardware? (Are you familiar with the LKDTM tests for this[1]?)

-Kees

[1] http://lwn.net/Articles/663531/ specifically ACCESS_USERSPACE and
EXEC_USERSPACE

-- 
Kees Cook
Chrome OS & Brillo Security
