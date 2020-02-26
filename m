Return-Path: <SRS0=E+1c=4O=lists.openwall.com=kernel-hardening-return-17936-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DCAC4BA0B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 132F621556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="Om9SaGrt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ou0hrHGh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 132F621556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17936-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26448 invoked by uid 550); 26 Feb 2020 06:24:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26342 invoked from network); 26 Feb 2020 06:24:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=MN4A9pGwx4Xvy
	IA4PshSsOurx0y3KhuXjclcGJOa81k=; b=Om9SaGrtTWabYgpMsCrt/Z15hL6Pm
	E1kR3wOcI3rIYdr9YDxX3b5LVXc9TOktg9brw030yc06PEK3hgpABqAvqm33ZmQF
	MDORR0J0sW2j6Z3CEWTxD/kRABYkhTtyxGDNyv4Jxn0ZRhX1Gb/X4g7vmj7rhx3p
	07rvRIMviK8zODvXz+Rkib2iU6KJE+E58sWM3JVkx0nJSglZccfRurG85Rr7eqCf
	J9jaFs/QzeYLEEz2osMTpKICNowRDVwaIDV4eU1Rv1NHPxghnvL9GF5VP5b/1abb
	ZpamUmRJvwIZGgpatDX5WPqJki3cWwv0GbvVk8OOyn9vmqB58fC3wOifg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=MN4A9pGwx4XvyIA4PshSsOurx0y3KhuXjclcGJOa81k=; b=Ou0hrHGh
	9hoCxhD4UeojpgWxviUYh4ype55tovwkpFsSNWQHJJAyxMA4ynB0gHbPlxVL0UGa
	5VQSZks4/Rz8qdN70hMWpOFiK05O45GPnHhEUmDRlHIvMxNUhh1ssGWBbhjRy/zj
	KmkWPYuojCD5LPVTS5zTi62skTc5IKlI84IQHeVMrg701xBq4Zt3Z4Kl+F4BtqwM
	szLxguvk7mJ5hijgyFnzvK/Z3LdSAsIdq6eLUNAjA/laQ6IO6sru+CK3rDwM1mIy
	HPkphVGA6+VMn79WNp9AKuH4TOLeHjIHE7aTQjywiBAu8BTBbaIHH0/I+EmE8vhn
	3G2/zYf8/IhRjA==
X-ME-Sender: <xms:JQ9WXhIT6667djvMsp7T9Qg6bu5zg2XdgCBap7-u9-yLI4JnqpIZhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculddutddmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgepudenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:JQ9WXhQ0yGInBywp1zKWJXxRVZJxO1c2AAuYBf8g1rEvc4j2-DEqnA>
    <xmx:JQ9WXrtR3-KskeYdl0DssnAMYgpPb-lPXdArv-PiATkvYpW2QV3gaQ>
    <xmx:JQ9WXusZdLX46I6cY-fk8yt3RcHRdMoSsXsOXXk3TCAwrLKq2923Yw>
    <xmx:JQ9WXpo4j0P_5JogDjZUy6jAqUTxD9SHgulNI1JLnjNyqxu79S701Q>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v4 2/8] powerpc/kprobes: Mark newly allocated probes as RO
Date: Wed, 26 Feb 2020 17:23:57 +1100
Message-Id: <20200226062403.63790-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226062403.63790-1-ruscur@russell.cc>
References: <20200226062403.63790-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will be one
W+X page at boot by default.  This can be tested with
CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking the
kernel log during boot.

powerpc doesn't implement its own alloc() for kprobes like other
architectures do, but we couldn't immediately mark RO anyway since we do
a memcpy to the page we allocate later.  After that, nothing should be
allowed to modify the page, and write permissions are removed well
before the kprobe is armed.

The memcpy() would fail if >1 probes were allocated, so use
patch_instruction() instead which is safe for RO.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..bfab91ded234 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,8 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const char *name, unsigned int offset)
 	return addr;
 }
 
+void *alloc_insn_page(void)
+{
+	void *page = vmalloc_exec(PAGE_SIZE);
+
+	if (page)
+		set_memory_ro((unsigned long)page, 1);
+
+	return page;
+}
+
 int arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -124,11 +136,8 @@ int arch_prepare_kprobe(struct kprobe *p)
 	}
 
 	if (!ret) {
-		memcpy(p->ainsn.insn, p->addr,
-				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		patch_instruction(p->ainsn.insn, *p->addr);
 		p->opcode = *p->addr;
-		flush_icache_range((unsigned long)p->ainsn.insn,
-			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
 	p->ainsn.boostable = 0;
-- 
2.25.1

