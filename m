From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 1/3] security: Create "kernel hardening" config area
Date: Thu, 11 Apr 2019 11:01:15 -0700
Message-Id: <20190411180117.27704-2-keescook@chromium.org>
In-Reply-To: <20190411180117.27704-1-keescook@chromium.org>
References: <20190411180117.27704-1-keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Right now kernel hardening options are scattered around various Kconfig
files. This can be a central place to collect these kinds of options
going forward. This is initially populated with the memory initialization
options from the gcc-plugins.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/Kconfig | 74 +++--------------------------
 security/Kconfig            |  2 +
 security/Kconfig.hardening  | 93 +++++++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 67 deletions(-)
 create mode 100644 security/Kconfig.hardening

diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index 74271dba4f94..84d471dea2b7 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -13,10 +13,11 @@ config HAVE_GCC_PLUGINS
 	  An arch should select this symbol if it supports building with
 	  GCC plugins.
 
-menuconfig GCC_PLUGINS
-	bool "GCC plugins"
+config GCC_PLUGINS
+	bool
 	depends on HAVE_GCC_PLUGINS
 	depends on PLUGIN_HOSTCC != ""
+	default y
 	help
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
@@ -25,6 +26,8 @@ menuconfig GCC_PLUGINS
 
 if GCC_PLUGINS
 
+menu "GCC plugins"
+
 config GCC_PLUGIN_CYC_COMPLEXITY
 	bool "Compute the cyclomatic complexity of a function" if EXPERT
 	depends on !COMPILE_TEST	# too noisy
@@ -66,71 +69,6 @@ config GCC_PLUGIN_LATENT_ENTROPY
 	   * https://grsecurity.net/
 	   * https://pax.grsecurity.net/
 
-config GCC_PLUGIN_STRUCTLEAK
-	bool "Zero initialize stack variables"
-	help
-	  While the kernel is built with warnings enabled for any missed
-	  stack variable initializations, this warning is silenced for
-	  anything passed by reference to another function, under the
-	  occasionally misguided assumption that the function will do
-	  the initialization. As this regularly leads to exploitable
-	  flaws, this plugin is available to identify and zero-initialize
-	  such variables, depending on the chosen level of coverage.
-
-	  This plugin was originally ported from grsecurity/PaX. More
-	  information at:
-	   * https://grsecurity.net/
-	   * https://pax.grsecurity.net/
-
-choice
-	prompt "Coverage"
-	depends on GCC_PLUGIN_STRUCTLEAK
-	default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
-	help
-	  This chooses the level of coverage over classes of potentially
-	  uninitialized variables. The selected class will be
-	  zero-initialized before use.
-
-	config GCC_PLUGIN_STRUCTLEAK_USER
-		bool "structs marked for userspace"
-		help
-		  Zero-initialize any structures on the stack containing
-		  a __user attribute. This can prevent some classes of
-		  uninitialized stack variable exploits and information
-		  exposures, like CVE-2013-2141:
-		  https://git.kernel.org/linus/b9e146d8eb3b9eca
-
-	config GCC_PLUGIN_STRUCTLEAK_BYREF
-		bool "structs passed by reference"
-		help
-		  Zero-initialize any structures on the stack that may
-		  be passed by reference and had not already been
-		  explicitly initialized. This can prevent most classes
-		  of uninitialized stack variable exploits and information
-		  exposures, like CVE-2017-1000410:
-		  https://git.kernel.org/linus/06e7e776ca4d3654
-
-	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
-		bool "anything passed by reference"
-		help
-		  Zero-initialize any stack variables that may be passed
-		  by reference and had not already been explicitly
-		  initialized. This is intended to eliminate all classes
-		  of uninitialized stack variable exploits and information
-		  exposures.
-
-endchoice
-
-config GCC_PLUGIN_STRUCTLEAK_VERBOSE
-	bool "Report forcefully initialized variables"
-	depends on GCC_PLUGIN_STRUCTLEAK
-	depends on !COMPILE_TEST	# too noisy
-	help
-	  This option will cause a warning to be printed each time the
-	  structleak plugin finds a variable it thinks needs to be
-	  initialized. Since not all existing initializers are detected
-	  by the plugin, this can produce false positive warnings.
-
 config GCC_PLUGIN_RANDSTRUCT
 	bool "Randomize layout of sensitive kernel structures"
 	select MODVERSIONS if MODULES
@@ -226,4 +164,6 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
 	bool
 	depends on GCC_PLUGINS && ARM
 
+endmenu
+
 endif
diff --git a/security/Kconfig b/security/Kconfig
index 1d6463fb1450..7aec8d094ce2 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -249,5 +249,7 @@ config LSM
 
 	  If unsure, leave this as the default.
 
+source "security/Kconfig.hardening"
+
 endmenu
 
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
new file mode 100644
index 000000000000..01a119437dfc
--- /dev/null
+++ b/security/Kconfig.hardening
@@ -0,0 +1,93 @@
+menu "Kernel hardening options"
+
+config GCC_PLUGIN_STRUCTLEAK
+	bool
+	help
+	  While the kernel is built with warnings enabled for any missed
+	  stack variable initializations, this warning is silenced for
+	  anything passed by reference to another function, under the
+	  occasionally misguided assumption that the function will do
+	  the initialization. As this regularly leads to exploitable
+	  flaws, this plugin is available to identify and zero-initialize
+	  such variables, depending on the chosen level of coverage.
+
+	  This plugin was originally ported from grsecurity/PaX. More
+	  information at:
+	   * https://grsecurity.net/
+	   * https://pax.grsecurity.net/
+
+menu "Memory initialization"
+
+choice
+	prompt "Initialize kernel stack variables at function entry"
+	depends on GCC_PLUGINS
+	default INIT_STACK_NONE
+	help
+	  This option enables initialization of stack variables at
+	  function entry time. This has the possibility to have the
+	  greatest coverage (since all functions can have their
+	  variables initialized), but the performance impact depends
+	  on the function calling complexity of a given workload's
+	  syscalls.
+
+	  This chooses the level of coverage over classes of potentially
+	  uninitialized variables. The selected class will be
+	  initialized before use in a function.
+
+	config INIT_STACK_NONE
+		bool "no automatic initialization (weakest)"
+		help
+		  Disable automatic stack variable initialization.
+		  This leaves the kernel vulnerable to the standard
+		  classes of uninitialized stack variable exploits
+		  and information exposures.
+
+	config GCC_PLUGIN_STRUCTLEAK_USER
+		bool "zero-init structs marked for userspace (weak)"
+		depends on GCC_PLUGINS
+		select GCC_PLUGIN_STRUCTLEAK
+		help
+		  Zero-initialize any structures on the stack containing
+		  a __user attribute. This can prevent some classes of
+		  uninitialized stack variable exploits and information
+		  exposures, like CVE-2013-2141:
+		  https://git.kernel.org/linus/b9e146d8eb3b9eca
+
+	config GCC_PLUGIN_STRUCTLEAK_BYREF
+		bool "zero-init structs passed by reference (strong)"
+		depends on GCC_PLUGINS
+		select GCC_PLUGIN_STRUCTLEAK
+		help
+		  Zero-initialize any structures on the stack that may
+		  be passed by reference and had not already been
+		  explicitly initialized. This can prevent most classes
+		  of uninitialized stack variable exploits and information
+		  exposures, like CVE-2017-1000410:
+		  https://git.kernel.org/linus/06e7e776ca4d3654
+
+	config GCC_PLUGIN_STRUCTLEAK_BYREF_ALL
+		bool "zero-init anything passed by reference (very strong)"
+		depends on GCC_PLUGINS
+		select GCC_PLUGIN_STRUCTLEAK
+		help
+		  Zero-initialize any stack variables that may be passed
+		  by reference and had not already been explicitly
+		  initialized. This is intended to eliminate all classes
+		  of uninitialized stack variable exploits and information
+		  exposures.
+
+endchoice
+
+config GCC_PLUGIN_STRUCTLEAK_VERBOSE
+	bool "Report forcefully initialized variables"
+	depends on GCC_PLUGIN_STRUCTLEAK
+	depends on !COMPILE_TEST	# too noisy
+	help
+	  This option will cause a warning to be printed each time the
+	  structleak plugin finds a variable it thinks needs to be
+	  initialized. Since not all existing initializers are detected
+	  by the plugin, this can produce false positive warnings.
+
+endmenu
+
+endmenu
-- 
2.17.1
