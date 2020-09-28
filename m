Return-Path: <SRS0=7wJ0=DF=lists.openwall.com=kernel-hardening-return-20015-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA46C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Sep 2020 16:07:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9109120809
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Sep 2020 16:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9109120809
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20015-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7966 invoked by uid 550); 28 Sep 2020 16:07:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5861 invoked from network); 28 Sep 2020 16:02:30 -0000
Date: Mon, 28 Sep 2020 17:02:16 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ard Biesheuvel <ardb@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, "Jason A . Donenfeld"
	<Jason@zx2c4.com>, <lorenzo.pieralisi@arm.com>,
	<kernel-hardening@lists.openwall.com>, <catalin.marinas@arm.com>,
	<linux-acpi@vger.kernel.org>, <sudeep.holla@arm.com>, <will@kernel.org>,
	<linuxarm@huawei.com>
Subject: Re: [PATCH v3 1/2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
Message-ID: <20200928170216.00006ff2@huawei.com>
In-Reply-To: <20200626155832.2323789-2-ardb@kernel.org>
References: <20200626155832.2323789-1-ardb@kernel.org>
	<20200626155832.2323789-2-ardb@kernel.org>
Organization: Huawei tech. R&D (UK)  Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.227.96.57]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Fri, 26 Jun 2020 17:58:31 +0200
Ard Biesheuvel <ardb@kernel.org> wrote:

> AML uses SystemMemory opregions to allow AML handlers to access MMIO
> registers of, e.g., GPIO controllers, or access reserved regions of
> memory that are owned by the firmware.
> 
> Currently, we also allow AML access to memory that is owned by the
> kernel and mapped via the linear region, which does not seem to be
> supported by a valid use case, and exposes the kernel's internal
> state to AML methods that may be buggy and exploitable.
> 
> On arm64, ACPI support requires booting in EFI mode, and so we can cross
> reference the requested region against the EFI memory map, rather than
> just do a minimal check on the first page. So let's only permit regions
> to be remapped by the ACPI core if
> - they don't appear in the EFI memory map at all (which is the case for
>   most MMIO), or
> - they are covered by a single region in the EFI memory map, which is not
>   of a type that describes memory that is given to the kernel at boot.
> 
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Hi Ard,

Ran into a problem with this one. See below

> ---
>  arch/arm64/include/asm/acpi.h | 15 +----
>  arch/arm64/kernel/acpi.c      | 66 ++++++++++++++++++++
>  2 files changed, 67 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index a45366c3909b..bd68e1b7f29f 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -47,20 +47,7 @@
>  pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
>  
>  /* ACPI table mapping after acpi_permanent_mmap is set */
> -static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
> -					    acpi_size size)
> -{
> -	/* For normal memory we already have a cacheable mapping. */
> -	if (memblock_is_map_memory(phys))
> -		return (void __iomem *)__phys_to_virt(phys);
> -
> -	/*
> -	 * We should still honor the memory's attribute here because
> -	 * crash dump kernel possibly excludes some ACPI (reclaim)
> -	 * regions from memblock list.
> -	 */
> -	return __ioremap(phys, size, __acpi_get_mem_attribute(phys));
> -}
> +void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size);
>  #define acpi_os_ioremap acpi_os_ioremap
>  
>  typedef u64 phys_cpuid_t;
> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
> index a7586a4db142..01b861e225b0 100644
> --- a/arch/arm64/kernel/acpi.c
> +++ b/arch/arm64/kernel/acpi.c
> @@ -261,6 +261,72 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
>  	return __pgprot(PROT_DEVICE_nGnRnE);
>  }
>  
> +void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
> +{
> +	efi_memory_desc_t *md, *region = NULL;
> +	pgprot_t prot;
> +
> +	if (WARN_ON_ONCE(!efi_enabled(EFI_MEMMAP)))
> +		return NULL;
> +
> +	for_each_efi_memory_desc(md) {
> +		u64 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> +
> +		if (phys < md->phys_addr || phys >= end)
> +			continue;
> +
> +		if (phys + size > end) {
> +			pr_warn(FW_BUG "requested region covers multiple EFI memory regions\n");
> +			return NULL;
> +		}
> +		region = md;
> +		break;
> +	}
> +
> +	/*
> +	 * It is fine for AML to remap regions that are not represented in the
> +	 * EFI memory map at all, as it only describes normal memory, and MMIO
> +	 * regions that require a virtual mapping to make them accessible to
> +	 * the EFI runtime services.
> +	 */
> +	prot = __pgprot(PROT_DEVICE_nGnRnE);
> +	if (region) {
> +		switch (region->type) {
> +		case EFI_LOADER_CODE:
> +		case EFI_LOADER_DATA:

Unfortunately this seems to have broken overriding of ACPI tables from an initrd.
My particular test environment is qemu + EDK2.

It only has obvious visible affect on tables that are used late in the boot such as PPTT
as they get dropped before they are used.

These are read after ACPICA is initialized and acpi_reallocate_root_table()
has been called.  The back trace is:

acpi_os_ioremap+0xfc/0x288
acpi_os_map_iomem+0xc4/0x188
acpi_os_map_memory+0x18/0x28
acpi_tb_acquire_table+0x54/0x8c
acpi_tb_validate_table+0x34/0x5c
acpi_tb_validate_temp_table+0x34/0x40
acpi_tb_verify_temp_table+0x48/0x250
acpi_reallocate_root_table+0x12c/0x160

Seems that the table is in a region of type EFI_LOADER_DATA.

I don't really know enough about this area to be sure what the right fix is or
even whether this is a kernel issue, or one that should be fixed elsewhere in
the stack.

For now I'm just carry a hack that treats EFI_LOADER_DATA in the same fashion as
EFI_ACPI_RECLAIM_MEMORY below.

What's the right way to fix this?

Jonathan


> +		case EFI_BOOT_SERVICES_CODE:
> +		case EFI_BOOT_SERVICES_DATA:
> +		case EFI_CONVENTIONAL_MEMORY:
> +		case EFI_PERSISTENT_MEMORY:
> +			pr_warn(FW_BUG "requested region covers kernel memory @ %pa\n", &phys);
> +			return NULL;
> +
> +		case EFI_ACPI_RECLAIM_MEMORY:
> +			/*
> +			 * ACPI reclaim memory is used to pass firmware tables
> +			 * and other data that is intended for consumption by
> +			 * the OS only, which may decide it wants to reclaim
> +			 * that memory and use it for something else. We never
> +			 * do that, but we usually add it to the linear map
> +			 * anyway, in which case we should use the existing
> +			 * mapping.
> +			 */
> +			if (memblock_is_map_memory(phys))
> +				return (void __iomem *)__phys_to_virt(phys);
> +			/* fall through */
> +
> +		default:
> +			if (region->attribute & EFI_MEMORY_WB)
> +				prot = PAGE_KERNEL;
> +			else if (region->attribute & EFI_MEMORY_WT)
> +				prot = __pgprot(PROT_NORMAL_WT);
> +			else if (region->attribute & EFI_MEMORY_WC)
> +				prot = __pgprot(PROT_NORMAL_NC);
> +		}
> +	}
> +	return __ioremap(phys, size, prot);
> +}
> +
>  /*
>   * Claim Synchronous External Aborts as a firmware first notification.
>   *

