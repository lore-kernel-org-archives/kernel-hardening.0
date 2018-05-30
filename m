Date: Wed, 30 May 2018 10:14:58 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: mm: mark tramp_pg_dir read-only
Message-ID: <20180530091457.GB2452@arm.com>
References: <20180530044806.18449-1-yaojun8558363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180530044806.18449-1-yaojun8558363@gmail.com>
To: YaoJun <yaojun8558363@gmail.com>
Cc: kernel-hardening@lists.openwall.com, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 30, 2018 at 12:48:06PM +0800, YaoJun wrote:
> To protect against KSMA(Kernel Space Mirroring Attack), make
> tramp_pg_dir read-only. The principle of KSMA is to insert a
> carefully constructed PGD entry into the translation table.
> The type of this entry is block, which maps the kernel text
> and its access permissions bits are 01. The user process can
> then modify kernel text directly through this mapping. In this
> way, an arbitrary write can be converted to multiple arbitrary
> writes.
> 
> Signed-off-by: YaoJun <yaojun8558363@gmail.com>
> ---
>  arch/arm64/mm/mmu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2dbb2c9f1ec1..ac4b22c7e435 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -551,6 +551,10 @@ static int __init map_entry_trampoline(void)
>  	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
>  			     prot, pgd_pgtable_alloc, 0);
>  
> +	update_mapping_prot(__pa_symbol(tramp_pg_dir),
> +				(unsigned long)tramp_pg_dir,
> +				PGD_SIZE, PAGE_KERNEL_RO);

Hmm, I like the idea but is there a risk that the page table has been mapped
as part of a block entry, which we can't safely split at this point (i.e.
we'll run into one of the BUG_ONs in the mapping code)?

Will
