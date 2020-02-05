Return-Path: <SRS0=xgNJ=3Z=lists.openwall.com=kernel-hardening-return-17680-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E1FC35247
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CBFD2214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBFD2214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17680-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10187 invoked by uid 550); 5 Feb 2020 22:40:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10106 invoked from network); 5 Feb 2020 22:39:59 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092467"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 10/11] module: Reorder functions
Date: Wed,  5 Feb 2020 14:39:49 -0800
Message-Id: <20200205223950.1212394-11-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a module has functions split out into separate text sections
(i.e. compiled with the -ffunction-sections flag), reorder the
functions to provide some code diversification to modules.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 kernel/module.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index b56f3224b161..231563e95e61 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -53,6 +53,8 @@
 #include <linux/bsearch.h>
 #include <linux/dynamic_debug.h>
 #include <linux/audit.h>
+#include <linux/random.h>
+#include <asm/setup.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
@@ -3245,6 +3247,87 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 	return 0;
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
+		 * TBD - seed. We need to be able to use a known
+		 * seed so that we can non-randomly randomize for
+		 * debugging.
+		 */
+
+		// pick a random index from 0 to i
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
+	if (!IS_ENABLED(CONFIG_FG_KASLR) || !kaslr_enabled())
+		return;
+
+	if (sec == 0)
+		return;
+
+	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
+	if (text_list == NULL)
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
+		unsigned int infosec;
+		const char *sname;
+
+		sname = info->secstrings + shdr->sh_name;
+		infosec	= shdr->sh_info;
+
+		shdr->sh_entsize = get_offset(mod, &size, shdr, infosec);
+	}
+
+	kfree(text_list);
+}
+
 static int move_module(struct module *mod, struct load_info *info)
 {
 	int i;
@@ -3282,6 +3365,8 @@ static int move_module(struct module *mod, struct load_info *info)
 	} else
 		mod->init_layout.base = NULL;
 
+	randomize_text(mod, info);
+
 	/* Transfer each section which specifies SHF_ALLOC */
 	pr_debug("final section addresses:\n");
 	for (i = 0; i < info->hdr->e_shnum; i++) {
-- 
2.24.1

