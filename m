Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Sep 2016 01:36:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160930003627.GB4369@remoulade>
References: <20160929213257.30505-1-labbott@redhat.com>
 <20160929213257.30505-3-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160929213257.30505-3-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 2/3] arm64: dump: Make the page table dumping seq_file
 optional
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 29, 2016 at 02:32:56PM -0700, Laura Abbott wrote:
> The page table dumping code always assumes it will be dumping to a
> seq_file to userspace. The dumping code is useful in other situations.
> Let the seq_file be optional.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

It might be worth elaborating on those other situations, e.g. that for those
we'll have some additional logic that will only run in the absence of a
seq_file.

The NOPing out of logic in the !seq_file case does feel a bit like spaghetti
code, but it's not obvious to me that adding finer-grained callbacks is much
better, and I guess we can reconsider that if and when we need to add more
logic.

Regardless of the above:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> ---
>  arch/arm64/mm/dump.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> index 29e0838..e318f3d 100644
> --- a/arch/arm64/mm/dump.c
> +++ b/arch/arm64/mm/dump.c
> @@ -50,6 +50,18 @@ static const struct addr_marker address_markers[] = {
>  	{ -1,				NULL },
>  };
>  
> +#define pt_dump_seq_printf(m, fmt, args...)	\
> +({						\
> +	if (m)					\
> +		seq_printf(m, fmt, ##args);	\
> +})
> +
> +#define pt_dump_seq_puts(m, fmt)	\
> +({					\
> +	if (m)				\
> +		seq_printf(m, fmt);	\
> +})
> +
>  /*
>   * The page dumper groups page table entries of the same type into a single
>   * description. It uses pg_state to track the range information while
> @@ -186,7 +198,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
>  			s = bits->clear;
>  
>  		if (s)
> -			seq_printf(st->seq, " %s", s);
> +			pt_dump_seq_printf(st->seq, " %s", s);
>  	}
>  }
>  
> @@ -200,14 +212,14 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>  		st->level = level;
>  		st->current_prot = prot;
>  		st->start_address = addr;
> -		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> +		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>  	} else if (prot != st->current_prot || level != st->level ||
>  		   addr >= st->marker[1].start_address) {
>  		const char *unit = units;
>  		unsigned long delta;
>  
>  		if (st->current_prot) {
> -			seq_printf(st->seq, "0x%016lx-0x%016lx   ",
> +			pt_dump_seq_printf(st->seq, "0x%016lx-0x%016lx   ",
>  				   st->start_address, addr);
>  
>  			delta = (addr - st->start_address) >> 10;
> @@ -215,17 +227,17 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>  				delta >>= 10;
>  				unit++;
>  			}
> -			seq_printf(st->seq, "%9lu%c %s", delta, *unit,
> +			pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
>  				   pg_level[st->level].name);
>  			if (pg_level[st->level].bits)
>  				dump_prot(st, pg_level[st->level].bits,
>  					  pg_level[st->level].num);
> -			seq_puts(st->seq, "\n");
> +			pt_dump_seq_puts(st->seq, "\n");
>  		}
>  
>  		if (addr >= st->marker[1].start_address) {
>  			st->marker++;
> -			seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> +			pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>  		}
>  
>  		st->start_address = addr;
> @@ -235,7 +247,7 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>  
>  	if (addr >= st->marker[1].start_address) {
>  		st->marker++;
> -		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
> +		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
>  	}
>  
>  }
> -- 
> 2.10.0
> 
