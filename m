Reply-To: kernel-hardening@lists.openwall.com
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 26 Jan 2016 18:10:41 +0100
Message-Id: <1453828249-14467-15-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1453828249-14467-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 14/22] arm64: make asm/elf.h available to asm files
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com, christoffer.dall@linaro.org, labbott@fedoraproject.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This reshuffles some code in asm/elf.h and puts a #ifndef __ASSEMBLY__
around its C definitions so that the CPP defines can be used in asm
source files as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/elf.h | 22 ++++++++++++--------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index faad6df49e5b..435f55952e1f 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -24,15 +24,6 @@
 #include <asm/ptrace.h>
 #include <asm/user.h>
 
-typedef unsigned long elf_greg_t;
-
-#define ELF_NGREG (sizeof(struct user_pt_regs) / sizeof(elf_greg_t))
-#define ELF_CORE_COPY_REGS(dest, regs)	\
-	*(struct user_pt_regs *)&(dest) = (regs)->user_regs;
-
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-typedef struct user_fpsimd_state elf_fpregset_t;
-
 /*
  * AArch64 static relocation types.
  */
@@ -127,6 +118,17 @@ typedef struct user_fpsimd_state elf_fpregset_t;
  */
 #define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
 
+#ifndef __ASSEMBLY__
+
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof(struct user_pt_regs) / sizeof(elf_greg_t))
+#define ELF_CORE_COPY_REGS(dest, regs)	\
+	*(struct user_pt_regs *)&(dest) = (regs)->user_regs;
+
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+typedef struct user_fpsimd_state elf_fpregset_t;
+
 /*
  * When the program starts, a1 contains a pointer to a function to be
  * registered with atexit, as per the SVR4 ABI.  A value of 0 means we have no
@@ -186,4 +188,6 @@ extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 
 #endif /* CONFIG_COMPAT */
 
+#endif /* !__ASSEMBLY__ */
+
 #endif
-- 
2.5.0
