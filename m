Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160108112622.GA3097@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-12-git-send-email-ard.biesheuvel@linaro.org>
	<20160108112622.GA3097@leverpostej>
Date: Fri, 8 Jan 2016 12:34:18 +0100
Message-ID: <CAKv+Gu8uGyoxvR0zYyrXiGTg5F4kO9p3Jbr-EZAozHYQS68T8w@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 11/13] arm64: allow kernel Image to be loaded anywhere
 in physical memory
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 8 January 2016 at 12:26, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Wed, Dec 30, 2015 at 04:26:10PM +0100, Ard Biesheuvel wrote:
>> This relaxes the kernel Image placement requirements, so that it
>> may be placed at any 2 MB aligned offset in physical memory.
>>
>> This is accomplished by ignoring PHYS_OFFSET when installing
>> memblocks, and accounting for the apparent virtual offset of
>> the kernel Image. As a result, virtual address references
>> below PAGE_OFFSET are correctly mapped onto physical references
>> into the kernel Image regardless of where it sits in memory.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  Documentation/arm64/booting.txt  | 12 ++---
>>  arch/arm64/include/asm/boot.h    |  5 ++
>>  arch/arm64/include/asm/kvm_mmu.h |  2 +-
>>  arch/arm64/include/asm/memory.h  | 15 +++---
>>  arch/arm64/kernel/head.S         |  6 ++-
>>  arch/arm64/mm/init.c             | 50 +++++++++++++++++++-
>>  arch/arm64/mm/mmu.c              | 12 +++++
>>  7 files changed, 86 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
>> index 701d39d3171a..03e02ebc1b0c 100644
>> --- a/Documentation/arm64/booting.txt
>> +++ b/Documentation/arm64/booting.txt
>> @@ -117,14 +117,14 @@ Header notes:
>>    depending on selected features, and is effectively unbound.
>>
>>  The Image must be placed text_offset bytes from a 2MB aligned base
>> -address near the start of usable system RAM and called there. Memory
>> -below that base address is currently unusable by Linux, and therefore it
>> -is strongly recommended that this location is the start of system RAM.
>> -The region between the 2 MB aligned base address and the start of the
>> -image has no special significance to the kernel, and may be used for
>> -other purposes.
>> +address anywhere in usable system RAM and called there. The region
>> +between the 2 MB aligned base address and the start of the image has no
>> +special significance to the kernel, and may be used for other purposes.
>>  At least image_size bytes from the start of the image must be free for
>>  use by the kernel.
>> +NOTE: versions prior to v4.6 cannot make use of memory below the
>> +physical offset of the Image so it is recommended that the Image be
>> +placed as close as possible to the start of system RAM.
>
> We need a head flag for this so that a bootloader can determine whether
> it can load the kernel anywhere or should try for the lowest possible
> address. Then the note would describe the recommended behaviour in the
> absence of the flag.
>
> The flag for KASLR isn't sufficient as you can build without it (and it
> only tells the bootloader that the kernel accepts entropy in x1).
>

Indeed, I will change that.

> We might also want to consider if we need to determine whether or not
> the bootloader actually provided entropy, (and if we need a more general
> handshake between the bootlaoder and kernel to determine that kind of
> thing).
>

Yes, that is interesting. We should also think about how to handle
'nokaslr' if it appears on the command line, since in the !EFI case,
we will be way too late to parse this, and a capable kernel will
already be running from a randomized offset. That means it is the
bootloader's responsibility to ensure that the presence of 'nokaslr'
and the entropy in x1 are consistent with each other.

>>  Any memory described to the kernel (even that below the start of the
>>  image) which is not marked as reserved from the kernel (e.g., with a
>> diff --git a/arch/arm64/include/asm/boot.h b/arch/arm64/include/asm/boot.h
>> index 81151b67b26b..984cb0fa61ce 100644
>> --- a/arch/arm64/include/asm/boot.h
>> +++ b/arch/arm64/include/asm/boot.h
>> @@ -11,4 +11,9 @@
>>  #define MIN_FDT_ALIGN                8
>>  #define MAX_FDT_SIZE         SZ_2M
>>
>> +/*
>> + * arm64 requires the kernel image to be 2 MB aligned
>
> Nit: The image is TEXT_OFFSET from that 2M-aligned base.
> s/image/mapping/?
>
> [...]
>

Yep. I hate TEXT_OFFSET, did I mention that?

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
>
> We might want ot preserve the low 4GB if possible, for those IOMMU-less
> devices which can only do 32-bit addressing.
>
> Otherwise this looks good to me!
>

Thanks,
Ard.
