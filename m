Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:02:50 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128090250.3gxq2uoebiwh4who@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972912.26578.6792656143278523491.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703972912.26578.6792656143278523491.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 03/12] x86: implement array_idx_mask
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> 'array_idx' uses a mask to sanitize user controllable array indexes,
> i.e. generate a 0 mask if idx >= sz, and a ~0 mask otherwise. While the
> default array_idx_mask handles the carry-bit from the (index - size)
> result in software. The x86 'array_idx_mask' does the same, but the
> carry-bit is handled in the processor CF flag without conditional
> instructions in the control flow.

Same style comments apply as for patch 02.

> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/include/asm/barrier.h |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
> index 01727dbc294a..30419b674ebd 100644
> --- a/arch/x86/include/asm/barrier.h
> +++ b/arch/x86/include/asm/barrier.h
> @@ -24,6 +24,28 @@
>  #define wmb()	asm volatile("sfence" ::: "memory")
>  #endif
>  
> +/**
> + * array_idx_mask - generate a mask for array_idx() that is ~0UL when
> + * the bounds check succeeds and 0 otherwise
> + *
> + *     mask = 0 - (idx < sz);
> + */
> +#define array_idx_mask array_idx_mask
> +static inline unsigned long array_idx_mask(unsigned long idx, unsigned long sz)

Please put an extra newline between definitions (even if they are closely related 
as these).

> +{
> +	unsigned long mask;
> +
> +#ifdef CONFIG_X86_32
> +	asm ("cmpl %1,%2; sbbl %0,%0;"
> +#else
> +	asm ("cmpq %1,%2; sbbq %0,%0;"
> +#endif

Wouldn't this suffice:

	asm ("cmp %1,%2; sbb %0,%0;"

... as the word width should automatically be 32 bits on 32-bit kernels and 64 
bits on 64-bit kernels?

Thanks,

	Ingo
