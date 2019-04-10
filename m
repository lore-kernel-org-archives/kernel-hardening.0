Date: Wed, 10 Apr 2019 15:17:24 +0200
In-Reply-To: <20190410131726.250295-1-glider@google.com>
Message-Id: <20190410131726.250295-2-glider@google.com>
Mime-Version: 1.0
References: <20190410131726.250295-1-glider@google.com>
Subject: [PATCH v4 1/3] initmem: introduce CONFIG_INIT_ALL_MEMORY and CONFIG_INIT_ALL_STACK
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
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
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-security-module@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v2:
  - addressed Kees Cook's comments: added GCC support
 v3: addressed Masahiro Yamada's comments:
  - dropped per-file opt-out mechanism
  - fixed GCC_PLUGINS dependencies
 v4:
  - addressed Randy Dunlap's comments: remove redundant "depends on"
  - addressed Masahiro Yamada's comments: drop Makefile.initmem
---
 Makefile                 | 10 ++++++++++
 security/Kconfig         |  1 +
 security/Kconfig.initmem | 28 ++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)
 create mode 100644 security/Kconfig.initmem

diff --git a/Makefile b/Makefile
index 15c8251d4d5e..02f4b9df0102 100644
--- a/Makefile
+++ b/Makefile
@@ -727,6 +727,16 @@ KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
 # See modpost pattern 2
 KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
 KBUILD_CFLAGS += $(call cc-option, -fcatch-undefined-behavior)
+
+ifdef CONFIG_INIT_ALL_STACK
+# Clang's -ftrivial-auto-var-init=pattern flag initializes the
+# uninitialized parts of local variables (including fields and padding)
+# with a fixed pattern (0xAA in most cases).
+ifdef CONFIG_CC_HAS_AUTO_VAR_INIT
+KBUILD_CFLAGS += -ftrivial-auto-var-init=pattern
+endif
+endif
+
 else
 
 # These warnings generated too much noise in a regular build.
diff --git a/security/Kconfig b/security/Kconfig
index 353cfef71d4e..4d27437c2eb8 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -229,6 +229,7 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+source "security/Kconfig.initmem"
 source "security/selinux/Kconfig"
 source "security/smack/Kconfig"
 source "security/tomoyo/Kconfig"
diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
new file mode 100644
index 000000000000..cdad1e185b10
--- /dev/null
+++ b/security/Kconfig.initmem
@@ -0,0 +1,28 @@
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
