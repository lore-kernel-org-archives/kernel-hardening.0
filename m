Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160115112306.GC3262@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
	<20160112181336.GF4858@leverpostej>
	<CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
	<20160113135109.GJ23370@leverpostej>
	<20160114185701.GA28181@leverpostej>
	<CAKv+Gu-mPcXBTpENRaM5qo0nV_z93ZKw=5o5xVLNMU7QfiRCHQ@mail.gmail.com>
	<20160115112306.GC3262@leverpostej>
Date: Wed, 27 Jan 2016 15:31:37 +0100
Message-ID: <CAKv+Gu9rC6vkyc9MDVFfR7E6sRA0F+goZZymtCd9jxn8ybVk2A@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Stuart Yoder <stuart.yoder@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 15 January 2016 at 12:23, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Jan 15, 2016 at 10:54:26AM +0100, Ard Biesheuvel wrote:
>> On 14 January 2016 at 19:57, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Wed, Jan 13, 2016 at 01:51:10PM +0000, Mark Rutland wrote:
>> >> On Wed, Jan 13, 2016 at 09:39:41AM +0100, Ard Biesheuvel wrote:
>> >> > If I remove the rounding, I get false positive kasan errors which I
>> >> > have not quite diagnosed yet, but are probably due to the fact that
>> >> > the rounding performed by vmemmap_populate() goes in the wrong
>> >> > direction.
>> >
>> > As far as I can see, it implicitly rounds the base down and end up to
>> > SWAPPER_BLOCK_SIZE granularity.
>> >
>> > I can see that it might map too much memory, but I can't see why that
>> > should trigger KASAN failures. Regardless of what was mapped KASAN
>> > should stick to the region it cares about, and everything else should
>> > stay out of that.
>> >
>> > When do you see the failures, and are they in any way consistent?
>> >
>> > Do you have an example to hand?
>> >
>>
>> For some reason, this issue has evaporated, i.e., I can no longer
>> reproduce it on my WIP v4 branch.
>> So I will remove the rounding.
>
> Ok.
>
> I'll let you know if I stumble across anything that looks like a
> potential cause of the KASAN failures, and I'll try to give v4 a go at
> some point soon.
>

OK, I managed to track this down (I think). The issue here is that,
while vmemmap_populate() does the right thing wrt the start and end
boundaries, populate_zero_shadow() will map the adjoining regions down
to page granularity, replacing vmemmap_populate()'s PMD block mappings
with PMD table mappings. So I need to put back the rounding (I removed
it in v4)

Thanks,
Ard.
