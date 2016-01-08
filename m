Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160108152738.GG16432@e104818-lin.cambridge.arm.com>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
	<20160108152738.GG16432@e104818-lin.cambridge.arm.com>
Date: Fri, 8 Jan 2016 16:30:20 +0100
Message-ID: <CAKv+Gu8dJQN98h9PrCFDyRa59UauDuxHCFPBrVyxrFG+f_No0g@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 8 January 2016 at 16:27, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
>> +static void __init enforce_memory_limit(void)
>> +{
>> +     const phys_addr_t kbase = round_down(__pa(_text), MIN_KIMG_ALIGN);
>> +     u64 to_remove = memblock_phys_mem_size() - memory_limit;
>> +     phys_addr_t max_addr = 0;
>> +     struct memblock_region *r;
>> +
>> +     if (memory_limit == (phys_addr_t)ULLONG_MAX)
>> +             return;
>> +
>> +     /*
>> +      * The kernel may be high up in physical memory, so try to apply the
>> +      * limit below the kernel first, and only let the generic handling
>> +      * take over if it turns out we haven't clipped enough memory yet.
>> +      */
>> +     for_each_memblock(memory, r) {
>> +             if (r->base + r->size > kbase) {
>> +                     u64 rem = min(to_remove, kbase - r->base);
>> +
>> +                     max_addr = r->base + rem;
>> +                     to_remove -= rem;
>> +                     break;
>> +             }
>> +             if (to_remove <= r->size) {
>> +                     max_addr = r->base + to_remove;
>> +                     to_remove = 0;
>> +                     break;
>> +             }
>> +             to_remove -= r->size;
>> +     }
>> +
>> +     memblock_remove(0, max_addr);
>> +
>> +     if (to_remove)
>> +             memblock_enforce_memory_limit(memory_limit);
>> +}
>
> IIUC, this is changing the user expectations a bit. There are people
> using the mem= limit to hijack some top of the RAM for other needs
> (though they could do it in a saner way like changing the DT memory
> nodes). Your patch first tries to remove the memory below the kernel
> image and only remove the top if additional limitation is necessary.
>
> Can you not remove memory from the top and block the limit if it goes
> below the end of the kernel image, with some warning that memory limit
> was not entirely fulfilled?
>

I'm in the middle of rewriting this code from scratch. The general idea is

static void __init clip_mem_range(u64 min, u64 max);

/*
* Clip memory in order of preference:
* - above the kernel and above 4 GB
* - between 4 GB and the start of the kernel
* - below 4 GB
* Note that tho
*/
clip_mem_range(max(sz_4g, PAGE_ALIGN(__pa(_end))), ULLONG_MAX);
clip_mem_range(sz_4g, round_down(__pa(_text), MIN_KIMG_ALIGN));
clip_mem_range(0, sz_4g);

where clip_mem_range() iterates over the memblocks to remove memory
between min and max iff min < max and the limit has not been met yet.
