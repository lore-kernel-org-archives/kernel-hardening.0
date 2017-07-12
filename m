From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:19 +0100
Message-Id: <20170712144424.19528-7-ard.biesheuvel@linaro.org>
In-Reply-To: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
References: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 06/10] arm64: kbuild: reserve reg x18 from general allocation by the compiler
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Before we can start using register x18 for a special purpose (as permitted
by the AAPCS64 ABI), we need to tell the compiler that it is off limits
for general allocation. So tag it as 'fixed', and remove the mention from
the LL/SC compiler flag override.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile     | 2 +-
 arch/arm64/lib/Makefile | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 9b41f1e3b1a0..68164338185a 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -46,7 +46,7 @@ $(warning Detected assembler with broken .inst; disassembly will be unreliable)
 endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
-KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
+KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables -ffixed-x18
 KBUILD_CFLAGS	+= $(call cc-option, -mpc-relative-literal-loads)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
 
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index c86b7909ef31..b52f34fd5ba5 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -15,5 +15,4 @@ CFLAGS_atomic_ll_sc.o	:= -fcall-used-x0 -ffixed-x1 -ffixed-x2		\
 		   -ffixed-x3 -ffixed-x4 -ffixed-x5 -ffixed-x6		\
 		   -ffixed-x7 -fcall-saved-x8 -fcall-saved-x9		\
 		   -fcall-saved-x10 -fcall-saved-x11 -fcall-saved-x12	\
-		   -fcall-saved-x13 -fcall-saved-x14 -fcall-saved-x15	\
-		   -fcall-saved-x18
+		   -fcall-saved-x13 -fcall-saved-x14 -fcall-saved-x15
-- 
2.9.3
