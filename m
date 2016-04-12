Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Apr 2016 15:16:59 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160412221659.GA18102@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@denx.de>, "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Since kASLR and Hibernation can not currently coexist at runtime
on x86, the default behavior was to disable kASLR by default when
CONFIG_HIBERNATION was present (to retain original behavior).

The behavior of kASLR on arm64 (and soon MIPS) is to be enabled by
default when selected at build time. Since arm64 Hibernation does not
conflict with kASLR, this fixes the hibernation argument parsing to be
x86-specific. Additionally, since end users want to be able to select
kASLR on x86 by default at build time, create CONFIG_RANDOMIZE_BASE_ON
that is present only on x86.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
- make this x86-specific selectable, rather than global default
---
 Documentation/kernel-parameters.txt |  9 +++------
 arch/x86/Kconfig                    | 16 +++++++++++++++-
 arch/x86/boot/compressed/aslr.c     |  2 +-
 kernel/power/hibernate.c            | 31 +++++++++++++++++++++++++------
 4 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ecc74fa4bfde..282e5c826c32 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1770,12 +1770,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joystick.txt.
 
-	kaslr/nokaslr	[X86]
-			Enable/disable kernel and module base offset ASLR
-			(Address Space Layout Randomization) if built into
-			the kernel. When CONFIG_HIBERNATION is selected,
-			kASLR is disabled by default. When kASLR is enabled,
-			hibernation will be disabled.
+	kaslr/nokaslr	[KNL] When CONFIG_RANDOMIZE_BASE is set, this
+			enables/disables kernel and module base offset ASLR
+			(Address Space Layout Randomization).
 
 	keepinitrd	[HW,ARM]
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2dc18605831f..e0fb1717fe3c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1932,7 +1932,7 @@ config RELOCATABLE
 	  (CONFIG_PHYSICAL_START) is used as the minimum location.
 
 config RANDOMIZE_BASE
-	bool "Randomize the address of the kernel image"
+	bool "Randomize the address of the kernel image (kASLR)"
 	depends on RELOCATABLE
 	default n
 	---help---
@@ -1955,6 +1955,20 @@ config RANDOMIZE_BASE
 
 	   If unsure, say N.
 
+config RANDOMIZE_BASE_ON
+	bool "Prefer kASLR over Hibernation"
+	depends on RANDOMIZE_BASE
+	depends on HIBERNATION
+	default n
+	---help---
+	  Currently Hibernation and kASLR are not compatible at runtime
+	  on x86. To enable kASLR by default (and disable Hibernation),
+	  enable this option. To enable Hibernation by default (and
+	  disable kASLR), disable this option. Regardless of this
+	  setting, the availability of kASLR (and therefore Hibernation)
+	  can be chosen at boot time with the "kaslr" or "nokaslr"
+	  kernel argument.
+
 config RANDOMIZE_BASE_MAX_OFFSET
 	hex "Maximum kASLR offset allowed" if EXPERT
 	depends on RANDOMIZE_BASE
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 6a9b96b4624d..8214b174b9bd 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -304,7 +304,7 @@ unsigned char *choose_kernel_location(struct boot_params *boot_params,
 	unsigned long choice = (unsigned long)output;
 	unsigned long random;
 
-#ifdef CONFIG_HIBERNATION
+#ifndef CONFIG_RANDOMIZE_BASE_ON
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
 		goto out;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fca9254280ee..526a6403fb2e 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -35,8 +35,13 @@
 
 
 static int nocompress;
+#ifndef CONFIG_RANDOMIZE_BASE_ON
 static int noresume;
 static int nohibernate;
+#else
+static int noresume = 1;
+static int nohibernate = 1;
+#endif
 static int resume_wait;
 static unsigned int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
@@ -1154,11 +1159,6 @@ static int __init nohibernate_setup(char *str)
 	return 1;
 }
 
-static int __init kaslr_nohibernate_setup(char *str)
-{
-	return nohibernate_setup(str);
-}
-
 static int __init page_poison_nohibernate_setup(char *str)
 {
 #ifdef CONFIG_PAGE_POISONING_ZERO
@@ -1175,6 +1175,26 @@ static int __init page_poison_nohibernate_setup(char *str)
 	return 1;
 }
 
+/*
+ * Hibernation on x86 currently conflicts with kASLR, so only change
+ * hibernation boot defaults when seeing kaslr arguments on x86.
+ */
+#if defined(CONFIG_X86) && defined(CONFIG_RANDOMIZE_BASE)
+static int __init kaslr_nohibernate_setup(char *str)
+{
+	return nohibernate_setup(str);
+}
+
+static int __init nokaslr_hibernate_setup(char *str)
+{
+	noresume = 0;
+	nohibernate = 0;
+	return 1;
+}
+__setup("kaslr", kaslr_nohibernate_setup);
+__setup("nokaslr", nokaslr_hibernate_setup);
+#endif
+
 __setup("noresume", noresume_setup);
 __setup("resume_offset=", resume_offset_setup);
 __setup("resume=", resume_setup);
@@ -1182,5 +1202,4 @@ __setup("hibernate=", hibernate_setup);
 __setup("resumewait", resumewait_setup);
 __setup("resumedelay=", resumedelay_setup);
 __setup("nohibernate", nohibernate_setup);
-__setup("kaslr", kaslr_nohibernate_setup);
 __setup("page_poison=", page_poison_nohibernate_setup);
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
