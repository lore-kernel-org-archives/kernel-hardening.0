Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Sep 2016 13:16:25 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160911121624.GA16859@MBP.local>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <20160910095154.GA21444@e104818-lin.cambridge.arm.com>
 <CAKv+Gu9P4_90LEoyu1apeKZH20imLPD_EiB=zNAvyin-67ivKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9P4_90LEoyu1apeKZH20imLPD_EiB=zNAvyin-67ivKQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 10, 2016 at 11:56:14AM +0100, Ard Biesheuvel wrote:
> On 10 September 2016 at 10:51, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > On Fri, Sep 02, 2016 at 04:02:06PM +0100, Catalin Marinas wrote:
> >> This is the second version of the arm64 PAN emulation by disabling
> >> TTBR0_EL1 accesses. The major change from v1 is the use of a thread_info
> >> member to store the real TTBR0_EL1 value. The advantage is slightly
> >> simpler assembler macros for uaccess_enable with the downside that
> >> switch_mm() must always update the saved ttbr0 even if there is no mm
> >> switch.
> >
> > FYI, I got the Juno board rebooting in a loop with defconfig +
> > ARM64_TTBR0_PAN enabled. It takes about 20-40 reboots to get the panic
> > below on the EFI run-time services. I'll look into it on Monday (and
> > cc'ing Ard who I forgot to add originally). Including the full log
> > below:
> 
> Could you please try to reproduce it again, but this time with
> 'efi=debug' on the kernel command line? Thanks

Just for the record, following our private email exchanges: when
executing an EFI runtime service, an interrupt comes in and Linux
disables TTBR0 accesses. When returning from interrupt, the kernel
restores TTBR0_EL1 with the value in current thread_info which is
different from the efi_mm one.

Two potential solutions:

1. Temporarily update the current thread_info ttbr0 during EFI runtime
   services (preemption is disabled). Suggested by Ard

2. Go back to per-CPU saving of TTBR0_EL1 as in v1

I'll implement 1 on Monday and give it a try.

-- 
Catalin
