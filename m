Date: Wed, 25 Apr 2018 13:27:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCHv3 11/11] arm64: docs: document pointer authentication
Message-ID: <20180425122749.4eqhd2uiofoc7jyv@armageddon.cambridge.arm.com>
References: <20180417183735.56985-1-mark.rutland@arm.com>
 <20180417183735.56985-12-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417183735.56985-12-mark.rutland@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, drjones@redhat.com, cdall@kernel.org, arnd@arndb.de, suzuki.poulose@arm.com, marc.zyngier@arm.com, awallis@codeaurora.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, ramana.radhakrishnan@arm.com, kvmarm@lists.cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 07:37:35PM +0100, Mark Rutland wrote:
> +Basic support
> +-------------
> +
> +When CONFIG_ARM64_PTR_AUTH is selected, and relevant HW support is
> +present, the kernel will assign a random APIAKey value to each process
> +at exec*() time. This key is shared by all threads within the process,
> +and the key is preserved across fork(). Presence of functionality using
> +APIAKey is advertised via HWCAP_APIA.
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
> +When CONFIG_ARM64_PTR_AUTH is selected, and relevant HW support is
> +present, the kernel will expose the position of TTBR0 PAC bits in the
> +NT_ARM_PAC_MASK regset (struct user_pac_mask), which userspace can
> +acqure via PTRACE_GETREGSET.
> +
> +Separate masks are exposed for data pointers and instruction pointers,
> +as the set of PAC bits can vary between the two. Debuggers should not
> +expect that HWCAP_APIA implies the presence (or non-presence) of this
> +regset -- in future the kernel may support the use of APIBKey, APDAKey,
> +and/or APBAKey, even in the absence of APIAKey.
> +
> +Note that the masks apply to TTBR0 addresses, and are not valid to apply
> +to TTBR1 addresses (e.g. kernel pointers).

I'm fine with the rest of the series but I'd like the toolchain guys to
ack the ABI we are exposing (just this document is fine).

> +Virtualization
> +--------------
> +
> +Pointer authentication is not currently supported in KVM guests. KVM
> +will mask the feature bits from ID_AA64ISAR1_EL1, and attempted use of
> +the feature will result in an UNDEFINED exception being injected into
> +the guest.

I suspect at some point we'll see patches for KVM?

-- 
Catalin
