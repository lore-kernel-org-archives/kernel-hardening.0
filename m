From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to xonly
Date: Mon, 10 Jun 2019 13:25:31 -0700
Message-Id: <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
In-Reply-To: <cover.1560198181.git.luto@kernel.org>
References: <cover.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

The use case for full emulation over xonly is very esoteric.  Let's
change the default to the safer xonly mode.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 054033cc4b1b..e56f33e6b045 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2280,7 +2280,7 @@ config COMPAT_VDSO
 choice
 	prompt "vsyscall table for legacy applications"
 	depends on X86_64
-	default LEGACY_VSYSCALL_EMULATE
+	default LEGACY_VSYSCALL_XONLY
 	help
 	  Legacy user code that does not know how to find the vDSO expects
 	  to be able to issue three syscalls by calling fixed addresses in
-- 
2.21.0
