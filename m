Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160107184644.GA14895@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-14-git-send-email-ard.biesheuvel@linaro.org>
	<20160107184644.GA14895@leverpostej>
Date: Thu, 7 Jan 2016 11:07:59 -0800
Message-ID: <CAGXu5jKpvw2omXsDNQjJEdRZurC6f0xp5WVNTA4+WSNnUC9Piw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 13/13] arm64: efi: invoke EFI_RNG_PROTOCOL to supply
 KASLR randomness
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, LKML <linux-kernel@vger.kernel.org>, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 7, 2016 at 10:46 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Ard,
>
> I had a go at testing this on Juno with a hacked-up PRNG, and while
> everything seems to work, I think we need to make the address selection
> more robust to sparse memory maps (which I believe they are going to be
> fairly common).
>
> Info dump below and suggestion below.
>
> Other than that, this looks really nice -- I'll do other review in a
> separate reply.
>
> On Wed, Dec 30, 2015 at 04:26:12PM +0100, Ard Biesheuvel wrote:
>> Since arm64 does not use a decompressor that supplies an execution
>> environment where it is feasible to some extent to provide a source of
>> randomness, the arm64 KASLR kernel depends on the bootloader to supply
>> some random bits in register x1 upon kernel entry.
>>
>> On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
>> some random bits. At the same time, use it to randomize the offset of the
>> kernel Image in physical memory.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/kernel/efi-entry.S             |   7 +-
>>  drivers/firmware/efi/libstub/arm-stub.c   |   1 -
>>  drivers/firmware/efi/libstub/arm64-stub.c | 134 +++++++++++++++++---
>>  include/linux/efi.h                       |   5 +-
>>  4 files changed, 127 insertions(+), 20 deletions(-)
>
> [...]
>
>> @@ -36,13 +106,42 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>>       if (preferred_offset < dram_base)
>>               preferred_offset += SZ_2M;
>>
>> -     /* Relocate the image, if required. */
>>       kernel_size = _edata - _text;
>> -     if (*image_addr != preferred_offset) {
>> -             kernel_memsize = kernel_size + (_end - _edata);
>> +     kernel_memsize = kernel_size + (_end - _edata);
>> +
>> +     if (IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL) && efi_rnd.phys_seed) {
>> +             /*
>> +              * If KASLR is enabled, and we have some randomness available,
>> +              * locate the kernel at a randomized offset in physical memory.
>> +              */
>> +             u64 dram_top = dram_base;
>> +
>> +             status = get_dram_top(sys_table_arg, &dram_top);
>> +             if (status != EFI_SUCCESS) {
>> +                     pr_efi_err(sys_table_arg, "get_dram_size() failed\n");
>> +                     return status;
>> +             }
>> +
>> +             kernel_memsize += SZ_2M;
>> +             nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
>> +                                 EFI_PAGE_SIZE;
>>
>>               /*
>> -              * First, try a straight allocation at the preferred offset.
>> +              * Use the random seed to scale the size and add it to the DRAM
>> +              * base. Note that this may give suboptimal results on systems
>> +              * with discontiguous DRAM regions with large holes between them.
>> +              */
>> +             *reserve_addr = dram_base +
>> +                     ((dram_top - dram_base) >> 16) * (u16)efi_rnd.phys_seed;
>
> I think that "suboptimal" is somewhat an understatement. Across 10
> consecutive runs I ended up getting the same address 7 times:
>
> EFI stub: Seed is 0x0a82016804fdc064
> EFI stub: KASLR reserve address is 0x0000000832c48000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x0a820168050c09b2
> EFI stub: KASLR reserve address is 0x00000000c59e0000
> EFI stub: Loading kernel to physical address 0x00000000c4e80000 *
>
> EFI stub: Seed is 0x0a8001680511c701
> EFI stub: KASLR reserve address is 0x00000007feb40000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x0a8001680094d2a2
> EFI stub: KASLR reserve address is 0x0000000895bd0000
> EFI stub: Loading kernel to physical address 0x0000000895080000 *
>
> EFI stub: Seed is 0x88820167ea986527
> EFI stub: KASLR reserve address is 0x00000000bc570000
> EFI stub: Loading kernel to physical address 0x00000000bb880000 *
>
> EFI stub: Seed is 0x0882116805029414
> EFI stub: KASLR reserve address is 0x00000005955a0000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x8a821168050104ab
> EFI stub: KASLR reserve address is 0x0000000639600000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x08820168050671c6
> EFI stub: KASLR reserve address is 0x00000005250f0000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x08821167ea67381f
> EFI stub: KASLR reserve address is 0x000000080e538000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> EFI stub: Seed is 0x0a801168050cb810
> EFI stub: KASLR reserve address is 0x00000006b20e0000
> EFI stub: Loading kernel to physical address 0x00000000fe080000
>
> My "Seed" here is just the CNTVCT value, with phys_seed being a xor of
> each of the 16 bit chunks (see diff at the end of hte email). Judging by
> the reserve addresses, I don't think the PRNG is to blame -- it's just
> that that gaps are large relative to the available RAM and swallow up
> much of the entropy, forcing a fall back to the same address.
>
> One thing we could do is to perform the address selection in the space
> of available memory, excluding gaps entirely. i.e. sum up the available
> memory, select the Nth available byte, then walk the memory map to
> convert that back to a real address. We might still choose an address
> that cannot be used (e.g. if the kernel would hang over the end of a
> region), but it'd be rarer than hitting a gap.

This is basically what I did on x86. I walk the memory map, counting
the number of positions that the kernel would fit into, then used the
random number to pick between position 0 and max position, then walked
the memory map again to spit out the memory address for that position.

Maybe this could be extracted into a lib for all architectures? Might
be more pain that it's worth, but at least there's no reason to write
it from scratch. See find_random_addr() and its helpers in
arch/x86/boot/compressed/aslr.c

-Kees

>
> Thoughts?
>
> For the above, my EFI memory map looks like:
>
> [    0.000000] Processing EFI memory map:
> [    0.000000]   0x000008000000-0x00000bffffff [Memory Mapped I/O  |RUN|  |  |  |  |  |   |  |  |  |UC]
> [    0.000000]   0x00001c170000-0x00001c170fff [Memory Mapped I/O  |RUN|  |  |  |  |  |   |  |  |  |UC]
> [    0.000000]   0x000080000000-0x00008000ffff [Loader Data        |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x000080010000-0x00009fdfffff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x00009fe00000-0x00009fe0ffff [Loader Data        |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x00009fe10000-0x0000dfffffff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0000e00f0000-0x0000fde49fff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0000fde4a000-0x0000febc9fff [Loader Data        |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0000febca000-0x0000febcdfff [ACPI Reclaim Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0000febce000-0x0000febcefff [ACPI Memory NVS    |   |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0000febcf000-0x0000febd0fff [ACPI Reclaim Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0000febd1000-0x0000feffffff [Boot Data          |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x000880000000-0x0009f98aafff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009f98ab000-0x0009f98acfff [Loader Data        |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009f98ad000-0x0009fa42afff [Loader Code        |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009fa42b000-0x0009faf6efff [Boot Code          |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009faf6f000-0x0009fafa9fff [Runtime Data       |RUN|  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0009fafaa000-0x0009ff767fff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009ff768000-0x0009ff768fff [Boot Data          |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009ff769000-0x0009ff76efff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009ff76f000-0x0009ffdddfff [Boot Data          |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009ffdde000-0x0009ffe72fff [Conventional Memory|   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009ffe73000-0x0009fff6dfff [Boot Code          |   |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000]   0x0009fff6e000-0x0009fffaefff [Runtime Code       |RUN|  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0009fffaf000-0x0009ffffefff [Runtime Data       |RUN|  |  |  |  |  |   |WB|WT|WC|UC]*
> [    0.000000]   0x0009fffff000-0x0009ffffffff [Boot Data          |   |  |  |  |  |  |   |WB|WT|WC|UC]
>
> I've included my local hacks below in case they are useful.
>
> Thanks,
> Mark.
>
> ---->8----
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index 27a1a92..00c6640 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -30,6 +30,34 @@ extern struct {
>
>  extern bool kaslr;
>
> +static void log_hex(efi_system_table_t *sys_table_arg, unsigned long val)
> +{
> +       const char hex[16] = "0123456789abcdef";
> +       char *strp, str[] = "0x0000000000000000";
> +       strp = str + 18;
> +
> +       do {
> +               *(--strp) = hex[val & 0xf];
> +       } while (val >>= 4);
> +
> +       efi_printk(sys_table_arg, str);
> +}
> +
> +static void dodgy_get_random_bytes(efi_system_table_t *sys_table)
> +{
> +       u64 seed;
> +       pr_efi(sys_table, "using UNSAFE NON-RANDOM number generator\n");
> +
> +       asm volatile("mrs %0, cntvct_el0\n" : "=r" (seed));
> +
> +       pr_efi(sys_table, "Seed is ");
> +       log_hex(sys_table, seed);
> +       efi_printk(sys_table, "\n");
> +
> +       efi_rnd.virt_seed = seed;
> +       efi_rnd.phys_seed = seed ^ (seed >> 16) ^ (seed >> 32) ^ (seed >> 48);
> +}
> +
>  static int efi_get_random_bytes(efi_system_table_t *sys_table)
>  {
>         efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> @@ -40,6 +68,7 @@ static int efi_get_random_bytes(efi_system_table_t *sys_table)
>                                                       (void **)&rng);
>         if (status == EFI_NOT_FOUND) {
>                 pr_efi(sys_table, "EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
> +               dodgy_get_random_bytes(sys_table);
>                 return EFI_SUCCESS;
>         }
>
> @@ -77,6 +106,17 @@ static efi_status_t get_dram_top(efi_system_table_t *sys_table_arg, u64 *top)
>         return EFI_SUCCESS;
>  }
>
> +static void log_kernel_address(efi_system_table_t *sys_table_arg,
> +                              unsigned long addr, unsigned long kaslr_addr)
> +{
> +       pr_efi(sys_table_arg, "KASLR reserve address is ");
> +       log_hex(sys_table_arg, kaslr_addr);
> +       efi_printk(sys_table_arg, "\n");
> +       pr_efi(sys_table_arg, "Loading kernel to physical address ");
> +       log_hex(sys_table_arg, addr);
> +       efi_printk(sys_table_arg, "\n");
> +}
> +
>  efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>                                         unsigned long *image_addr,
>                                         unsigned long *image_size,
> @@ -90,6 +130,7 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>         unsigned long nr_pages;
>         void *old_image_addr = (void *)*image_addr;
>         unsigned long preferred_offset;
> +       unsigned long kaslr_address = 0;
>
>         if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
>                 if (kaslr) {
> @@ -137,8 +178,9 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>                  * base. Note that this may give suboptimal results on systems
>                  * with discontiguous DRAM regions with large holes between them.
>                  */
> -               *reserve_addr = dram_base +
> +               kaslr_address = dram_base +
>                         ((dram_top - dram_base) >> 16) * (u16)efi_rnd.phys_seed;
> +               *reserve_addr = kaslr_address;
>
>                 status = efi_call_early(allocate_pages, EFI_ALLOCATE_MAX_ADDRESS,
>                                         EFI_LOADER_DATA, nr_pages,
> @@ -179,6 +221,9 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>                 }
>                 *image_addr = *reserve_addr + TEXT_OFFSET;
>         }
> +
> +       log_kernel_address(sys_table_arg, *image_addr, kaslr_address);
> +
>         memcpy((void *)*image_addr, old_image_addr, kernel_size);
>         *reserve_size = kernel_memsize;
>
>



-- 
Kees Cook
Chrome OS & Brillo Security
