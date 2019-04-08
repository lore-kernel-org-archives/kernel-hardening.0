Date: Mon,  8 Apr 2019 19:04:17 +0200
In-Reply-To: <20190408170418.148554-1-glider@google.com>
Message-Id: <20190408170418.148554-2-glider@google.com>
Mime-Version: 1.0
References: <20190408170418.148554-1-glider@google.com>
Subject: [PATCH v3 1/2] initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

CONFIG_INIT_ALL_MEMORY is going to be an umbrella config for options
that force heap and stack initialization.
The rationale behind doing so is to reduce the severity of bugs caused
by using uninitialized memory.

CONFIG_INIT_ALL_STACK turns on stack initialization based on
-ftrivial-auto-var-init in Clang builds and on
-fplugin-arg-structleak_plugin-byref-all in GCC builds.

-ftrivial-auto-var-init is a Clang flag that provides trivial
initializers for uninitialized local variables, variable fields and
padding.

It has three possible values:
  pattern - uninitialized locals are filled with a fixed pattern
    (mostly 0xAA on 64-bit platforms, see https://reviews.llvm.org/D54604
    for more details) likely to cause crashes when uninitialized value is
    used;
  zero (it's still debated whether this flag makes it to the official
    Clang release) - uninitialized locals are filled with zeroes;
  uninitialized (default) - uninitialized locals are left intact.

The proposed config builds the kernel with
-ftrivial-auto-var-init=pattern.

Developers have the possibility to opt-out of this feature on a
per-variable basis by using __attribute__((uninitialized)).

For GCC builds, CONFIG_INIT_ALL_STACK is simply wired up to
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL. No opt-out is possible at the
moment.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sandeep Patil <sspatil@android.com>
Cc: linux-security-module@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v2:
  - addressed Kees Cook's comments: added GCC support
 v3: addressed Masahiro Yamada's comments:
  - dropped per-file opt-out mechanism
  - fixed GCC_PLUGINS dependencies
---
 Makefile                 |  3 ++-
 scripts/Makefile.initmem | 10 ++++++++++
 security/Kconfig         |  1 +
 security/Kconfig.initmem | 29 +++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 scripts/Makefile.initmem
 create mode 100644 security/Kconfig.initmem

diff --git a/Makefile b/Makefile
index f070e0d65186..028ca37878fd 100644
--- a/Makefile
+++ b/Makefile
@@ -448,7 +448,7 @@ export HOSTCXX KBUILD_HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
-export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN
+export CFLAGS_KASAN CFLAGS_KASAN_NOSANITIZE CFLAGS_UBSAN CFLAGS_INITMEM
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
@@ -840,6 +840,7 @@ KBUILD_ARFLAGS := $(call ar-option,D)
 include scripts/Makefile.kasan
 include scripts/Makefile.extrawarn
 include scripts/Makefile.ubsan
+include scripts/Makefile.initmem
 
 # Add any arch overrides and user supplied CPPFLAGS, AFLAGS and CFLAGS as the
 # last assignments
diff --git a/scripts/Makefile.initmem b/scripts/Makefile.initmem
new file mode 100644
index 000000000000..a6253d78fe35
--- /dev/null
+++ b/scripts/Makefile.initmem
@@ -0,0 +1,10 @@
+ifdef CONFIG_INIT_ALL_STACK
+
+# Clang's -ftrivial-auto-var-init=pattern flag initializes the
+# uninitialized parts of local variables (including fields and padding)
+# with a fixed pattern (0xAA in most cases).
+ifdef CONFIG_CC_HAS_AUTO_VAR_INIT
+  CFLAGS_INITMEM := -ftrivial-auto-var-init=pattern
+endif
+
+endif
diff --git a/security/Kconfig b/security/Kconfig
index e4fe2f3c2c65..cc12a39424dd 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -230,6 +230,7 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+source "security/Kconfig.initmem"
 source "security/selinux/Kconfig"
 source "security/smack/Kconfig"
 source "security/tomoyo/Kconfig"
diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
new file mode 100644
index 000000000000..5e49a55382ad
--- /dev/null
+++ b/security/Kconfig.initmem
@@ -0,0 +1,29 @@
+menu "Initialize all memory"
+
+config CC_HAS_AUTO_VAR_INIT
+	def_bool $(cc-option,-ftrivial-auto-var-init=pattern)
+
+config INIT_ALL_MEMORY
+	bool "Initialize all memory"
+	default n
+	help
+	  Enforce memory initialization to mitigate infoleaks and make
+	  the control-flow bugs depending on uninitialized values more
+	  deterministic.
+
+if INIT_ALL_MEMORY
+
+config INIT_ALL_STACK
+	bool "Initialize all stack"
+	depends on INIT_ALL_MEMORY
+	depends on CC_HAS_AUTO_VAR_INIT || (HAVE_GCC_PLUGINS && PLUGIN_HOSTCC != "")
+	select GCC_PLUGINS if !CC_HAS_AUTO_VAR_INIT
+	select GCC_PLUGIN_STRUCTLEAK if !CC_HAS_AUTO_VAR_INIT
+	select GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if !CC_HAS_AUTO_VAR_INIT
+	default y
+	help
+	  Initialize uninitialized stack data with a fixed pattern
+	  (0x00 in GCC, 0xAA in Clang).
+
+endif # INIT_ALL_MEMORY
+endmenu
-- 
2.21.0.392.gf8f6787159e-goog
