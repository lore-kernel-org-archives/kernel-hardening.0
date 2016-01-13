Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160113111152.GB23370@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
	<1452518355-4606-8-git-send-email-ard.biesheuvel@linaro.org>
	<20160112181336.GF4858@leverpostej>
	<CAKv+Gu-TS7w=AVBceGhsQkQzVCv+u7Gh6ojftwW1iaE+d0yrYw@mail.gmail.com>
	<CAKv+Gu86oVvGb75S2x-44ct4sdQt4zT-3HbPqMJo_X+Cm3EPVQ@mail.gmail.com>
	<20160113111152.GB23370@leverpostej>
Date: Wed, 13 Jan 2016 12:14:01 +0100
Message-ID: <CAKv+Gu9X2rN8gTu5DE8c-mTUNZeEHSB5bxj5oC82HeiTzRoufQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 07/21] arm64: move kernel image to base of vmalloc area
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 13 January 2016 at 12:11, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Jan 13, 2016 at 10:58:55AM +0100, Ard Biesheuvel wrote:
>> On 13 January 2016 at 09:39, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > On 12 January 2016 at 19:14, Mark Rutland <mark.rutland@arm.com> wrote:
>> >> On Mon, Jan 11, 2016 at 02:19:00PM +0100, Ard Biesheuvel wrote:
>> >>> @@ -438,12 +442,29 @@ static void __init map_kernel(pgd_t *pgd)
>> >>>       map_kernel_chunk(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC);
>> >>>       map_kernel_chunk(pgd, _data, _end, PAGE_KERNEL);
>> >>>
>> >>> -     /*
>> >>> -      * The fixmap falls in a separate pgd to the kernel, and doesn't live
>> >>> -      * in the carveout for the swapper_pg_dir. We can simply re-use the
>> >>> -      * existing dir for the fixmap.
>> >>> -      */
>> >>> -     set_pgd(pgd_offset_raw(pgd, FIXADDR_START), *pgd_offset_k(FIXADDR_START));
>> >>> +     if (pgd_index(FIXADDR_START) != pgd_index((u64)_end)) {
>> >>
>> >> To match the style of early_fixmap_init, and given we already mapped the
>> >> kernel image, this could be:
>> >>
>> >>         if (pgd_none(pgd_offset_raw(pgd, FIXADDR_START))) {
>> >>
>> >> Which also serves as a run-time check that the pgd entry really was
>> >> clear.
>> >>
>> >
>> > Yes, that looks better. I will steal that :-)
>> >
>>
>> OK, that doesn't work. pgd_none() is hardcoded to 'false' when running
>> with fewer than 4 pgtable levels, and so we always hit the BUG() here.
>
> Ah, sorry.
>
> We could also check CONFIG_PGTABLE_LEVELS > 3 check, as with
> fixmap_init, perhaps?
>

I'm using this now:

if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {

which I think is appropriate, since we don't expect to share any top
level entry, folded or not.

-- 
Ard.
