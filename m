Return-Path: <SRS0=wH9o=YH=lists.openwall.com=kernel-hardening-return-17014-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EE4C4CECE
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 03BE820882
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="vhbXIo/Z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a2s7BMG2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03BE820882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17014-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9619 invoked by uid 550); 14 Oct 2019 05:14:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9533 invoked from network); 14 Oct 2019 05:14:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=PStFRxzl4Zn7i
	9v7bh9ypxBUch/1PPtigM566gooksQ=; b=vhbXIo/Z3j5Nf53e2OQ97Qo4sy/ds
	RSzDav9/HWZXOsX8oFZ837S/vrCQPsFLmanIt+Pv0E8kCnAdsu6fS9g2q2BPVBNz
	nBfnXfdQXY1yT0pT1cmd86x0pRelX9vZV67DNg0ZRqaOa2AEgTLjV3qPVvWYwlrG
	AXdyhjloOWFAVnjjz1FFgREN/hp9Kl8bv2oZpZ4ASlilkhDwWewWeL1vSDt80yb5
	TXsG2R6l1wPWFGD51s7HouKHD9lfNuWZd96jkHQI7czs0aTvaxzmQ8fbPA0YOlpB
	ONmuPO/O2jYCVqBXkLR/ehHAtqBr4q3QxtxJJC/OTga1ZUxPxedz8aGrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=PStFRxzl4Zn7i9v7bh9ypxBUch/1PPtigM566gooksQ=; b=a2s7BMG2
	Dn31nb6flKsEQkv7HZXBauPfAJqpQYCYpzGH3dANNZgTB9GH4K8A6uP7MR45NouM
	3McPoUv/wuYT1MmQfZrOfTdkn3vYZJvSQI75yoouWAgt2oai35U5VNBzESxRSbLD
	BHWnnJrUqvzQoaWyl4vZnmN16XFy5sAgY6kmDVBXQiqOP6KKS8APa4bYsx8HiYyQ
	317SNQrgS5KlaVPH4a3OQkRNKOeLPP1ioZXsppgGFgbpSRgXehA8HkUWxtSP2CZk
	dnY8gw3uMB4eiO0dk/LA11IzX+smR+jpwflKVZE2tFMHj16s5qS7utHKFSsCmGwk
	AdjhAvec6+u7JA==
X-ME-Sender: <xms:EASkXRpqK4osoWggscIjZd-uTCdApg3irNWzLacUHmoAifsblucw4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedtgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdr
    tggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EASkXdfQMqUSdmYKmwBwAfhpmP_naNV1I89nm7lcrw8EJn_vq8nx9w>
    <xmx:EASkXdAAIfzUlIHoaTk02JY_j7S3FSIp1CpeWAA1U-YFTuNC_VpM3A>
    <xmx:EASkXYRi7b5yyhS58D2qJ9wprbzfJNfX5e6C61RPU468t2b6qUJcXg>
    <xmx:EASkXQL-wfbkKSc-6t2uG3AUF3Ea22FldJl_iVGkJEDe2gFAJ_rirA>
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
Subject: [PATCH v4 2/4] powerpc/kprobes: Mark newly allocated probes as RO
Date: Mon, 14 Oct 2019 16:13:18 +1100
Message-Id: <20191014051320.158682-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014051320.158682-1-ruscur@russell.cc>
References: <20191014051320.158682-1-ruscur@russell.cc>
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

Thus mark newly allocated probes as read-only once it's safe to do so.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/kernel/kprobes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..2610496de7c7 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,7 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -131,6 +132,8 @@ int arch_prepare_kprobe(struct kprobe *p)
 			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
+	set_memory_ro((unsigned long)p->ainsn.insn, 1);
+
 	p->ainsn.boostable = 0;
 	return ret;
 }
-- 
2.23.0

