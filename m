Return-Path: <SRS0=mMXe=76=lists.openwall.com=kernel-hardening-return-19000-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C290C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 19:05:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADA5E2088E
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 19:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADA5E2088E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19000-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7808 invoked by uid 550); 17 Jun 2020 19:05:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7649 invoked from network); 17 Jun 2020 19:05:19 -0000
IronPort-SDR: yHzrYgMcGxhOd5qL1C24vv/sAahVp+h06nPVi1T1umy+DLnqszoDlpSwJcwCIF455APPDVGLrD
 EI2tIeiA4pqA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: XaTM/0pxYcUKBtQfhnD+idd+M4VFhRN/WvrCorf4TvEgLkY2ri0Xu/TSQT3k5nLvh2ixTBEmy0
 BGSU6Y+wGWJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="273609601"
From: John Andersen <john.s.andersen@intel.com>
To: corbet@lwn.net,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	shuah@kernel.org,
	sean.j.christopherson@intel.com,
	liran.alon@oracle.com,
	drjones@redhat.com,
	rick.p.edgecombe@intel.com,
	kristen@linux.intel.com
Cc: vkuznets@redhat.com,
	wanpengli@tencent.com,
	jmattson@google.com,
	joro@8bytes.org,
	mchehab+huawei@kernel.org,
	gregkh@linuxfoundation.org,
	paulmck@kernel.org,
	pawan.kumar.gupta@linux.intel.com,
	jgross@suse.com,
	mike.kravetz@oracle.com,
	oneukum@suse.com,
	luto@kernel.org,
	peterz@infradead.org,
	fenghua.yu@intel.com,
	reinette.chatre@intel.com,
	vineela.tummalapalli@intel.com,
	dave.hansen@linux.intel.com,
	john.s.andersen@intel.com,
	arjan@linux.intel.com,
	caoj.fnst@cn.fujitsu.com,
	bhe@redhat.com,
	nivedita@alum.mit.edu,
	keescook@chromium.org,
	dan.j.williams@intel.com,
	eric.auger@redhat.com,
	aaronlewis@google.com,
	peterx@redhat.com,
	makarandsonare@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 1/4] X86: Update mmu_cr4_features during feature identification
Date: Wed, 17 Jun 2020 12:07:54 -0700
Message-Id: <20200617190757.27081-2-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200617190757.27081-1-john.s.andersen@intel.com>
References: <20200617190757.27081-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In identify_cpu when setting up SMEP/SMAP/UMIP call
cr4_set_bits_and_update_boot instead of cr4_set_bits. This ensures that
mmu_cr4_features contains those bits, and does not disable those
protections when in hibernation asm.

setup_arch updates mmu_cr4_features to save what identified features are
supported for later use in hibernation asm when cr4 needs to be modified
to toggle PGE. cr4 writes happen in restore_image and restore_registers.
setup_arch occurs before identify_cpu, this leads to mmu_cr4_features
not containing some of the cr4 features which were enabled via
identify_cpu when hibernation asm is executed.

On CPU bringup when cr4_set_bits_and_update_boot is called
mmu_cr4_features will now be written to. For the boot CPU,
the __ro_after_init on mmu_cr4_features does not cause a fault. However,
__ro_after_init was removed due to it triggering faults on non-boot
CPUs.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 arch/x86/kernel/cpu/common.c | 6 +++---
 arch/x86/kernel/setup.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d07809286b95..921e67086a00 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -297,7 +297,7 @@ __setup("nosmep", setup_disable_smep);
 static __always_inline void setup_smep(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SMEP))
-		cr4_set_bits(X86_CR4_SMEP);
+		cr4_set_bits_and_update_boot(X86_CR4_SMEP);
 }
 
 static __init int setup_disable_smap(char *arg)
@@ -316,7 +316,7 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 
 	if (cpu_has(c, X86_FEATURE_SMAP)) {
 #ifdef CONFIG_X86_SMAP
-		cr4_set_bits(X86_CR4_SMAP);
+		cr4_set_bits_and_update_boot(X86_CR4_SMAP);
 #else
 		cr4_clear_bits(X86_CR4_SMAP);
 #endif
@@ -333,7 +333,7 @@ static __always_inline void setup_umip(struct cpuinfo_x86 *c)
 	if (!cpu_has(c, X86_FEATURE_UMIP))
 		goto out;
 
-	cr4_set_bits(X86_CR4_UMIP);
+	cr4_set_bits_and_update_boot(X86_CR4_UMIP);
 
 	pr_info_once("x86/cpu: User Mode Instruction Prevention (UMIP) activated\n");
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a3767e74c758..d9c678b37a9b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -138,9 +138,9 @@ EXPORT_SYMBOL(boot_cpu_data);
 
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
-__visible unsigned long mmu_cr4_features __ro_after_init;
+__visible unsigned long mmu_cr4_features;
 #else
-__visible unsigned long mmu_cr4_features __ro_after_init = X86_CR4_PAE;
+__visible unsigned long mmu_cr4_features = X86_CR4_PAE;
 #endif
 
 /* Boot loader ID and version as integers, for the benefit of proc_dointvec */
-- 
2.21.0

