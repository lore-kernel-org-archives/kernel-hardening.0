MIME-Version: 1.0
In-Reply-To: <20170121234105.GA22967@openwall.com>
References: <20170121234105.GA22967@openwall.com>
From: Mathias Krause <minipli@googlemail.com>
Date: Sun, 22 Jan 2017 17:30:11 +0100
Message-ID: <CA+rthh-bH-A2Ya1CMfBMZm0fJ4+mnacHn58jaZrURTT9tu0PRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Disable and lock Silicon Debug feature on
 modern Intel CPUs
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 22 January 2017 at 00:41, Solar Designer <solar@openwall.com> wrote:
> OpenBSD just got this a week ago:
>
> https://freshbsd.org/commit/openbsd/f16aad7b540921691f7841ef8ccbb7e7ca22dfd1
>
> "Disable and lock Silicon Debug feature on modern Intel CPUs
>
> This implements one of the countermeasures against using Direct
> Connect Interface (DCI) to debug CPUs via USB3 mentioned in the
> "Tapping into the core" talk at the 33c3: identify and disable
> the Silicon Debug feature found in Haswell and newer CPUs."

This patch makes no sense whatsoever as the precondition -- the lock
bit still being 0 -- cannot be true on any effected system. That's
because *every* firmware theses days (EFI/UEFI/coreboot/...) installs
a SMI handler and tries to protect the SMRAM from long know attacks by
relocating it from its default location to ASEG/TSEG/you-name-it (see,
e.g., SDM chapter 34.11 SMBASE Relocation). That, however, requires
generating a SMI as the registers for relocation (SMBASE resp.
IA32_SMRR_PHYSBASE and IA32_SMRR_PHYSMASK,
MSR_SMM_FEATURE_CONTROL,...) are only accessible/writable while in
SMM. So, getting back to the patch, that early "relocation SMI" will,
as documented, implicitly set the lock bit of the IA32_DEBUG_INTERFACE
MSR which makes any attempt to disable SDBG later on useless. So, for
me, this patch is just snake oil.

The only thing that MSR can be made use of is reporting; to tell the
user if SBDG was used by testing the "Debug Occurred" bit. That's the
reason why I just added the CPUID flag in
http://lists.openwall.net/linux-kernel/2015/07/19/228 and no follow-up
patch to disable SDBG.


Cheers,
Mathias
