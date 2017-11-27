From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 27 Nov 2017 16:38:05 +0000
Message-Id: <20171127163806.31435-12-mark.rutland@arm.com>
In-Reply-To: <20171127163806.31435-1-mark.rutland@arm.com>
References: <20171127163806.31435-1-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCHv2 11/12] arm64: enable pointer authentication
To: linux-arm-kernel@lists.infradead.org
Cc: arnd@arndb.de, catalin.marinas@arm.com, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, marc.zyngier@arm.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, yao.qi@arm.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, awallis@codeaurora.org
List-ID: <kernel-hardening.lists.openwall.com>

Now that all the necessary bits are in place for userspace / KVM guest
pointer authentication, add the necessary Kconfig logic to allow this to
be enabled.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a93339f5178f..f7cb4ca8a6fc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1013,6 +1013,29 @@ config ARM64_PMEM
 
 endmenu
 
+menu "ARMv8.3 architectural features"
+
+config ARM64_POINTER_AUTHENTICATION
+	bool "Enable support for pointer authentication"
+	default y
+	help
+	  Pointer authentication (part of the ARMv8.3 Extensions) provides
+	  instructions for signing and authenticating pointers against secret
+	  keys, which can be used to mitigate Return Oriented Programming (ROP)
+	  and other attacks.
+
+	  This option enables these instructions at EL0 (i.e. for userspace).
+
+	  Choosing this option will cause the kernel to initialise secret keys
+	  for each process at exec() time, with these keys being
+	  context-switched along with the process.
+
+	  The feature is detected at runtime. If the feature is not present in
+	  hardware it will not be advertised to userspace nor will it be
+	  enabled.
+
+endmenu
+
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-- 
2.11.0
