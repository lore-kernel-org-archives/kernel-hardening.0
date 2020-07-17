Return-Path: <SRS0=Dmk2=A4=lists.openwall.com=kernel-hardening-return-19385-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D880C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:02:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C24720704
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C24720704
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19385-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15481 invoked by uid 550); 17 Jul 2020 17:01:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15431 invoked from network); 17 Jul 2020 17:01:44 -0000
IronPort-SDR: GFsYQPCd45DaQ2kMjdaSZImzsjW2xqpmm85m9l2SH7VxLpdrjrzfBGaNw5mG26PCFTRWBC+jsx
 ZLBRw8A9tzAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="148798604"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="148798604"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: WAMcOAZNNxeoO/jWRTcKwIDAi/oBntr2VyGSCK7qxDVIsr7SEY63AmtN7v/zgFYsycubaRV5+S
 LAd4J/8jxJsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="270862244"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jessica Yu <jeyu@kernel.org>
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 10/10] module: Reorder functions
Date: Fri, 17 Jul 2020 10:00:07 -0700
Message-Id: <20200717170008.5949-11-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new config option to allow modules to be re-ordered
by function. This option can be enabled independently of the
kernel text KASLR or FG_KASLR settings so that it can be used
by architectures that do not support either of these features.
This option will be selected by default if CONFIG_FG_KASLR is
selected.

If a module has functions split out into separate text sections
(i.e. compiled with the -ffunction-sections flag), reorder the
functions to provide some code diversification to modules.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/Makefile |  5 +++
 init/Kconfig      | 12 +++++++
 kernel/kallsyms.c |  2 +-
 kernel/module.c   | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 00e378de8bc0..0f2dbc46eb5c 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -51,6 +51,11 @@ ifdef CONFIG_X86_NEED_RELOCS
         LDFLAGS_vmlinux := --emit-relocs --discard-none
 endif
 
+ifndef CONFIG_FG_KASLR
+	ifdef CONFIG_MODULE_FG_KASLR
+		KBUILD_CFLAGS_MODULE += -ffunction-sections
+	endif
+endif
 #
 # Prevent GCC from generating any FP code by mistake.
 #
diff --git a/init/Kconfig b/init/Kconfig
index 82f042a1062f..b4741838da40 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1994,6 +1994,7 @@ config FG_KASLR
 	bool "Function Granular Kernel Address Space Layout Randomization"
 	depends on $(cc-option, -ffunction-sections)
 	depends on ARCH_HAS_FG_KASLR
+	select MODULE_FG_KASLR
 	default n
 	help
 	  This option improves the randomness of the kernel text
@@ -2278,6 +2279,17 @@ config UNUSED_KSYMS_WHITELIST
 	  one per line. The path can be absolute, or relative to the kernel
 	  source tree.
 
+config MODULE_FG_KASLR
+	depends on $(cc-option, -ffunction-sections)
+	bool "Module Function Granular Layout Randomization"
+	help
+	  This option randomizes the module text section by reordering the text
+	  section by function at module load time. In order to use this
+	  feature, the module must have been compiled with the
+	  -ffunction-sections compiler flag.
+
+	  If unsure, say N.
+
 endif # MODULES
 
 config MODULES_TREE_LOOKUP
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 45d147f7f10e..e3f7d0fd3270 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -692,7 +692,7 @@ static int __kallsyms_open(struct inode *inode, struct file *file)
  * When function granular kaslr is enabled, we need to print out the symbols
  * at random so we don't reveal the new layout.
  */
-#if defined(CONFIG_FG_KASLR)
+#if defined(CONFIG_FG_KASLR) || defined(CONFIG_MODULE_FG_KASLR)
 static int update_random_pos(struct kallsyms_shuffled_iter *s_iter,
 			     loff_t pos, loff_t *new_pos)
 {
diff --git a/kernel/module.c b/kernel/module.c
index aa183c9ac0a2..0f4f4e567a42 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -56,6 +56,7 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/random.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -2391,6 +2392,83 @@ static long get_offset(struct module *mod, unsigned int *size,
 	return ret;
 }
 
+/*
+ * shuffle_text_list()
+ * Use a Fisher Yates algorithm to shuffle a list of text sections.
+ */
+static void shuffle_text_list(Elf_Shdr **list, int size)
+{
+	int i;
+	unsigned int j;
+	Elf_Shdr *temp;
+
+	for (i = size - 1; i > 0; i--) {
+		/*
+		 * pick a random index from 0 to i
+		 */
+		get_random_bytes(&j, sizeof(j));
+		j = j % (i + 1);
+
+		temp = list[i];
+		list[i] = list[j];
+		list[j] = temp;
+	}
+}
+
+/*
+ * randomize_text()
+ * Look through the core section looking for executable code sections.
+ * Store sections in an array and then shuffle the sections
+ * to reorder the functions.
+ */
+static void randomize_text(struct module *mod, struct load_info *info)
+{
+	int i;
+	int num_text_sections = 0;
+	Elf_Shdr **text_list;
+	int size = 0;
+	int max_sections = info->hdr->e_shnum;
+	unsigned int sec = find_sec(info, ".text");
+
+	if (sec == 0)
+		return;
+
+	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
+	if (!text_list)
+		return;
+
+	for (i = 0; i < max_sections; i++) {
+		Elf_Shdr *shdr = &info->sechdrs[i];
+		const char *sname = info->secstrings + shdr->sh_name;
+
+		if (!(shdr->sh_flags & SHF_ALLOC) ||
+		    !(shdr->sh_flags & SHF_EXECINSTR) ||
+		    strstarts(sname, ".init"))
+			continue;
+
+		text_list[num_text_sections] = shdr;
+		num_text_sections++;
+	}
+
+	shuffle_text_list(text_list, num_text_sections);
+
+	for (i = 0; i < num_text_sections; i++) {
+		Elf_Shdr *shdr = text_list[i];
+
+		/*
+		 * get_offset has a section index for it's last
+		 * argument, that is only used by arch_mod_section_prepend(),
+		 * which is only defined by parisc. Since this this type
+		 * of randomization isn't supported on parisc, we can
+		 * safely pass in zero as the last argument, as it is
+		 * ignored.
+		 */
+		shdr->sh_entsize = get_offset(mod, &size, shdr, 0);
+	}
+
+	kfree(text_list);
+}
+
 /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
    might -- code, read-only data, read-write data, small data.  Tally
    sizes, and place the offsets into sh_entsize fields: high bit means it
@@ -2481,6 +2559,9 @@ static void layout_sections(struct module *mod, struct load_info *info)
 			break;
 		}
 	}
+
+	if (IS_ENABLED(CONFIG_MODULE_FG_KASLR))
+		randomize_text(mod, info);
 }
 
 static void set_license(struct module *mod, const char *license)
-- 
2.20.1

