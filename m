Date: Tue, 29 May 2018 11:02:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] mark tramp_pg_dir read-only
Message-ID: <20180529100200.ntfppwx4i26arwa5@lakrids.cambridge.arm.com>
References: <20180529091609.9830-1-yaojun8558363@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529091609.9830-1-yaojun8558363@gmail.com>
To: YaoJun <yaojun8558363@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

For patches to arm64, please CC the arm64 maintainers, and the
linux-arm-kernel mailing list.

Generally, please try to follow the guidance of
Documentation/process/submitting-patches.rst

e.g. you can use get_maintainer.pl to figure out who to Cc:

[mark@lakrids:~/src/linux]% ./scripts/get_maintainer.pl arch/arm64/mm/mmu.c
Catalin Marinas <catalin.marinas@arm.com> (maintainer:ARM64 PORT (AARCH64 ARCHITECTURE),commit_signer:8/16=50%)
Will Deacon <will.deacon@arm.com> (maintainer:ARM64 PORT (AARCH64 ARCHITECTURE),commit_signer:9/16=56%,authored:6/16=38%,added_lines:205/242=85%,removed_lines:142/157=90%)
Ard Biesheuvel <ard.biesheuvel@linaro.org> (commit_signer:5/16=31%)
Marc Zyngier <marc.zyngier@arm.com> (commit_signer:4/16=25%)
Dan Williams <dan.j.williams@intel.com> (commit_signer:2/16=12%)
Kristina Martsenko <kristina.martsenko@arm.com> (authored:2/16=12%)
James Morse <james.morse@arm.com> (authored:2/16=12%)
Tobias Klauser <tklauser@distanz.ch> (authored:1/16=6%)
Steve Capper <steve.capper@arm.com> (authored:1/16=6%)
linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE))
linux-kernel@vger.kernel.org (open list)

Thanks,
Mark.

On Tue, May 29, 2018 at 05:16:09PM +0800, YaoJun wrote:
> To prevent KSMA(Kernel Space Mirroring Attack), it's necessary
> to set tramp_pg_dir read-only after initialization.
> 
> ---
>  arch/arm64/mm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 2dbb2c9f1ec1..964520e4e675 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -551,6 +551,9 @@ static int __init map_entry_trampoline(void)
>  	__create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS, PAGE_SIZE,
>  			     prot, pgd_pgtable_alloc, 0);
>  
> +	update_mapping_prot(__pa_symbol(tramp_pg_dir), (unsigned long)tramp_pg_dir,
> +			    PGD_SIZE, PAGE_KERNEL_RO);
> +
>  	/* Map both the text and data into the kernel page table */
>  	__set_fixmap(FIX_ENTRY_TRAMP_TEXT, pa_start, prot);
>  	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
> -- 
> 2.17.0
> 
