Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Sep 2016 16:55:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160916155550.GC1904@e104818-lin.cambridge.arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <1473788797-10879-6-git-send-email-catalin.marinas@arm.com>
 <20160916113325.GB21702@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160916113325.GB21702@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v3 5/7] arm64: Handle faults caused by inadvertent user
 access with PAN enabled
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 16, 2016 at 12:33:25PM +0100, Mark Rutland wrote:
> On Tue, Sep 13, 2016 at 06:46:35PM +0100, Catalin Marinas wrote:
> > When TTBR0_EL1 is set to the reserved page, an erroneous kernel access
> > to user space would generate a translation fault. This patch adds the
> > checks for the software-set PSR_PAN_BIT to emulate a permission fault
> > and report it accordingly.
> 
> Why do we need to treat this case as a permission fault? It looks like a
> fault that wasn't a deliberate uaccess (which thus doesn't have a fixup
> handler) should have do_page_fault call __do_kernel_fault, where we
> should die().

We don't always check the exception table for a dedicated uaccess. The
only cases where the exception table is checked is when
down_read_trylock(mmap_sem) fails or CONFIG_DEBUG_VM is enabled. This is
a slight optimisation of the fast path of the page fault handling. So,
without is_permission_fault() (which much quicker than
search_exception_tables()) the kernel would keep restarting the same
instruction.

> > -static inline bool is_permission_fault(unsigned int esr)
> > +static inline bool is_permission_fault(unsigned int esr, struct pt_regs *regs)
> >  {
> >  	unsigned int ec       = ESR_ELx_EC(esr);
> >  	unsigned int fsc_type = esr & ESR_ELx_FSC_TYPE;
> >  
> > -	return (ec == ESR_ELx_EC_DABT_CUR && fsc_type == ESR_ELx_FSC_PERM) ||
> > -	       (ec == ESR_ELx_EC_IABT_CUR && fsc_type == ESR_ELx_FSC_PERM);
> > +	if (ec != ESR_ELx_EC_DABT_CUR && ec != ESR_ELx_EC_IABT_CUR)
> > +		return false;
> > +
> > +	if (system_uses_ttbr0_pan())
> > +		return fsc_type == ESR_ELx_FSC_FAULT &&
> > +			(regs->pstate & PSR_PAN_BIT);
> > +	else
> > +		return fsc_type == ESR_ELx_FSC_PERM;
> >  }
> 
> Since the entry code will clear the PAN bit in the SPSR when we see the
> reserved ASID,

It actually sets the PAN bit in regs->pstate when it sees the reserved
ASID.

> faults in EFI runtime services will still be correctly reported,
> though that's somewhat subtle (and it took me a while to convince
> myself that was the case).

The EFI runtime services use a non-reserved ASID, so a fault taken while
executing EFI services would clear the PAN bit in regs->pstate. Such
faults would not trigger is_permission_fault() == true above.

> Also, I think that faults elsewhere may be misreported, e.g. in cold
> entry to kernel paths (idle, hotplug) where we have a global mapping in
> TTBR0, and it looks like we're using the reserved ASID.
> 
> I'm not immediately sure how to distinguish those cases.

We don't normally expect faults on those paths. If we get one, they are
usually fatal, so the kernel still dies but with a slightly misleading
message.

We could improve this I think if we can distinguished between
reserved_ttbr0 after swapper (set on exception entry) and the reserved
TTBR0_EL1 pointing to empty_zero_page (and not merging Ard's patch). Is
it worth having such distinction? I'm not convinced, the only thing you
probably save is not printing "Accessing user space memory outside
uaccess.h routines" during fault (there may be other ways to mark these
special cases maybe by checking the current thread_info but it needs
more thinking).

-- 
Catalin
