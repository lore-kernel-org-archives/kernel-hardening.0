Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1453828249-14467-21-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
	<1453828249-14467-21-git-send-email-ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 15:52:48 -0800
Message-ID: <CAGXu5j+0GYHht3CM62gL60W-jOWV99zoHxo9Z8Y4KamHOwnjZg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 20/22] efi: stub: add implementation of efi_random_alloc()
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, LKML <linux-kernel@vger.kernel.org>, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Laura Abbott <labbott@fedoraproject.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 26, 2016 at 9:10 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> This implements efi_random_alloc(), which allocates a chunk of memory of
> a certain size at a certain alignment, and uses the random_seed argument
> it receives to randomize the address of the allocation.
>
> This is implemented by iterating over the UEFI memory map, counting the
> number of suitable slots (aligned offsets) within each region, and picking
> a random number between 0 and 'number of slots - 1' to select the slot,
> This should guarantee that each possible offset is chosen equally likely.
>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

(When a third arch implements kASLR, we probably want to merge this
and the x86 logic into some kind of reusable code...)

-Kees

> ---
>  drivers/firmware/efi/libstub/efistub.h |   4 +
>  drivers/firmware/efi/libstub/random.c  | 100 ++++++++++++++++++++
>  2 files changed, 104 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 206b7252b9d1..5ed3d3f38166 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -46,4 +46,8 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>  efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table,
>                                   unsigned long size, u8 *out);
>
> +efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
> +                             unsigned long size, unsigned long align,
> +                             unsigned long *addr, unsigned long random_seed);
> +
>  #endif
> diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
> index 97941ee5954f..b98346350230 100644
> --- a/drivers/firmware/efi/libstub/random.c
> +++ b/drivers/firmware/efi/libstub/random.c
> @@ -33,3 +33,103 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
>
>         return rng->get_rng(rng, NULL, size, out);
>  }
> +
> +/*
> + * Return the number of slots covered by this entry, i.e., the number of
> + * addresses it covers that are suitably aligned and supply enough room
> + * for the allocation.
> + */
> +static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
> +                                        unsigned long size,
> +                                        unsigned long align)
> +{
> +       u64 start, end;
> +
> +       if (md->type != EFI_CONVENTIONAL_MEMORY)
> +               return 0;
> +
> +       start = round_up(md->phys_addr, align);
> +       end = round_down(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - size,
> +                        align);
> +
> +       if (start > end)
> +               return 0;
> +
> +       return (end - start + 1) / align;
> +}
> +
> +/*
> + * The UEFI memory descriptors have a virtual address field that is only used
> + * when installing the virtual mapping using SetVirtualAddressMap(). Since it
> + * is unused here, we can reuse it to keep track of each descriptor's slot
> + * count.
> + */
> +#define MD_NUM_SLOTS(md)       ((md)->virt_addr)
> +
> +efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
> +                             unsigned long size,
> +                             unsigned long align,
> +                             unsigned long *addr,
> +                             unsigned long random_seed)
> +{
> +       unsigned long map_size, desc_size, total_slots = 0, target_slot;
> +       efi_status_t status = EFI_NOT_FOUND;
> +       efi_memory_desc_t *memory_map;
> +       int map_offset;
> +
> +       status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
> +                                   &desc_size, NULL, NULL);
> +       if (status != EFI_SUCCESS)
> +               return status;
> +
> +       if (align < EFI_ALLOC_ALIGN)
> +               align = EFI_ALLOC_ALIGN;
> +
> +       /* count the suitable slots in each memory map entry */
> +       for (map_offset = 0; map_offset < map_size; map_offset += desc_size) {
> +               efi_memory_desc_t *md = (void *)memory_map + map_offset;
> +               unsigned long slots;
> +
> +               slots = get_entry_num_slots(md, size, align);
> +               MD_NUM_SLOTS(md) = slots;
> +               total_slots += slots;
> +       }
> +
> +       /* find a random number between 0 and total_slots */
> +       target_slot = (total_slots * (u16)random_seed) >> 16;
> +
> +       /*
> +        * target_slot is now a value in the range [0, total_slots), and so
> +        * it corresponds with exactly one of the suitable slots we recorded
> +        * when iterating over the memory map the first time around.
> +        *
> +        * So iterate over the memory map again, subtracting the number of
> +        * slots of each entry at each iteration, until we have found the entry
> +        * that covers our chosen slot. Use the residual value of target_slot
> +        * to calculate the randomly chosen address, and allocate it directly
> +        * using EFI_ALLOCATE_ADDRESS.
> +        */
> +       for (map_offset = 0; map_offset < map_size; map_offset += desc_size) {
> +               efi_memory_desc_t *md = (void *)memory_map + map_offset;
> +               efi_physical_addr_t target;
> +               unsigned long pages;
> +
> +               if (target_slot >= MD_NUM_SLOTS(md)) {
> +                       target_slot -= MD_NUM_SLOTS(md);
> +                       continue;
> +               }
> +
> +               target = round_up(md->phys_addr, align) + target_slot * align;
> +               pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> +
> +               status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
> +                                       EFI_LOADER_DATA, pages, &target);
> +               if (status == EFI_SUCCESS)
> +                       *addr = target;
> +               break;
> +       }
> +
> +       efi_call_early(free_pool, memory_map);
> +
> +       return status;
> +}
> --
> 2.5.0
>



-- 
Kees Cook
Chrome OS & Brillo Security
