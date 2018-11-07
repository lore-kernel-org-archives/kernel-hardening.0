Subject: Re: [PATCH v4 2/2] arm64: mm: apply r/o permissions of VM areas to
 its linear alias as well
References: <20181107103620.16054-1-ard.biesheuvel@linaro.org>
 <20181107103620.16054-3-ard.biesheuvel@linaro.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <e1c34f97-9687-0475-b7f3-02f54a7b200f@redhat.com>
Date: Wed, 7 Nov 2018 15:17:36 -0800
MIME-Version: 1.0
In-Reply-To: <20181107103620.16054-3-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, will.deacon@arm.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/7/18 2:36 AM, Ard Biesheuvel wrote:
> @@ -93,6 +96,18 @@ static int change_memory_common(unsigned long addr, int numpages,
>   	if (!numpages)
>   		return 0;
>   
> +	/*
> +	 * If we are manipulating read-only permissions, apply the same
> +	 * change to the linear mapping of the pages that back this VM area.
> +	 */
> +	if (rodata_full && (pgprot_val(set_mask) == PTE_RDONLY ||
> +			    pgprot_val(clear_mask) == PTE_RDONLY)) {
> +		for (i = 0; i < area->nr_pages; i++) {
> +			__change_memory_common((u64)page_address(area->pages[i]),
> +					       PAGE_SIZE, set_mask, clear_mask);
> +		}
> +	}
> +
>   	/*
>   	 * Get rid of potentially aliasing lazily unmapped vm areas that may
>   	 * have permissions set that deviate from the ones we are setting here.


This check assumes the masks are only adjusting the PTE_RDONLY bit.
I guess this is fine for now since all the calls currently change one
bit at a time.

Tested-by: Laura Abbott <labbott@redhat.com>
