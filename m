From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 3/3] security: Implement Clang's stack initialization
Date: Thu, 11 Apr 2019 11:01:17 -0700
Message-Id: <20190411180117.27704-4-keescook@chromium.org>
In-Reply-To: <20190411180117.27704-1-keescook@chromium.org>
References: <20190411180117.27704-1-keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

CONFIG_INIT_STACK_ALL turns on stack initialization based on
-ftrivial-auto-var-init in Clang builds, which has greater coverage
than CONFIG_GCC_PLUGINS_STRUCTLEAK_BYREF_ALL.

-ftrivial-auto-var-init Clang option provides trivial initializers for
uninitialized local variables, variable fields and padding.

It has three possible values:
  pattern - uninitialized locals are filled with a fixed pattern
    (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D54604
    for more details, but 0x000000AA for 32-bit pointers) likely to cause
    crashes when uninitialized value is used;
  zero (it's still debated whether this flag makes it to the official
    Clang release) - uninitialized locals are filled with zeroes;
  uninitialized (default) - uninitialized locals are left intact.

This patch uses only the "pattern" mode when CONFIG_INIT_STACK_ALL is
enabled.

Developers have the possibility to opt-out of this feature on a
per-variable basis by using __attribute__((uninitialized)), but such
use should be well justified in comments.

Co-developed-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile                   |  5 +++++
 security/Kconfig.hardening | 15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c0a34064c574..a7d9c6cd0267 100644
--- a/Makefile
+++ b/Makefile
@@ -745,6 +745,11 @@ KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 endif
 
+# Initialize all stack variables with a pattern, if desired.
+ifdef CONFIG_INIT_STACK_ALL
+KBUILD_CFLAGS	+= -ftrivial-auto-var-init=pattern
+endif
+
 DEBUG_CFLAGS	:= $(call cc-option, -fno-var-tracking-assignments)
 
 ifdef CONFIG_DEBUG_INFO
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 3dd7a28c3822..5dd61770d3f0 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -18,9 +18,12 @@ config GCC_PLUGIN_STRUCTLEAK
 
 menu "Memory initialization"
 
+config CC_HAS_AUTO_VAR_INIT
+	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
+
 choice
 	prompt "Initialize kernel stack variables at function entry"
-	depends on GCC_PLUGINS
+	depends on CC_HAS_AUTO_VAR_INIT || GCC_PLUGINS
 	default INIT_STACK_NONE
 	help
 	  This option enables initialization of stack variables at
@@ -76,6 +79,16 @@ choice
 		  of uninitialized stack variable exploits and information
 		  exposures.
 
+	config INIT_STACK_ALL
+		bool "0xAA-init everything on the stack (strongest)"
+		depends on CC_HAS_AUTO_VAR_INIT
+		help
+		  Initializes everything on the stack with a 0xAA
+		  pattern. This is intended to eliminate all classes
+		  of uninitialized stack variable exploits and information
+		  exposures, even variables that were warned to have been
+		  left uninitialized.
+
 endchoice
 
 config GCC_PLUGIN_STRUCTLEAK_VERBOSE
-- 
2.17.1
