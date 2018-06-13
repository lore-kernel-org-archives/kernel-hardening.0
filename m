Subject: Re: [PATCH v3 3/3] arm64/mm: migrate swapper_pg_dir and tramp_pg_dir
References: <20180606043921.19851-1-yaojun8558363@gmail.com>
 <20180606043921.19851-4-yaojun8558363@gmail.com>
From: James Morse <james.morse@arm.com>
Message-ID: <1ef0fd31-001d-0872-7089-70ec22bab59f@arm.com>
Date: Wed, 13 Jun 2018 10:17:36 +0100
MIME-Version: 1.0
In-Reply-To: <20180606043921.19851-4-yaojun8558363@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Jun Yao <yaojun8558363@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, robin.murphy@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Jun,

On 06/06/18 05:39, Jun Yao wrote:
> Migrate swapper_pg_dir and tramp_pg_dir. And their virtual addresses
> do not correlate with kernel's address.

This is all to make 'KSMA' harder, where an single arbitrary write is used to
add a block mapping to the page-tables, giving the attacker full access to
physical memory.

This series is pretty complicated, and would still be overcome by arbitrary-read
of __pa_swapper_pg_dir. Any attacker already has to defeat KASLR, but I guess
that can be done without having read-access.


> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 94056e064c6f..ba0b55158971 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -637,10 +647,29 @@ static void __init map_kernel(pgd_t *pgdp)
>   */
>  void __init paging_init(void)
>  {
> -	phys_addr_t pgd_phys = early_pgtable_alloc();
> -	pgd_t *pgdp = pgd_set_fixmap(pgd_phys);
> +	phys_addr_t pgd_phys;
> +	pgd_t *pgdp;
> +	phys_addr_t mem_size;
>
> -	__pa_swapper_pg_dir = __pa_symbol(swapper_pg_dir);
> +	mem_size = __pa_symbol(swapper_pg_dir) + PAGE_SIZE
> +			- (__pa_symbol(idmap_pg_dir) + IDMAP_DIR_SIZE);
> +
> +	if (mem_size == PAGE_SIZE) {
> +		pgd_phys = early_pgtable_alloc();

This is where we migrated swapper_pg_dir to, its the first memblock_alloc()
call, and is guaranteed to be at the top of memory. Moving this allocation later
will still cause a predictable page to be allocated as this setup code is the
only thing running. I don't think we are in a better position after this series.


Ideally we would put these pgd entries in the read-only section. We only modify
swapper_pg_dir for vmalloc()/vmap() once its generated, which we could do
through a fixmap entry.

Like this, an attacker can find where swapper_pg_dir is, but can't write to it.
(the tricky bit will be breaking swapper_pg_dir up, as we free parts of it)


Thanks,

James
