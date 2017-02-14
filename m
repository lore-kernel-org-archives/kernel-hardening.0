Date: Tue, 14 Feb 2017 17:40:30 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170214174029.GJ23718@leverpostej>
References: <1486844586-26135-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486844586-26135-5-git-send-email-ard.biesheuvel@linaro.org>
 <20170214155704.GE23718@leverpostej>
 <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <651D9CBB-3E64-41CE-BF85-D2FF0CB927B7@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 4/5] arm64: mmu: map .text as read-only from the outset
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, Suzuki.Poulose@arm.com, james.morse@arm.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, nd@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 04:15:11PM +0000, Ard Biesheuvel wrote:
> 
> > On 14 Feb 2017, at 15:57, Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> >> On Sat, Feb 11, 2017 at 08:23:05PM +0000, Ard Biesheuvel wrote:
> >> Now that alternatives patching code no longer relies on the primary
> >> mapping of .text being writable, we can remove the code that removes
> >> the writable permissions post-init time, and map it read-only from
> >> the outset.
> >> 
> >> Reviewed-by: Laura Abbott <labbott@redhat.com>
> >> Reviewed-by: Kees Cook <keescook@chromium.org>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > 
> > This generally looks good.
> > 
> > One effect of this is that even with rodata=off, external debuggers
> > can't install SW breakpoints via the executable mapping.
> 
> Interesting. For the sake of my education, could you elaborate on how
> that works under the hood?

There are details in ARM DDI 0487A.k_iss10775, Chapter H1, "About
External Debug", page H1-4839 onwards. Otherwise, executive summary
below.

An external debugger can place a CPU into debug state. This is
orthogonal to execution state and exception level, which are unchanged.
While in this state, the CPU (only) executes instructions fed to it by
the debugger through a special register.

To install a SW breakpoint, the debugger makes the CPU enter debug
state, then issues regular stores, barriers, and cache maintenance.
These operate in the current execution state at the current EL, using
the current translation regime.

The external debugger can also trap exceptions (e.g. those caused by the
SW breakpoint). The CPU enters debug state when these are trapped.

> > We might want to allow that to be overridden. e.g. make rodata= an
> > early param, and switch the permissions based on that in map_kernel(),
> > e.g. have:
> > 
> >    pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX
> >                        : PAGE_KERNEL_EXEC);
> > 
> > ... and use that for .text and .init.text by default.
> > 
> > 
> 
> Is there any way we could restrict this privilege to external
> debuggers?

My understanding is that we cannot.

> Having trivial 'off' switches for security features makes me feel
> uneasy (although this is orthogonal to this patch)

>From my PoV, external debuggers are the sole reason to allow rodata=off
for arm64, and we already allow rodata=off.

Thanks,
Mark.
