Return-Path: <SRS0=GbUu=57=lists.openwall.com=kernel-hardening-return-18507-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BFFC2BA19
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 21:06:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 11F462076D
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 21:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11F462076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18507-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15694 invoked by uid 550); 15 Apr 2020 21:05:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15584 invoked from network); 15 Apr 2020 21:05:33 -0000
IronPort-SDR: zw9qvevktgYrdmlPuRjYaEsu00/4Ov5LlubyZUTqgr7eqsqlMUGmXsQdhf0gCcJ6RZUMDIRPzY
 T5P42Q7vkQPA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: Y40uVd+P74lLUKeRusKoiPA8XYqHaH2O5MnWgeowvptaQZp656CMoN5LsabEpfLzz/rBr21F9T
 8ipIh+tzLoOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="455035560"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	x86@kernel.org
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecomb@intel.com,
	linux-kbuild@vger.kernel.org
Subject: [PATCH 4/9] x86: Makefile: Add build and config option for CONFIG_FG_KASLR
Date: Wed, 15 Apr 2020 14:04:46 -0700
Message-Id: <20200415210452.27436-5-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415210452.27436-1-kristen@linux.intel.com>
References: <20200415210452.27436-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
the make file to build with -ffunction-sections if CONFIG_FG_KASLR

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 Makefile         |  4 ++++
 arch/x86/Kconfig | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index 70def4907036..337b72787200 100644
--- a/Makefile
+++ b/Makefile
@@ -866,6 +866,10 @@ ifdef CONFIG_LIVEPATCH
 KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
 endif
 
+ifdef CONFIG_FG_KASLR
+KBUILD_CFLAGS += -ffunction-sections
+endif
+
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d6104ea8af0..6aaece89f712 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2182,6 +2182,19 @@ config RANDOMIZE_BASE
 
 	  If unsure, say Y.
 
+config FG_KASLR
+	bool "Function Granular Kernel Address Space Layout Randomization"
+	depends on $(cc-option, -ffunction-sections)
+	depends on RANDOMIZE_BASE && X86_64
+	help
+	  This option improves the randomness of the kernel text
+	  over basic Kernel Address Space Layout Randomization (KASLR)
+	  by reordering the kernel text at boot time. This feature
+	  uses information generated at compile time to re-layout the
+	  kernel text section at boot time at function level granularity.
+
+	  If unsure, say N.
+
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-- 
2.20.1

