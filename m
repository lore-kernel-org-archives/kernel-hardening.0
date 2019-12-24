Return-Path: <SRS0=OkZ8=2O=lists.openwall.com=kernel-hardening-return-17516-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA80C2D0CF
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7D475206B7
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="E/oBDDmr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gG9hkhhz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D475206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17516-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20301 invoked by uid 550); 24 Dec 2019 05:56:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20215 invoked from network); 24 Dec 2019 05:56:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=g0JXM4p7ZeNbM
	/n/P1uBfa0xgPXj9o+bD1IfKhBoyFs=; b=E/oBDDmrGdr7dMrBGezj4+ZjJ1hjs
	SJkWR/CjPzeSBHXaMhNwy79AxONXFdHx6pWy+KPxSgo9sxBxBfzEMLW+chMb5IPg
	C85DOqebx73Mb4OalGKxyromzae4Vg0Ml7LdG/2uN6SnRZsPEEhoVTZkty60NEOv
	oPauEMNcwVyVodDFMcDNhI3ESN9b5MvbYmALr1RtrAjZu8fTbbIngpQ0ofJ13FWB
	rXzw7P+M5DK1FRhn66rRGIEonHICQmO4bFTF1+LCciFOnegS0xkF73kXffaYgt9G
	lr6xaRFOjAB1pnVNFUvoylmODzPXDcjCIXLNxI6eqn65RgbtDgwu1r9cQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=g0JXM4p7ZeNbM/n/P1uBfa0xgPXj9o+bD1IfKhBoyFs=; b=gG9hkhhz
	K3dryN0VPnG8TXus1+47AVCkspzqvVHv1tfOvs4r8MHW6ZKB6TC8Rggm+O8aXXuK
	kNiThX5m29KP7QsDAsnaYtjU0OEX3cgAaqb+/9JhWVyTYzZ46Gm9ZeVrmLY76Ukv
	LVFHR7Lb4SmfxHzXsh4HMzn6Tby22TdmshTe/MiVqNtPerJGLXVEevI7YccdX8az
	nzohIQNB3QM6YISyl81wjF41XJctia0hDZYskSq0xLk9PFb3Y8pVJBmuHHkCSQiC
	+ck8gCIwMjFMFimVmdPqZYAefbPXhcjnnixNVrulAchmk0gyJWPPs2IS8WtaXiTE
	VBBlngQVxmSzvg==
X-ME-Sender: <xms:b6gBXkLsnayTj4L08TD1Y2-9IKUQ2cbjP9wC5fqS2zKjM9kQLQyScg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhl
    rdgttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:b6gBXr0THpikXk61fTMkMnslqE3TMjuHYhILDdZPESdIQkyRs_r6Hg>
    <xmx:b6gBXqjLZCg3mzcQApVfs74DQAmXyHclCw74OsiJpZgydJR20RXPug>
    <xmx:b6gBXizplQt_XCk6uUIZGcLAcSBu9xUkmelaPYygPmkXmmAfL54y5Q>
    <xmx:b6gBXvbNolUE-891FZDZEzMt2DUMb6TQ3pp-OIGsQH3szFsMd_eg9g>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 2/5] powerpc/kprobes: Mark newly allocated probes as RO
Date: Tue, 24 Dec 2019 16:55:42 +1100
Message-Id: <20191224055545.178462-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224055545.178462-1-ruscur@russell.cc>
References: <20191224055545.178462-1-ruscur@russell.cc>
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
---
 arch/powerpc/kernel/kprobes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..b72761f0c9e3 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,7 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -124,13 +125,14 @@ int arch_prepare_kprobe(struct kprobe *p)
 	}
 
 	if (!ret) {
-		memcpy(p->ainsn.insn, p->addr,
-				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		patch_instruction(p->ainsn.insn, *p->addr);
 		p->opcode = *p->addr;
 		flush_icache_range((unsigned long)p->ainsn.insn,
 			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
+	set_memory_ro((unsigned long)p->ainsn.insn, 1);
+
 	p->ainsn.boostable = 0;
 	return ret;
 }
-- 
2.24.1

