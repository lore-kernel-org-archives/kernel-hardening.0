Return-Path: <SRS0=pNtk=4O=lists.openwall.com=kernel-hardening-return-17938-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30352C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82F2F21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="smFOLbq+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MQO+bh6i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82F2F21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17938-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28164 invoked by uid 550); 26 Feb 2020 06:24:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28050 invoked from network); 26 Feb 2020 06:24:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=Z84AqZl7dQCow
	nF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=smFOLbq+zsgiAS4lVZSUu08eP5nd9
	s835PQdJ3S6lbc7vptT52P9TjNL2BSjPqVM7z9y13UBINCFDFYC/JRpDNPa0GRWn
	VEV7DCAMjqd4EmYM5FroumvXsbonrfucNaIMSbFbzbACiWLPakxy0r+seLDIoOr7
	3knro/W+bx+YdWkMVm3nSXM0E8XVug/RfxfwyC9JcgNkW3fpDw0e2ynj/UMO/zwT
	+fzQsFAwd4v3QsmRxoKsPGr4iUxm3AFcvMHWK0FsCNeifxOFjsdbca/+7n21RPyE
	kRcypIUTDjbDdX8YGIMrnEDOVzmbMRqmIiOtMtJDeiPzM7Acfp0ht7jDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Z84AqZl7dQCownF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=MQO+bh6i
	wcuL9aHNsnUJA+jasgYE4/h/6bFaQsRPNy1PtXDoWepuS9gIiV8eBzQtV6UrVODR
	KUsVh+fkESc/CCHMu+wiyZXE9hhDH18OIDfuVmCJGqrr/6gm+pbQiFtuqr6hTqbr
	l4bFOVGXCnyIQKxO5wueCXxsVUhIYimZFjlagQr9vsPUbfYBM+SJ7cbuCrL4MNgr
	ax93nAFCFaz4Zlo7Mix+eyFtZW5obUjCvtqHKNCWFp4TRKiTZyL4l9lEH9jKUrGz
	OXmF7jVve2x3kOsS0SYkVDjwgGAhuCf46KtqMb09xWF9qCHSh/uu0ZYOsJpWO44S
	oUOsQ/grPAZQnQ==
X-ME-Sender: <xms:LA9WXhk4tGcOweXtqUryZSJ0vpPJ488NA2ASDvxr6blQnX2-fZxGAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:LA9WXhFOUxgStmGl-LT1U9ZWpru2U5B-fwwQPgjxLDPJY_uw8iz3wA>
    <xmx:LA9WXipw8qo71r7smmfem2xCfrh3qmY8uMY34p04PbNRi_rDN1wq4g>
    <xmx:LA9WXl6HtntCpDmztmU83zlusyL5FkAJgUvDT2J5bIxclgqbkjOIaQ>
    <xmx:LA9WXh94XYPHmja6sWgZ3Mq8YJgt1M5Ld1ymizOJmPyJTNafRtmPSg>
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
Subject: [PATCH v4 4/8] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Wed, 26 Feb 2020 17:23:59 +1100
Message-Id: <20200226062403.63790-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226062403.63790-1-ruscur@russell.cc>
References: <20200226062403.63790-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To enable strict module RWX on powerpc, set:

    CONFIG_STRICT_MODULE_RWX=y

You should also have CONFIG_STRICT_KERNEL_RWX=y set to have any real
security benefit.

ARCH_HAS_STRICT_MODULE_RWX is set to require ARCH_HAS_STRICT_KERNEL_RWX.
This is due to a quirk in arch/Kconfig and arch/powerpc/Kconfig that
makes STRICT_MODULE_RWX *on by default* in configurations where
STRICT_KERNEL_RWX is *unavailable*.

Since this doesn't make much sense, and module RWX without kernel RWX
doesn't make much sense, having the same dependencies as kernel RWX
works around this problem.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index bd074246e34e..e1fc7fba10bf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -131,6 +131,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.25.1

