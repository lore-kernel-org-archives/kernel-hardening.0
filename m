Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 9 Sep 2016 18:15:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160909171537.GD19083@e104818-lin.cambridge.arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/7] arm64: Introduce uaccess_{disable, enable}
 functionality based on TTBR0_EL1
To: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 02, 2016 at 04:02:09PM +0100, Catalin Marinas wrote:
>  /*
>   * User access enabling/disabling.
>   */
> +#ifdef CONFIG_ARM64_TTBR0_PAN
> +static inline void uaccess_ttbr0_disable(void)
> +{
> +	unsigned long ttbr;
> +
> +	/* reserved_ttbr0 placed at the end of swapper_pg_dir */
> +	ttbr = read_sysreg(ttbr1_el1) + SWAPPER_DIR_SIZE;
> +	write_sysreg(ttbr, ttbr0_el1);
> +	isb();
> +}
> +
> +static inline void uaccess_ttbr0_enable(void)
> +{
> +	unsigned long flags;
> +
> +	/*
> +	 * Disable interrupts to avoid preemption and potential saved
> +	 * TTBR0_EL1 updates between reading the variable and the MSR.
> +	 */
> +	local_irq_save(flags);
> +	write_sysreg(current_thread_info()->ttbr0, ttbr0_el1);
> +	isb();
> +	local_irq_restore(flags);
> +}

I followed up with the ARM architects on potential improvements to this
sequence. In summary, changing TCR_EL1.A1 is not guaranteed to have an
effect unless it is followed by TLBI. IOW, we can't use this bit for a
quick switch to the reserved ASID.

Setting TCR_EL1.EPD0 to 1 would work as long as it is followed by an
ASID change to a reserved one with no entries in the TLB. However, the
code sequence above (and the corresponding asm ones) would become even
more complex, so I don't think we gain anything.

Untested, using EPD0 (the assembly version would look sligtly better
than the C version but still a few instructions more than what we
currently have):

static inline void uaccess_ttbr0_disable(void)
{
	unsigned long ttbr;
	unsigned long tcr;

	/* disable TTBR0 page table walks */
	tcr = read_sysreg(tcr_el1);
	tcr |= TCR_ELD0
	write_sysreg(tcr, tcr_el1);
	isb();

	/* mask out the ASID bits (zero is a reserved ASID) */
	ttbr = read_sysreg(ttbr0_el1);
	ttbr &= ~ASID_MASK;
	write_sysreg(ttbr, ttbr0_el1);
	isb();
}

static inline void uaccess_ttbr0_enable(void)
{
	unsigned long flags;

	local_irq_save(flags);

	ttbr = read_sysreg(ttbr0_el1);
	ttbr |= current_thread_info()->asid;
	write_sysreg(ttbr, ttbr0_el1);
	isb();

	/* enable TTBR0 page table walks */
	tcr = read_sysreg(tcr_el1);
	tcr |= TCR_ELD0
	write_sysreg(tcr, tcr_el1);
	isb();

	local_irq_restore(flags);
}

The IRQ disabling for the above sequence is still required since we need
to guarantee the atomicity of the ASID read with the TTBR0_EL1 write.

We may be able to avoid current_thread_info()->asid *if* we find some
other per-CPU place to store the ASID (unused TTBR1_EL1 bits was
suggested, though not sure about the architecture requirements on those
bits being zero when TCR_EL1.A1 is 0). But even with these in place, the
requirement to have to ISBs and the additional TCR_EL1 read/write
doesn't give us anything better.

In conclusion, I propose that we stick to the current TTBR0_EL1 switch
as per these patches.

-- 
Catalin
