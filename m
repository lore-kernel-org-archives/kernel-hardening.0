Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Sep 2016 03:08:14 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160930020813.GB4611@remoulade>
References: <20160929213257.30505-1-labbott@redhat.com>
 <20160929213257.30505-4-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929213257.30505-4-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] arm64: dump: Add checking for writable and
 exectuable pages
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Thu, Sep 29, 2016 at 02:32:57PM -0700, Laura Abbott wrote:
> Page mappings with full RWX permissions are a security risk. x86
> has an option to walk the page tables and dump any bad pages.
> (See e1a58320a38d ("x86/mm: Warn on W^X mappings")). Add a similar
> implementation for arm64.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>

> @@ -31,6 +32,8 @@ struct ptdump_info {
>  	const struct addr_marker	*markers;
>  	unsigned long			base_addr;
>  	unsigned long			max_addr;

(unrelated aside: it looks like max_addr is never used or even assigned to;
care to delete it in a prep patch?)

> +	/* Internal, do not touch */
> +	struct list_head		node;
>  };

> +static LIST_HEAD(dump_info);

With the EFI runtime map tables it's unfortunately valid (and very likely with
64K pages) that there will be RWX mappings, at least with contemporary versions
of the UEFI spec. Luckily, those are only installed rarely and transiently.

Given that (and other potential ptdump users), I don't think we should have a
dynamic list of ptdump_infos for W^X checks, and should instead have
ptdump_check_wx() explicitly check the tables we care about. More comments
below on that.

I think we only care about the swapper and hyp tables, as nothing else is
permanent. Does that sound sane?

>  struct prot_bits {
> @@ -219,6 +223,15 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>  		unsigned long delta;
>  
>  		if (st->current_prot) {
> +			if (st->check_wx &&
> +			((st->current_prot & PTE_RDONLY) != PTE_RDONLY) &&
> +			((st->current_prot & PTE_PXN) != PTE_PXN)) {
> +				WARN_ONCE(1, "arm64/mm: Found insecure W+X mapping at address %p/%pS\n",
> +					 (void *)st->start_address,
> +					 (void *)st->start_address);
> +				st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
> +			}
> +

Currently note_page() is painful to read due to the indentation and logic.
Rather than adding to that, could we factor this into a helper? e.g.

note_prot_wx(struct pg_state *st, unsigned long addr)
{
	if (!st->check_wx)
		return;
	if ((st->current_prot & PTE_RDONLY) == PTE_RDONLY)
		return;
	if ((st->current_prot & PTE_PXN) == PTE_PXN)
		return;

	WARN_ONCE(1, "arm64/mm: Found insecure W+X mapping at address %p/%pS\n",
		  (void *)st->start_address, (void *)st->start_address);

	st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
}

> +void ptdump_check_wx(void)
> +{
> +	struct ptdump_info *info;
> +
> +	list_for_each_entry(info, &dump_info, node) {
> +		struct pg_state st = {
> +			.seq = NULL,
> +			.marker = info->markers,
> +			.check_wx = true,
> +		};
> +
> +		__walk_pgd(&st, info->mm, info->base_addr);
> +		note_page(&st, 0, 0, 0);
> +		if (st.wx_pages)
> +			pr_info("Checked W+X mappings (%p): FAILED, %lu W+X pages found\n",
> +				info->mm,
> +				st.wx_pages);
> +		else
> +			pr_info("Checked W+X mappings (%p): passed, no W+X pages found\n", info->mm);
> +	}
> +}

As above, I don't think we should use a list of arbitrary ptdump_infos.

Given we won't log addresses in the walking code, I think that we can make up a
trivial marker array, and then just use init_mm direct, e.g. (never even
compile-tested):

void ptdump_check_wx(void)
{
	struct pg_state st = {
		.seq = NULL,
		.marker = (struct addr_markers[]) {
			{ -1, NULL},
		},
		.check_wx = true,
	};

	__walk_pgd(&st, init_mm, 0);
	note_page(&st, 0, 0, 0);
	if (st.wx_pages)
		pr_info("Checked W+X mappings (%p): FAILED, %lu W+X pages found\n",
			info->mm,
			st.wx_pages);
	else
		pr_info("Checked W+X mappings (%p): passed, no W+X pages found\n", info->mm);
}

Otherwise, this looks good to me. Thanks for putting this together!

Mark.
