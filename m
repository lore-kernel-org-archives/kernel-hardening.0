Return-Path: <SRS0=hTen=5S=lists.openwall.com=kernel-hardening-return-18372-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6234BC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADD8920757
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="tHKWzO/Y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="zggeFAj9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADD8920757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18372-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9721 invoked by uid 550); 2 Apr 2020 12:31:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9487 invoked from network); 2 Apr 2020 12:31:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=GOZVk5Fsc5eI2
	5Khq7lhjYKWFmMeiiNzwmpYuMZHgMk=; b=tHKWzO/YKIoeg/m4Ct5GMas6HWb+D
	vSlMm5IFk1yy4M/idFQxdK/RNpRsYtc5CxLucH653PuHO4p26HwU6xHFF6SAuQsF
	mOYHXroqe+D7zQyIkhyb9U639u4heZOdbGNnwLXB2ctIRhfKwIDIqq2kauCD7QSb
	R10rXQdtFueXC5vO7VDCQ9m+VsSkSl/aEkwZDTale86hIBAcCKFyqIHwotzUy54Z
	6D/6RQud1uX6wQBrZugQy+uRFv3DDTCrF43sZuFpAAUlTZdQFlRSmB9byeHz9tf9
	xJQB4gkYoqd8tfSOpH2Kdg1245hcygl7VagRi7yjwAgs+iJYNnVR2uScQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=GOZVk5Fsc5eI25Khq7lhjYKWFmMeiiNzwmpYuMZHgMk=; b=zggeFAj9
	MQCctEYeTljjKugBIcF4pEYMp+NLt6pvoiOpZGt9KIHbxMghg22wNSITvAWFdGUQ
	gySd3KNWuJoM/jcQgiYRRtyjYEKfJDZgQLEfX2YlxP8QmUfVysRO1uRjcH9khEzY
	OPTmbp7/VK8qjQqpdZwhc0Q2BQZj36y5Babt2+69F2CTSakdyt5+7a+EWadcEZq8
	BZpA7vv33Q37aZbCMgMaZFYyj5uEjPp0eDN53Ywni1qwzsej1mvnerwm9B/wqgSS
	rT17SqBPnKPQhjnm9mMqDK6nU/P/Pkhfyovv2oRWg9zqCIM1lInmz5V/JOr1WSWI
	sHOTVGOdTCcVOw==
X-ME-Sender: <xms:LaWFXp3ENmPZ_skjgRun2yv5pzMaBsfsDtwsnzBPL7Z3OhX1GKMNew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddutddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvuddrgeehrddvud
    dvrddvfeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mheprhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:LaWFXjx_UXBF0CEjRBOFsjep93l3Yme72j8eG8DwRhnvaXG73DH7oA>
    <xmx:LaWFXk8ipVSGJTJhrrZ5eF6umNStBuByc4CRjiuHt7GypdhBC0ZVgw>
    <xmx:LaWFXkR1b0U-gEixhKxbD-xrytPTsYskEublO4AtbKQEBRU7jeK0eQ>
    <xmx:LaWFXrv-WM1y0pdyps0uTOb_5D6BCPfjRKCbUMafKawqebbhaCkWJg>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as RO
Date: Thu,  2 Apr 2020 19:40:47 +1100
Message-Id: <20200402084053.188537-2-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200402084053.188537-1-ruscur@russell.cc>
References: <20200402084053.188537-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 81efb605113e..fa4502b4de35 100644
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
2.26.0

