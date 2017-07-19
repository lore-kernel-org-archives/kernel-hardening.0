From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 19 Jul 2017 17:01:22 +0100
Message-Id: <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 01/11] arm64: docs: describe ELF hwcaps
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@linaro.org, Dave.Martin@arm.com, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

We don't document our ELF hwcaps, leaving developers to interpret them
according to hearsay, guesswork, or (in exceptional cases) inspection of
the current kernel code.

This is less than optimal, and it would be far better if we had some
definitive description of each of the ELF hwcaps that developers could
refer to.

This patch adds a document describing the (native) arm64 ELF hwcaps.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 Documentation/arm64/elf_hwcaps.txt | 133 +++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)
 create mode 100644 Documentation/arm64/elf_hwcaps.txt

diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
new file mode 100644
index 0000000..7bc2921
--- /dev/null
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -0,0 +1,133 @@
+ARM64 ELF hwcaps
+================
+
+This document describes the usage and semantics of the arm64 ELF hwcaps.
+
+
+1. Introduction
+---------------
+
+Some hardware or software features are only available on some CPU
+implementations, and/or with certain kernel configurations, but have no
+architected discovery mechanism available to userspace code at EL0. The
+kernel exposes the presence of these features to userspace through a set
+of flags called hwcaps, exposed in the auxilliary vector.
+
+Userspace software can test for features by acquiring the AT_HWCAP entry
+of the auxilliary vector, and testing whether the relevant flags are
+set, e.g.
+
+bool floating_point_is_present(void)
+{
+	unsigned long hwcaps = getauxval(AT_HWCAP);
+	if (hwcaps & HWCAP_FP)
+		return true;
+
+	return false;
+}
+
+Where software relies on a feature described by a hwcap, it should check
+the relevant hwcap flag to verify that the feature is present before
+attempting to make use of the feature.
+
+Features cannot be probed reliably through other means. When a feature
+is not available, attempting to use it may result in unpredictable
+behaviour, and is not guaranteed to result in any reliable indication
+that the feature is unavailable, such as a SIGILL.
+
+
+2. Interpretation of hwcaps
+---------------------------
+
+The majority of hwcaps are intended to indicate the presence of features
+which are described by architected ID registers inaccessible to
+userspace code at EL0. These hwcaps are defined in terms of ID register
+fields, and should be interpreted with reference to the definition of
+these fields in the ARM Architecture Reference Manual (ARM ARM).
+
+Such hwcaps are described below in the form:
+
+    Functionality implied by idreg.field == val.
+
+Such hwcaps indicate the availability of functionality that the ARM ARM
+defines as being present when idreg.field has value val, but do not
+indicate that idreg.field is precisely equal to val, nor do they
+indicate the absence of functionality implied by other values of
+idreg.field.
+
+Other hwcaps may indicate the presence of features which cannot be
+described by ID registers alone. These may be described without
+reference to ID registers, and may refer to other documentation.
+
+
+3. The hwcaps exposed in AT_HWCAP
+---------------------------------
+
+HWCAP_FP
+
+    Functionality implied by ID_AA64PFR0_EL1.FP == 0b0000.
+
+HWCAP_ASIMD
+
+    Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0000.
+
+HWCAP_EVTSTRM
+
+    The generic timer is configured to generate events at a frequency of
+    approximately 100KHz.
+
+HWCAP_AES
+
+    Functionality implied by ID_AA64ISAR1_EL1.AES == 0b0001.
+
+HWCAP_PMULL
+
+    Functionality implied by ID_AA64ISAR1_EL1.AES == 0b0010.
+
+HWCAP_SHA1
+
+    Functionality implied by ID_AA64ISAR0_EL1.SHA1 == 0b0001.
+
+HWCAP_SHA2
+
+    Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0001.
+
+HWCAP_CRC32
+
+    Functionality implied by ID_AA64ISAR0_EL1.CRC32 == 0b0001.
+
+HWCAP_ATOMICS
+
+    Functionality implied by ID_AA64ISAR0_EL1.Atomic == 0b0010.
+
+HWCAP_FPHP
+
+    Functionality implied by ID_AA64PFR0_EL1.FP == 0b0001.
+
+HWCAP_ASIMDHP
+
+    Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0001.
+
+HWCAP_CPUID
+
+    EL0 access to certain ID registers is available, to the extent
+    described by Documentation/arm64/cpu-feature-registers.txt.
+
+    These ID registers may imply the availability of features.
+
+HWCAP_ASIMDRDM
+
+    Functionality implied by ID_AA64ISAR0_EL1.RDM == 0b0001.
+
+HWCAP_JSCVT
+
+    Functionality implied by ID_AA64ISAR1_EL1.JSCVT == 0b0001.
+
+HWCAP_FCMA
+
+    Functionality implied by ID_AA64ISAR1_EL1.FCMA == 0b0001.
+
+HWCAP_LRCPC
+
+    Functionality implied by ID_AA64ISAR1_EL1.LRCPC == 0b0001.
+
-- 
1.9.1
