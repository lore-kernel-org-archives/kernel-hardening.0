Date: Tue, 28 Nov 2017 16:07:26 +0100
From: Andrew Jones <drjones@redhat.com>
Message-ID: <20171128150726.xui5i23uigvfo52w@kamzik.brq.redhat.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
 <20171127163806.31435-13-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127163806.31435-13-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCHv2 12/12] arm64: docs: document pointer authentication
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, cdall@linaro.org, arnd@arndb.de, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org, kvmarm@lists.cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On Mon, Nov 27, 2017 at 04:38:06PM +0000, Mark Rutland wrote:
> Now that we've added code to support pointer authentication, add some
> documentation so that people can figure out if/how to use it.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Yao Qi <yao.qi@arm.com>
> ---
>  Documentation/arm64/booting.txt                |  8 +++
>  Documentation/arm64/elf_hwcaps.txt             |  6 ++
>  Documentation/arm64/pointer-authentication.txt | 85 ++++++++++++++++++++++++++
>  3 files changed, 99 insertions(+)
>  create mode 100644 Documentation/arm64/pointer-authentication.txt
> 
> diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.txt
> index 8d0df62c3fe0..8df9f4658d6f 100644
> --- a/Documentation/arm64/booting.txt
> +++ b/Documentation/arm64/booting.txt
> @@ -205,6 +205,14 @@ Before jumping into the kernel, the following conditions must be met:
>      ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
>    - The DT or ACPI tables must describe a GICv2 interrupt controller.
>  
> +  For CPUs with pointer authentication functionality:
> +  - If EL3 is present:
> +    SCR_EL3.APK (bit 16) must be initialised to 0b1
> +    SCR_EL3.API (bit 17) must be initialised to 0b1
> +  - If the kernel is entered at EL1:
> +    HCR_EL2.APK (bit 40) must be initialised to 0b1
> +    HCR_EL2.API (bit 41) must be initialised to 0b1
> +
>  The requirements described above for CPU mode, caches, MMUs, architected
>  timers, coherency and system registers apply to all CPUs.  All CPUs must
>  enter the kernel in the same exception level.
> diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
> index 89edba12a9e0..6cf40e419a9d 100644
> --- a/Documentation/arm64/elf_hwcaps.txt
> +++ b/Documentation/arm64/elf_hwcaps.txt
> @@ -158,3 +158,9 @@ HWCAP_SHA512
>  HWCAP_SVE
>  
>      Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001.
> +
> +HWCAP_APIA
> +
> +    EL0 AddPac and Auth functionality using APIAKey_EL1 is enabled, as
> +    described by Documentation/arm64/pointer-authentication.txt.
> +
> diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
> new file mode 100644
> index 000000000000..e9b5c6bdb84f
> --- /dev/null
> +++ b/Documentation/arm64/pointer-authentication.txt
> @@ -0,0 +1,85 @@
> +Pointer authentication in AArch64 Linux
> +=======================================
> +
> +Author: Mark Rutland <mark.rutland@arm.com>
> +Date: 2017-07-19
> +
> +This document briefly describes the provision of pointer authentication
> +functionality in AArch64 Linux.
> +
> +
> +Architecture overview
> +---------------------
> +
> +The ARMv8.3 Pointer Authentication extension adds primitives that can be
> +used to mitigate certain classes of attack where an attacker can corrupt
> +the contents of some memory (e.g. the stack).
> +
> +The extension uses a Pointer Authentication Code (PAC) to determine
> +whether pointers have been modified unexpectedly. A PAC is derived from
> +a pointer, another value (such as the stack pointer), and a secret key
> +held in system registers.
> +
> +The extension adds instructions to insert a valid PAC into a pointer,
> +and to verify/remove the PAC from a pointer. The PAC occupies a number
> +of high-order bits of the pointer, which varies dependent on the
> +configured virtual address size and whether pointer tagging is in use.
> +
> +A subset of these instructions have been allocated from the HINT
> +encoding space. In the absence of the extension (or when disabled),
> +these instructions behave as NOPs. Applications and libraries using
> +these instructions operate correctly regardless of the presence of the
> +extension.

Correctly, but obviously without the additional security. So I assume
it's expected that applications that demand this security to probe for
it themselves, presumably by the checking the HWCAP. Is that correct?

> +
> +
> +Basic support
> +-------------
> +
> +When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and relevant HW
> +support is present, the kernel will assign a random APIAKey value to
> +each process at exec*() time. This key is shared by all threads within
> +the process, and the key is preserved across fork(). Presence of
> +functionality using APIAKey is advertised via HWCAP_APIA.
> +
> +Recent versions of GCC can compile code with APIAKey-based return
> +address protection when passed the -msign-return-address option. This
> +uses instructions in the HINT space, and such code can run on systems
> +without the pointer authentication extension.
> +
> +The remaining instruction and data keys (APIBKey, APDAKey, APDBKey) are
> +reserved for future use, and instructions using these keys must not be
> +used by software until a purpose and scope for their use has been
> +decided. To enable future software using these keys to function on
> +contemporary kernels, where possible, instructions using these keys are
> +made to behave as NOPs.
> +
> +The generic key (APGAKey) is currently unsupported. Instructions using
> +the generic key must not be used by software.
> +
> +
> +Debugging
> +---------
> +
> +When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and relevant HW
> +support is present, the kernel will expose the position of TTBR0 PAC
> +bits in the NT_ARM_PAC_MASK regset (struct user_pac_mask), which
> +userspace can acqure via PTRACE_GETREGSET.
> +
> +Separate masks are exposed for data pointers and instruction pointers,
> +as the set of PAC bits can vary between the two. Debuggers should not
> +expect that HWCAP_APIA implies the presence (or non-presence) of this
> +regset -- in future the kernel may support the use of APIBKey, APDAKey,
> +and/or APBAKey, even in the absence of APIAKey.
> +
> +Note that the masks apply to TTBR0 addresses, and are not valid to apply
> +to TTBR1 addresses (e.g. kernel pointers).
> +
> +
> +Virtualization
> +--------------
> +
> +When CONFIG_ARM64_POINTER_AUTHENTICATION is selected, and uniform HW
> +support is present, KVM will context switch all keys used by vCPUs.
> +Otherwise, the feature is disabled. When disabled, accesses to keys, or
> +use of instructions enabled within the guest will trap to EL2, and an
> +UNDEFINED exception will be injected into the guest.

If host applications will just run, with the instructions behaving like
NOPs, when the extension is either not present or not enabled, then
shouldn't guest applications also just run? I.e. instead of injecting
UNDEF, just treat the instructions as NOPs. Or did I misunderstand the
trapping? Does use of the instructions at EL0 trap to EL1 or EL2?

Thanks,
drew
