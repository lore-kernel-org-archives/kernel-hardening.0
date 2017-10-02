From: Kees Cook <keescook@chromium.org>
Date: Mon,  2 Oct 2017 12:20:07 -0700
Message-Id: <1506972007-80614-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1506972007-80614-1-git-send-email-keescook@chromium.org>
References: <1506972007-80614-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 3/3] Makefile: Introduce CONFIG_CC_STACKPROTECTOR_AUTO
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <mmarek@suse.com>, Ingo Molnar <mingo@kernel.org>, Laura Abbott <labbott@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, linux-kbuild@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Nearly all modern compilers support a stack-protector option, and nearly
all modern distributions enable the kernel stack-protector, so enabling
this by default in kernel builds would make sense. However, Kconfig does
not have knowledge of available compiler features, so it isn't safe to
force on, as this would unconditionally break builds for the compilers
or architectures that don't have support. Instead, this introduces a new
option, CONFIG_CC_STACKPROTECTOR_AUTO, which attempts to discover the best
possible stack-protector available, and will allow builds to proceed even
if the compiler doesn't support any stack-protector.

This option is made the default so that kernels built with modern
compilers will be protected-by-default against stack buffer overflows,
avoiding things like the recent BlueBorne attack. Selection of a specific
stack-protector option remains available, including disabling it.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile     | 11 +++++++++++
 arch/Kconfig |  8 +++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e122a9cf0399..9bd334b35003 100644
--- a/Makefile
+++ b/Makefile
@@ -676,6 +676,10 @@ endif
 # This selects the stack protector compiler flag. Testing it is delayed
 # until after .config has been reprocessed, in the prepare-compiler-check
 # target.
+ifdef CONFIG_CC_STACKPROTECTOR_AUTO
+  stackp-flag := $(call cc-option,-fstack-protector-strong,$(call cc-option,-fstack-protector))
+  stackp-name := AUTO
+else
 ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
   stackp-flag := -fstack-protector
   stackp-name := REGULAR
@@ -688,6 +692,7 @@ else
   stackp-flag := $(call cc-option, -fno-stack-protector)
 endif
 endif
+endif
 ifdef stackp-name
   # If the stack protector has been selected, inform the rest of the build.
   KBUILD_CFLAGS += -DCONFIG_CC_STACKPROTECTOR
@@ -1084,6 +1089,12 @@ PHONY += prepare-compiler-check
 prepare-compiler-check: FORCE
 # Make sure compiler supports requested stack protector flag.
 ifdef stackp-name
+  # Warn about CONFIG_CC_STACKPROTECTOR_AUTO having found no option.
+  ifeq ($(stackp-flag),)
+	@echo CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
+		  Compiler does not support any known stack-protector >&2
+  endif
+  # Fail if specifically requested stack protector is missing.
   ifeq ($(call cc-option, $(stackp-flag)),)
 	@echo Cannot use CONFIG_CC_STACKPROTECTOR_$(stackp-name): \
 		  $(stackp-flag) not supported by compiler >&2 && exit 1
diff --git a/arch/Kconfig b/arch/Kconfig
index 7007c1bfa79c..cd2676ff5d5d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -526,7 +526,7 @@ config HAVE_CC_STACKPROTECTOR
 choice
 	prompt "Stack Protector buffer overflow detection"
 	depends on HAVE_CC_STACKPROTECTOR
-	default CC_STACKPROTECTOR_NONE
+	default CC_STACKPROTECTOR_AUTO
 	help
 	  This option turns on the "stack-protector" GCC feature. This
 	  feature puts, at the beginning of functions, a canary value on
@@ -573,6 +573,12 @@ config CC_STACKPROTECTOR_STRONG
 	  about 20% of all kernel functions, which increases the kernel code
 	  size by about 2%.
 
+config CC_STACKPROTECTOR_AUTO
+	bool "Automatic"
+	help
+	  If the compiler supports it, the best available stack-protector
+	  option will be chosen.
+
 endchoice
 
 config THIN_ARCHIVES
-- 
2.7.4
