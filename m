Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:49 -0500
Message-Id: <1450364270-12687-12-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 11/12] security: add Kconfig options for PAX_REFCOUNT
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently the Kconfig options for this feature retain the original
naming from Pax/grsecurity.

Signed-off-by: David Windsor <dave@progbits.org>
---
 security/Kconfig | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/security/Kconfig b/security/Kconfig
index bf4ec46..cf08034 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -4,6 +4,78 @@
 
 menu "Security options"
 
+menu "Grsecurity"
+
+config GRKERNSEC
+	bool "Grsecurity"
+	help
+	  If you say Y here, you will be able to configure many features
+	  that will enhance the security of your system.  It is highly
+	  recommended that you say Y here and read through the help
+	  for each option so that you fully understand the features and
+	  can evaluate their usefulness for your machine.
+
+choice
+	prompt "Configuration Method"
+	depends on GRKERNSEC
+	default GRKERNSEC_CONFIG_CUSTOM
+	help
+
+config GRKERNSEC_CONFIG_AUTO
+	bool "Automatic"
+	help
+	  If you choose this configuration method, you'll be able to answer a small
+	  number of simple questions about how you plan to use this kernel.
+	  The settings of grsecurity and PaX will be automatically configured for
+	  the highest commonly-used settings within the provided constraints.
+
+	  If you require additional configuration, custom changes can still be made
+	  from the "custom configuration" menu.
+
+config GRKERNSEC_CONFIG_CUSTOM
+	bool "Custom"
+	help
+	  If you choose this configuration method, you'll be able to configure all
+	  grsecurity and PaX settings manually.  Via this method, no options are
+	  automatically enabled.
+
+	  Take note that if menuconfig is exited with this configuration method
+	  chosen, you will not be able to use the automatic configuration methods
+	  without starting again with a kernel configuration with no grsecurity
+	  or PaX options specified inside.
+
+endchoice
+
+menu "PaX"
+
+menu "Miscellaneous hardening features"
+
+config PAX_REFCOUNT
+	bool "Prevent various kernel object reference counter overflows"
+	default y if GRKERNSEC_CONFIG_AUTO
+	depends on GRKERNSEC && ((ARM && (CPU_V6 || CPU_V6K || CPU_V7)) || MIPS || PPC || SPARC64 || X86)
+	help
+	  By saying Y here the kernel will detect and prevent overflowing
+	  various (but not all) kinds of object reference counters.  Such
+	  overflows can normally occur due to bugs only and are often, if
+	  not always, exploitable.
+
+	  The tradeoff is that data structures protected by an overflowed
+	  refcount will never be freed and therefore will leak memory.  Note
+	  that this leak also happens even without this protection but in
+	  that case the overflow can eventually trigger the freeing of the
+	  data structure while it is still being used elsewhere, resulting
+	  in the exploitable situation that this feature prevents.
+
+	  Since this has a negligible performance impact, you should enable
+	  this feature.
+
+endmenu
+
+endmenu
+
+endmenu
+
 source security/keys/Kconfig
 
 config SECURITY_DMESG_RESTRICT
-- 
2.5.0
