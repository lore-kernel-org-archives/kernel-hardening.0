References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
 <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
 <20170721170523.GD1538@e103592.cambridge.arm.com>
From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Message-ID: <fcf947a4-3670-3b1e-fc5a-f5da8a58e7ba@arm.com>
Date: Mon, 24 Jul 2017 11:47:29 +0100
MIME-Version: 1.0
In-Reply-To: <20170721170523.GD1538@e103592.cambridge.arm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 01/11] arm64: docs: describe ELF hwcaps
To: Dave Martin <Dave.Martin@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, arnd@arndb.de, jiong.wang@arm.com, marc.zyngier@arm.com, catalin.marinas@arm.com, yao.qi@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
List-ID: <kernel-hardening.lists.openwall.com>

On 21/07/17 18:05, Dave Martin wrote:
> On Wed, Jul 19, 2017 at 05:01:22PM +0100, Mark Rutland wrote:
>> We don't document our ELF hwcaps, leaving developers to interpret them
>> according to hearsay, guesswork, or (in exceptional cases) inspection of
>> the current kernel code.
>>
>> This is less than optimal, and it would be far better if we had some
>> definitive description of each of the ELF hwcaps that developers could
>> refer to.
>>
>> This patch adds a document describing the (native) arm64 ELF hwcaps.
>
> Minor nit: what do the hwcaps have to do with ELF really?  Can we just
> call them "hwcaps"?
>
> I'm not sure of the history here.

Dave,

This is something that I requested to avoid confusing it with the CPU hwcaps,
(stored in the variable named hwcaps), we maintain in the kernel for capabilities.
Though, what we describe in this document is not specific to ELF format as
you have mentioned, it is easy to get confused with the former.

>
>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> ---
>>  Documentation/arm64/elf_hwcaps.txt | 133 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 133 insertions(+)
>>  create mode 100644 Documentation/arm64/elf_hwcaps.txt
>>
>> diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
>> new file mode 100644
>> index 0000000..7bc2921
>> --- /dev/null
>> +++ b/Documentation/arm64/elf_hwcaps.txt
>> @@ -0,0 +1,133 @@
>> +ARM64 ELF hwcaps
>> +================
>> +
>> +This document describes the usage and semantics of the arm64 ELF hwcaps.
>> +
>> +
>> +1. Introduction
>> +---------------
>> +
>> +Some hardware or software features are only available on some CPU
>> +implementations, and/or with certain kernel configurations, but have no
>> +architected discovery mechanism available to userspace code at EL0. The
>> +kernel exposes the presence of these features to userspace through a set
>> +of flags called hwcaps, exposed in the auxilliary vector.
>> +
>> +Userspace software can test for features by acquiring the AT_HWCAP entry
>> +of the auxilliary vector, and testing whether the relevant flags are
>> +set, e.g.
>> +
>> +bool floating_point_is_present(void)
>> +{
>> +	unsigned long hwcaps = getauxval(AT_HWCAP);
>> +	if (hwcaps & HWCAP_FP)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>> +Where software relies on a feature described by a hwcap, it should check
>> +the relevant hwcap flag to verify that the feature is present before
>> +attempting to make use of the feature.
>> +
>> +Features cannot be probed reliably through other means. When a feature
>> +is not available, attempting to use it may result in unpredictable
>
> This says that features cannot be probed reliably via the (emulated) ID
> registers available with HWCAP_CPUID.
>
> So, what use is the ID register emulation?
>
> For each of hwcaps and cpuid, a particular feature may be reported as
> present (y), absent (n), or not described at all (x):
>
> hwcap>    x n y
> cpuid:
>    x      N N Y
>    n      N N
>    y      Y   Y
>
> I've filled in the straightforward cases, where software may (Y) or must
> not (N) use the feature.
>
> In the cases left blank, hwcap and cpuid disagree.
>
> Are we confident that should never be observed -- i.e., it's a kernel
> bug if seen?  If so, we can fill Ys in there.  But we need to be clear

CPUID=> n and HWCAP=> Y is Kernel bug, indeed, as both HWCAP and CPUID uses the
same underlying data for the decision. However, the other case is a bit complicated,
depending on whether we decide to continue adding (we do add at the moment) "new HWCAP"
bits for the newer features.
If we do add the new HWCAPs, that could possible create conflicts on older kernels
which doesn't know about the feature, while the CPUID could expose the feature.
If we don't add the HWCAP, there is no reliable way for the userspace to decide if
the kernel supports the feature or not.

So, in either case, we need to cap the value exposed by CPUID to the "kernel supported
feature level" to avoid problems like this.

Thoughts ?

Suzuki



> about cases where the hwcap doesn't mean exactly the same as the
> corresponding CPUID feature.  The hwcap may tell software it can assume
> that certain kernel ABI extensions related to that CPU feature are
> available for example.
>
> This also affects how HWCAP_CPUID is described below.
>
> [...]
>
> Cheers
> ---Dave
>
