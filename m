Date: Sun, 22 Jan 2017 21:31:58 +0100
From: Solar Designer <solar@openwall.com>
Message-ID: <20170122203158.GB25345@openwall.com>
References: <20170121234105.GA22967@openwall.com> <CA+rthh-bH-A2Ya1CMfBMZm0fJ4+mnacHn58jaZrURTT9tu0PRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh-bH-A2Ya1CMfBMZm0fJ4+mnacHn58jaZrURTT9tu0PRA@mail.gmail.com>
Subject: Re: [kernel-hardening] Disable and lock Silicon Debug feature on modern Intel CPUs
To: Mathias Krause <minipli@googlemail.com>
Cc: kernel-hardening@lists.openwall.com, Mike Belopuhov <mikeb@openbsd.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 22, 2017 at 05:30:11PM +0100, Mathias Krause wrote:
> On 22 January 2017 at 00:41, Solar Designer <solar@openwall.com> wrote:
> > OpenBSD just got this a week ago:
> >
> > https://freshbsd.org/commit/openbsd/f16aad7b540921691f7841ef8ccbb7e7ca22dfd1
> >
> > "Disable and lock Silicon Debug feature on modern Intel CPUs
> >
> > This implements one of the countermeasures against using Direct
> > Connect Interface (DCI) to debug CPUs via USB3 mentioned in the
> > "Tapping into the core" talk at the 33c3: identify and disable
> > the Silicon Debug feature found in Haswell and newer CPUs."
> 
> This patch makes no sense whatsoever as the precondition -- the lock
> bit still being 0 -- cannot be true on any effected system. That's
> because *every* firmware theses days (EFI/UEFI/coreboot/...) installs
> a SMI handler and tries to protect the SMRAM from long know attacks by
> relocating it from its default location to ASEG/TSEG/you-name-it (see,
> e.g., SDM chapter 34.11 SMBASE Relocation). That, however, requires
> generating a SMI as the registers for relocation (SMBASE resp.
> IA32_SMRR_PHYSBASE and IA32_SMRR_PHYSMASK,
> MSR_SMM_FEATURE_CONTROL,...) are only accessible/writable while in
> SMM. So, getting back to the patch, that early "relocation SMI" will,
> as documented, implicitly set the lock bit of the IA32_DEBUG_INTERFACE
> MSR which makes any attempt to disable SDBG later on useless. So, for
> me, this patch is just snake oil.
> 
> The only thing that MSR can be made use of is reporting; to tell the
> user if SBDG was used by testing the "Debug Occurred" bit. That's the
> reason why I just added the CPUID flag in
> http://lists.openwall.net/linux-kernel/2015/07/19/228 and no follow-up
> patch to disable SDBG.

Thanks for explaining this, Mathias.  When I saw your name on the 2015
LKML posting above, I thought there could be a reason behind not doing
anything else about this; I should have worded my posting accordingly.

I am now CC'ing Mike who made the OpenBSD commit, just to make sure he's
aware of this reasoning and so that he can possibly weigh in, if he has
anything to add - e.g., was OpenBSD's change tested on any laptop and
shown to make a difference?  Meanwhile, I withdraw my earlier suggestion
for Linux to do anything else about this issue.

Alexander
