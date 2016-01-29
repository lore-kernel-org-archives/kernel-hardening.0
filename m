Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 29 Jan 2016 15:39:35 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
Message-ID: <20160129153935.GB2611@codeblueprint.co.uk>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
 <1453828249-14467-21-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453828249-14467-21-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v4 20/22] efi: stub: add implementation of
 efi_random_alloc()
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Jan, at 06:10:47PM, Ard Biesheuvel wrote:
> +
> +/*
> + * The UEFI memory descriptors have a virtual address field that is only used
> + * when installing the virtual mapping using SetVirtualAddressMap(). Since it
> + * is unused here, we can reuse it to keep track of each descriptor's slot
> + * count.
> + */
> +#define MD_NUM_SLOTS(md)	((md)->virt_addr)
> +
> +efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
> +			      unsigned long size,
> +			      unsigned long align,
> +			      unsigned long *addr,
> +			      unsigned long random_seed)
> +{
> +	unsigned long map_size, desc_size, total_slots = 0, target_slot;
> +	efi_status_t status = EFI_NOT_FOUND;
> +	efi_memory_desc_t *memory_map;
> +	int map_offset;

The assignment of 'status' is not needed since it gets assigned a new
value immediately.

Otherwise looks good.

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
