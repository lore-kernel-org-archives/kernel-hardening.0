Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 6 Apr 2016 12:44:04 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160406194404.GA11150@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] Prefer kASLR over Hibernation
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When building with both CONFIG_HIBERNATION and CONFIG_RANDOMIZE_BASE,
one or the other must be chosen at boot-time. Until now, hibernation
was selected when no choice was made on the command line.

To make the security benefits of kASLR more widely available to end
users (since the use of hibernation is becoming more rare and kASLR,
already available on x86, will be available on arm64 and MIPS soon),
this changes the default to preferring kASLR over hibernation. Users
wanting hibernation can turn off kASLR by adding "nokaslr" to the kernel
command line.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/kernel-parameters.txt |  7 +++++--
 arch/x86/boot/compressed/aslr.c     |  7 -------
 kernel/power/hibernate.c            | 13 +++++++++++++
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ecc74fa4bfde..71393ec89295 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1774,8 +1774,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Enable/disable kernel and module base offset ASLR
 			(Address Space Layout Randomization) if built into
 			the kernel. When CONFIG_HIBERNATION is selected,
-			kASLR is disabled by default. When kASLR is enabled,
-			hibernation will be disabled.
+			kASLR must be disabled for hibernation to be
+			available.
 
 	keepinitrd	[HW,ARM]
 
@@ -3513,6 +3513,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			(e.g. USB and MMC devices).
 
 	hibernate=	[HIBERNATION]
+			When CONFIG_RANDOMIZE_BASE is defined, hibernation
+			is disabled by default. Hibernation can be enabled
+			by passing "nokaslr" on the kernel command line.
 		noresume	Don't check if there's a hibernation image
 				present during boot.
 		nocompress	Don't compress/decompress hibernation images.
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 6a9b96b4624d..81e2835c0dfb 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -304,17 +304,10 @@ unsigned char *choose_kernel_location(struct boot_params *boot_params,
 	unsigned long choice = (unsigned long)output;
 	unsigned long random;
 
-#ifdef CONFIG_HIBERNATION
-	if (!cmdline_find_option_bool("kaslr")) {
-		debug_putstr("KASLR disabled by default...\n");
-		goto out;
-	}
-#else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
 		goto out;
 	}
-#endif
 
 	boot_params->hdr.loadflags |= KASLR_FLAG;
 
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fca9254280ee..be5041354b1e 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -35,8 +35,13 @@
 
 
 static int nocompress;
+#ifdef CONFIG_RANDOMIZE_BASE
+static int noresume = 1;
+static int nohibernate = 1;
+#else
 static int noresume;
 static int nohibernate;
+#endif
 static int resume_wait;
 static unsigned int resume_delay;
 static char resume_file[256] = CONFIG_PM_STD_PARTITION;
@@ -1159,6 +1164,13 @@ static int __init kaslr_nohibernate_setup(char *str)
 	return nohibernate_setup(str);
 }
 
+static int __init nokaslr_hibernate_setup(char *str)
+{
+	noresume = 0;
+	nohibernate = 0;
+	return 1;
+}
+
 static int __init page_poison_nohibernate_setup(char *str)
 {
 #ifdef CONFIG_PAGE_POISONING_ZERO
@@ -1183,4 +1195,5 @@ __setup("resumewait", resumewait_setup);
 __setup("resumedelay=", resumedelay_setup);
 __setup("nohibernate", nohibernate_setup);
 __setup("kaslr", kaslr_nohibernate_setup);
+__setup("nokaslr", nokaslr_hibernate_setup);
 __setup("page_poison=", page_poison_nohibernate_setup);
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
