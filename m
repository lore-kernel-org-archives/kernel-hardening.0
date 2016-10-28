Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 28 Oct 2016 18:27:16 +0100
Message-Id: <1477675636-3957-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
References: <1477675636-3957-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v4 8/8] arm64: Enable CONFIG_ARM64_SW_TTBR0_PAN
To: linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Sami Tolvanen <samitolvanen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch adds the Kconfig option to enable support for TTBR0 PAN
emulation. The option is default off because of a slight performance hit
when enabled, caused by the additional TTBR0_EL1 switching during user
access operations or exception entry/exit code.

Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 969ef880d234..6b9a8446fc43 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -790,6 +790,14 @@ config SETEND_EMULATION
 	  If unsure, say Y
 endif
 
+config ARM64_SW_TTBR0_PAN
+	bool "Emulate Privileged Access Never using TTBR0_EL1 switching"
+	help
+	  Enabling this option prevents the kernel from accessing
+	  user-space memory directly by pointing TTBR0_EL1 to a reserved
+	  zeroed area and reserved ASID. The user access routines
+	  restore the valid TTBR0_EL1 temporarily.
+
 menu "ARMv8.1 architectural features"
 
 config ARM64_HW_AFDBM
