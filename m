From: Kees Cook <keescook@chromium.org>
Date: Mon,  2 Oct 2017 12:20:06 -0700
Message-Id: <1506972007-80614-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1506972007-80614-1-git-send-email-keescook@chromium.org>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/3] Makefile: Move stackprotector availability out of Kconfig
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kbuild@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Various portions of the kernel, especially per-architecture pieces,
need to know if the compiler is building it with the stack protector.
This was done in the arch/Kconfig with 'select', but this doesn't
allow a way to do auto-detected compiler support. In preparation for
creating an on-if-available default, move the logic for the definition of
CONFIG_CC_STACKPROTECTOR into the Makefile.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile     | 7 +++++--
 arch/Kconfig | 8 --------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index d1119941261c..e122a9cf0399 100644
--- a/Makefile
+++ b/Makefile
@@ -688,8 +688,11 @@ else
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
 endif
-# Find arch-specific stack protector compiler sanity-checking script.
-ifdef CONFIG_CC_STACKPROTECTOR
+ifdef stackp-name
+  # If the stack protector has been selected, inform the rest of the build.
+  KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
+  KBUILD_AFLAGS += -DCONFIG_CC_STACKPROTECTOR
+  # Find arch-specific stack protector compiler sanity-checking script.
   stackp-path := $(srctree)/scripts/gcc-$(SRCARCH)_$(BITS)-has-stack-protector.sh
   stackp-check := $(wildcard $(stackp-path))
 endif
diff --git a/arch/Kconfig b/arch/Kconfig
index 1aafb4efbb51..7007c1bfa79c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -523,12 +523,6 @@ config HAVE_CC_STACKPROTECTOR
 	  - its compiler supports the -fstack-protector option
 	  - it has implemented a stack canary (e.g. __stack_chk_guard)
 
-config CC_STACKPROTECTOR
-	def_bool n
-	help
-	  Set when a stack-protector mode is enabled, so that the build
-	  can enable kernel-side support for the GCC feature.
-
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
@@ -549,7 +543,6 @@ config CC_STACKPROTECTOR_NONE
 
 config CC_STACKPROTECTOR_REGULAR
 	bool "Regular"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added if they
 	  have an 8-byte or larger character array on the stack.
@@ -563,7 +556,6 @@ config CC_STACKPROTECTOR_REGULAR
 
 config CC_STACKPROTECTOR_STRONG
 	bool "Strong"
-	select CC_STACKPROTECTOR
 	help
 	  Functions will have the stack-protector canary logic added in any
 	  of the following conditions:
-- 
2.7.4
