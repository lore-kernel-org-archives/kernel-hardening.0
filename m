Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160114185701.GA28181@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
	<20160112181336.GF4858@leverpostej>
	<CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
	<20160113135109.GJ23370@leverpostej>
	<20160114185701.GA28181@leverpostej>
Date: Fri, 15 Jan 2016 10:54:26 +0100
Message-ID: <CAKv+Gu-mPcXBTpENRaM5qo0nV_z93ZKw=5o5xVLNMU7QfiRCHQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Stuart Yoder <stuart.yoder@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 January 2016 at 19:57, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Jan 13, 2016 at 01:51:10PM +0000, Mark Rutland wrote:
>> On Wed, Jan 13, 2016 at 09:39:41AM +0100, Ard Biesheuvel wrote:
>> > On 12 January 2016 at 19:14, Mark Rutland <mark.rutland@arm.com> wrote:
>> > > On Mon, Jan 11, 2016 at 02:19:00PM +0100, Ard Biesheuvel wrote:
>> > >>  void __init kasan_init(void)
>> > >>  {
>> > >> +     u64 kimg_shadow_start, kimg_shadow_end;
>> > >>       struct memblock_region *reg;
>> > >>
>> > >> +     kimg_shadow_start = round_down((u64)kasan_mem_to_shadow(_text),
>> > >> +                                    SWAPPER_BLOCK_SIZE);
>> > >> +     kimg_shadow_end = round_up((u64)kasan_mem_to_shadow(_end),
>> > >> +                                SWAPPER_BLOCK_SIZE);
>> > >
>> > > This rounding looks suspect to me, given it's applied to the shadow
>> > > addresses rather than the kimage addresses. That's roughly equivalent to
>> > > kasan_mem_to_shadow(round_up(_end, 8 * SWAPPER_BLOCK_SIZE).
>> > >
>> > > I don't think we need any rounding for the kimage addresses. The image
>> > > end is page-granular (and the fine-grained mapping will reflect that).
>> > > Any accesses between _end and roud_up(_end, SWAPPER_BLOCK_SIZE) would be
>> > > bugs (and would most likely fault) regardless of KASAN.
>> > >
>> > > Or am I just being thick here?
>> > >
>> >
>> > Well, the problem here is that vmemmap_populate() is used as a
>> > surrogate vmalloc() since that is not available yet, and
>> > vmemmap_populate() allocates in SWAPPER_BLOCK_SIZE granularity.
>
> From a look at the git history, and a chat with Catalin, it sounds like
> the SWAPPER_BLOCK_SIZE granularity is a historical artifact. It happened
> to be easier to implement it that way at some point in the past, but
> there's no reason the 4K/16K/64K cases can't all be handled by the same
> code that would go down to PAGE_SIZE granularity, using sections if
> possible.
>
> I'll drop that on the TODO list.
>

OK

>> > If I remove the rounding, I get false positive kasan errors which I
>> > have not quite diagnosed yet, but are probably due to the fact that
>> > the rounding performed by vmemmap_populate() goes in the wrong
>> > direction.
>
> As far as I can see, it implicitly rounds the base down and end up to
> SWAPPER_BLOCK_SIZE granularity.
>
> I can see that it might map too much memory, but I can't see why that
> should trigger KASAN failures. Regardless of what was mapped KASAN
> should stick to the region it cares about, and everything else should
> stay out of that.
>
> When do you see the failures, and are they in any way consistent?
>
> Do you have an example to hand?
>

For some reason, this issue has evaporated, i.e., I can no longer
reproduce it on my WIP v4 branch.
So I will remove the rounding.

Thanks,
Ard.


>> I'll also take a peek.
>
> I haven't managed to trigger KASAN failures with the rounding removed.
> I'm using 4K pages, and running under KVM tool (no EFI, so the memory
> map is a contiguous block).
>
> What does your memory map look like?
>
> Thanks,
> Mark.
