Date: Thu, 23 Mar 2017 14:12:03 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170323141203.GD14290@e104818-lin.cambridge.arm.com>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v6 00/11] arm64: mmu: avoid W+X mappings and re-enable
 PTE_CONT for kernel
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 09, 2017 at 09:51:58PM +0100, Ard Biesheuvel wrote:
> Ard Biesheuvel (11):
>   arm: kvm: move kvm_vgic_global_state out of .text section
>   arm64: mmu: move TLB maintenance from callers to create_mapping_late()
>   arm64: alternatives: apply boot time fixups via the linear mapping
>   arm64: mmu: map .text as read-only from the outset
>   arm64: mmu: apply strict permissions to .init.text and .init.data
>   arm64/mmu: align alloc_init_pte prototype with pmd/pud versions
>   arm64/mmu: ignore debug_pagealloc for kernel segments
>   arm64/mmu: add contiguous bit to sanity bug check
>   arm64/mmu: replace 'page_mappings_only' parameter with flags argument
>   arm64/mm: remove pointless map/unmap sequences when creating page
>     tables
>   arm64: mm: set the contiguous bit for kernel mappings where
>     appropriate

Queued for 4.12. Thanks.

-- 
Catalin
