Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLhUdNUws2oNek1PPOJbP-zt=02RK9hQOsiqfU5Uy9zdg@mail.gmail.com>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451489172-17420-14-git-send-email-ard.biesheuvel@linaro.org>
	<CAGXu5jLhUdNUws2oNek1PPOJbP-zt=02RK9hQOsiqfU5Uy9zdg@mail.gmail.com>
Date: Wed, 6 Jan 2016 08:51:50 +0100
Message-ID: <CAKv+Gu8htmvBjSyP5eFgeeh2vMdeeq_ZkaRD+PL5tMScDcHWeA@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 13/13] arm64: efi: invoke EFI_RNG_PROTOCOL to supply
 KASLR randomness
To: Kees Cook <keescook@chromium.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 5 January 2016 at 20:53, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Dec 30, 2015 at 7:26 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> Since arm64 does not use a decompressor that supplies an execution
>> environment where it is feasible to some extent to provide a source of
>> randomness, the arm64 KASLR kernel depends on the bootloader to supply
>> some random bits in register x1 upon kernel entry.
>>
>> On UEFI systems, we can use the EFI_RNG_PROTOCOL, if supplied, to obtain
>> some random bits. At the same time, use it to randomize the offset of the
>> kernel Image in physical memory.
>
> This logic seems like it should be under the name
> CONFIG_RANDOMIZE_BASE and depend on UEFI? (Again, I'm just trying to
> keep naming conventions the same across architectures to avoid
> confusion.)
>

Indeed.


>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>  arch/arm64/kernel/efi-entry.S             |   7 +-
>>  drivers/firmware/efi/libstub/arm-stub.c   |   1 -
>>  drivers/firmware/efi/libstub/arm64-stub.c | 134 +++++++++++++++++---
>>  include/linux/efi.h                       |   5 +-
>>  4 files changed, 127 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
>> index f82036e02485..f41073dde7e0 100644
>> --- a/arch/arm64/kernel/efi-entry.S
>> +++ b/arch/arm64/kernel/efi-entry.S
>> @@ -110,7 +110,7 @@ ENTRY(entry)
>>  2:
>>         /* Jump to kernel entry point */
>>         mov     x0, x20
>> -       mov     x1, xzr
>> +       ldr     x1, efi_rnd
>>         mov     x2, xzr
>>         mov     x3, xzr
>>         br      x21
>> @@ -119,6 +119,9 @@ efi_load_fail:
>>         mov     x0, #EFI_LOAD_ERROR
>>         ldp     x29, x30, [sp], #32
>>         ret
>> +ENDPROC(entry)
>> +
>> +ENTRY(efi_rnd)
>> +       .quad   0, 0
>>
>>  entry_end:
>> -ENDPROC(entry)
>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> index 950c87f5d279..f580bcdfae4f 100644
>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> @@ -145,7 +145,6 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
>>         out->output_string(out, str);
>>  }
>>
>> -
>>  /*
>>   * This function handles the architcture specific differences between arm and
>>   * arm64 regarding where the kernel image must be loaded and any memory that
>> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
>> index 78dfbd34b6bf..4e5c306346b4 100644
>> --- a/drivers/firmware/efi/libstub/arm64-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
>> @@ -13,6 +13,68 @@
>>  #include <asm/efi.h>
>>  #include <asm/sections.h>
>>
>> +struct efi_rng_protocol_t {
>> +       efi_status_t (*get_info)(struct efi_rng_protocol_t *,
>> +                                unsigned long *,
>> +                                efi_guid_t *);
>> +       efi_status_t (*get_rng)(struct efi_rng_protocol_t *,
>> +                               efi_guid_t *,
>> +                               unsigned long,
>> +                               u8 *out);
>> +};
>> +
>> +extern struct {
>> +       u64     virt_seed;
>> +       u64     phys_seed;
>> +} efi_rnd;
>> +
>> +static int efi_get_random_bytes(efi_system_table_t *sys_table)
>> +{
>> +       efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
>> +       efi_status_t status;
>> +       struct efi_rng_protocol_t *rng;
>> +
>> +       status = sys_table->boottime->locate_protocol(&rng_proto, NULL,
>> +                                                     (void **)&rng);
>> +       if (status == EFI_NOT_FOUND) {
>> +               pr_efi(sys_table, "EFI_RNG_PROTOCOL unavailable, no randomness supplied\n");
>> +               return EFI_SUCCESS;
>> +       }
>> +
>> +       if (status != EFI_SUCCESS)
>> +               return status;
>> +
>> +       return rng->get_rng(rng, NULL, sizeof(efi_rnd), (u8 *)&efi_rnd);
>> +}
>> +
>> +static efi_status_t get_dram_top(efi_system_table_t *sys_table_arg, u64 *top)
>> +{
>> +       unsigned long map_size, desc_size;
>> +       efi_memory_desc_t *memory_map;
>> +       efi_status_t status;
>> +       int l;
>> +
>> +       status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
>> +                                   &desc_size, NULL, NULL);
>> +       if (status != EFI_SUCCESS)
>> +               return status;
>> +
>> +       for (l = 0; l < map_size; l += desc_size) {
>> +               efi_memory_desc_t *md = (void *)memory_map + l;
>> +
>> +               if (md->attribute & EFI_MEMORY_WB) {
>> +                       u64 phys_end = md->phys_addr +
>> +                                      md->num_pages * EFI_PAGE_SIZE;
>> +                       if (phys_end > *top)
>> +                               *top = phys_end;
>> +               }
>> +       }
>> +
>> +       efi_call_early(free_pool, memory_map);
>> +
>> +       return EFI_SUCCESS;
>> +}
>> +
>>  efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>>                                         unsigned long *image_addr,
>>                                         unsigned long *image_size,
>> @@ -27,6 +89,14 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>>         void *old_image_addr = (void *)*image_addr;
>>         unsigned long preferred_offset;
>>
>> +       if (IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL)) {
>> +               status = efi_get_random_bytes(sys_table_arg);
>> +               if (status != EFI_SUCCESS) {
>> +                       pr_efi_err(sys_table_arg, "efi_get_random_bytes() failed\n");
>> +                       return status;
>> +               }
>> +       }
>> +
>>         /*
>>          * The preferred offset of the kernel Image is TEXT_OFFSET bytes beyond
>>          * a 2 MB aligned base, which itself may be lower than dram_base, as
>> @@ -36,13 +106,42 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>>         if (preferred_offset < dram_base)
>>                 preferred_offset += SZ_2M;
>>
>> -       /* Relocate the image, if required. */
>>         kernel_size = _edata - _text;
>> -       if (*image_addr != preferred_offset) {
>> -               kernel_memsize = kernel_size + (_end - _edata);
>> +       kernel_memsize = kernel_size + (_end - _edata);
>> +
>> +       if (IS_ENABLED(CONFIG_ARM64_RELOCATABLE_KERNEL) && efi_rnd.phys_seed) {
>> +               /*
>> +                * If KASLR is enabled, and we have some randomness available,
>> +                * locate the kernel at a randomized offset in physical memory.
>> +                */
>> +               u64 dram_top = dram_base;
>> +
>> +               status = get_dram_top(sys_table_arg, &dram_top);
>> +               if (status != EFI_SUCCESS) {
>> +                       pr_efi_err(sys_table_arg, "get_dram_size() failed\n");
>> +                       return status;
>> +               }
>> +
>> +               kernel_memsize += SZ_2M;
>> +               nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
>> +                                   EFI_PAGE_SIZE;
>>
>>                 /*
>> -                * First, try a straight allocation at the preferred offset.
>> +                * Use the random seed to scale the size and add it to the DRAM
>> +                * base. Note that this may give suboptimal results on systems
>> +                * with discontiguous DRAM regions with large holes between them.
>> +                */
>> +               *reserve_addr = dram_base +
>> +                       ((dram_top - dram_base) >> 16) * (u16)efi_rnd.phys_seed;
>> +
>> +               status = efi_call_early(allocate_pages, EFI_ALLOCATE_MAX_ADDRESS,
>> +                                       EFI_LOADER_DATA, nr_pages,
>> +                                       (efi_physical_addr_t *)reserve_addr);
>> +
>> +               *image_addr = round_up(*reserve_addr, SZ_2M) + TEXT_OFFSET;
>> +       } else {
>> +               /*
>> +                * Else, try a straight allocation at the preferred offset.
>>                  * This will work around the issue where, if dram_base == 0x0,
>>                  * efi_low_alloc() refuses to allocate at 0x0 (to prevent the
>>                  * address of the allocation to be mistaken for a FAIL return
>> @@ -52,27 +151,30 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
>>                  * Mustang), we can still place the kernel at the address
>>                  * 'dram_base + TEXT_OFFSET'.
>>                  */
>> +               if (*image_addr == preferred_offset)
>> +                       return EFI_SUCCESS;
>> +
>>                 *image_addr = *reserve_addr = preferred_offset;
>>                 nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
>>                            EFI_PAGE_SIZE;
>>                 status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
>>                                         EFI_LOADER_DATA, nr_pages,
>>                                         (efi_physical_addr_t *)reserve_addr);
>> +       }
>> +
>> +       if (status != EFI_SUCCESS) {
>> +               kernel_memsize += TEXT_OFFSET;
>> +               status = efi_low_alloc(sys_table_arg, kernel_memsize,
>> +                                      SZ_2M, reserve_addr);
>> +
>>                 if (status != EFI_SUCCESS) {
>> -                       kernel_memsize += TEXT_OFFSET;
>> -                       status = efi_low_alloc(sys_table_arg, kernel_memsize,
>> -                                              SZ_2M, reserve_addr);
>> -
>> -                       if (status != EFI_SUCCESS) {
>> -                               pr_efi_err(sys_table_arg, "Failed to relocate kernel\n");
>> -                               return status;
>> -                       }
>> -                       *image_addr = *reserve_addr + TEXT_OFFSET;
>> +                       pr_efi_err(sys_table_arg, "Failed to relocate kernel\n");
>> +                       return status;
>>                 }
>> -               memcpy((void *)*image_addr, old_image_addr, kernel_size);
>> -               *reserve_size = kernel_memsize;
>> +               *image_addr = *reserve_addr + TEXT_OFFSET;
>>         }
>> -
>> +       memcpy((void *)*image_addr, old_image_addr, kernel_size);
>> +       *reserve_size = kernel_memsize;
>>
>>         return EFI_SUCCESS;
>>  }
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 569b5a866bb1..13783fdc9bdd 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -299,7 +299,7 @@ typedef struct {
>>         void *open_protocol_information;
>>         void *protocols_per_handle;
>>         void *locate_handle_buffer;
>> -       void *locate_protocol;
>> +       efi_status_t (*locate_protocol)(efi_guid_t *, void *, void **);
>>         void *install_multiple_protocol_interfaces;
>>         void *uninstall_multiple_protocol_interfaces;
>>         void *calculate_crc32;
>> @@ -599,6 +599,9 @@ void efi_native_runtime_setup(void);
>>  #define EFI_PROPERTIES_TABLE_GUID \
>>      EFI_GUID(  0x880aaca3, 0x4adc, 0x4a04, 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5 )
>>
>> +#define EFI_RNG_PROTOCOL_GUID \
>> +    EFI_GUID(  0x3152bca5, 0xeade, 0x433d, 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44 )
>> +
>>  typedef struct {
>>         efi_guid_t guid;
>>         u64 table;
>> --
>> 2.5.0
>>
>
>
>
> --
> Kees Cook
> Chrome OS & Brillo Security
