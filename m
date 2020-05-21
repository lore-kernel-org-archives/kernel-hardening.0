Return-Path: <SRS0=iyRE=7D=lists.openwall.com=kernel-hardening-return-18839-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E998BC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 16:58:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 521E920826
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 16:58:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 521E920826
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18839-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31939 invoked by uid 550); 21 May 2020 16:57:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31874 invoked from network); 21 May 2020 16:57:23 -0000
IronPort-SDR: ICl9AWQXTosAmAMBbZ1c7AZuO7e4WqWxUiigiRtLvSc6dlHZITZGSftx+ESqmgrosSk2S41kYn
 Mj8QJeSPD5jg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: Zw0HlnVb2QXZFYtGqKuEgUBIy0YtUb+Hn9kY1fGHVDXq6bxN8QeBgr2Texd/QYSXXUu4PHMexH
 gZE6NC5W2mFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="309094725"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-kbuild@vger.kernel.org
Subject: [PATCH v2 4/9] x86: Makefile: Add build and config option for CONFIG_FG_KASLR
Date: Thu, 21 May 2020 09:56:35 -0700
Message-Id: <20200521165641.15940-5-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200521165641.15940-1-kristen@linux.intel.com>
References: <20200521165641.15940-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
the make file to build with -ffunction-sections if CONFIG_FG_KASLR

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 Makefile         |  4 ++++
 arch/x86/Kconfig | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index 04f5662ae61a..28e515baa824 100644
--- a/Makefile
+++ b/Makefile
@@ -862,6 +862,10 @@ ifdef CONFIG_LIVEPATCH
 KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
 endif
 
+ifdef CONFIG_FG_KASLR
+KBUILD_CFLAGS += -ffunction-sections
+endif
+
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2d3f963fd6f1..50e83ea57d70 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2183,6 +2183,19 @@ config RANDOMIZE_BASE
 
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

