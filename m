Return-Path: <SRS0=mxNg=5Q=lists.openwall.com=kernel-hardening-return-18318-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD12C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 137C0206DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="HN0ge7rO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m0YhYt/X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 137C0206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18318-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18384 invoked by uid 550); 31 Mar 2020 04:49:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18284 invoked from network); 31 Mar 2020 04:49:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=YdgK5wJ0mllJO
	Oyk0mWMEHi90zL9Pke/ZAcvxVO1EF0=; b=HN0ge7rOcJmVS5YSgBnI7FNcjbNK1
	yflZMlr6PjhIhFvYqnru5rzZUib0OEKBzGrkukS4Rx6P+p5YQxWdB8biNie5x0GI
	a8STiAC4/7j616u+PtpizEH5b8TT/f7WMmgIKHuV9qNPmzG47EWDb8v1cOqXeAg/
	GegXMiW9NVqJ2rYSgqhmD+IG9LRsZvA1E9YDzCV8BUrADu671L7+tO02vthswhXX
	d+1GFh8OqGgVyslTknIpj7E7zZ4/AdzVCPf6rb9HGEDVyqPa53aU+igIbzPIgHfu
	lPeOi6zuqlxDij2BHPh2q9iQc8dCL5OvCCnZXpn3NPATsmE0019vlSaMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=YdgK5wJ0mllJOOyk0mWMEHi90zL9Pke/ZAcvxVO1EF0=; b=m0YhYt/X
	WIoOraJVRbjnE3A9OBVteVQyMODBfGLu+0us37fiUQgoKZ8nw21fLOcdH5NBLTc6
	L+3QDKS8f3zxAdL76HCDz6Ko3L77uXq+VbTCBfXjN9UYF6qoUXHELDSGJg/+LNWd
	Psy4obJJumcQFpkxOu116KpAgD3mnul1e8wLBS/VajsXR1ngT8xF59JMKW/wfOPI
	TBk4tT7kYlj5mMqOzfhrmkWHVm/+02e/ZqLc1GdqgEStZUmUbF+489pOiX2LJxUP
	bDIzE+7UGmPID01SYThJEWM9d+Me7NYqGMokPgZ6ztpq7j87BqPbQefJ8eMU6k3q
	okeiqNF65eGwPQ==
X-ME-Sender: <xms:tsuCXp6V-fsTiPeSxEayxsgA9Mcd0gkm9gBY7uzUnMr7UBMNh8mHiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddurdeghedrvd
    duvddrvdefleenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:tsuCXsC-_ABZWvw9MjJ-HXmUpQ8Ay7_K5LCJxWllSqoWJAkeHFggyw>
    <xmx:tsuCXnvBrieNQmQzXrPlIioFY6-Y8LM60N0x0vqmiBzszak4wVtSZg>
    <xmx:tsuCXpvETuzyT3fjsXoxQLau2lCUChyEYrv8SywpBeJBGjgmtdaWwQ>
    <xmx:tsuCXts-4kXTA_nXvz5s6PF39QP0DGeZdFKFmcH_t9A6NI1bBp2GAA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7 4/7] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Tue, 31 Mar 2020 15:48:22 +1100
Message-Id: <20200331044825.591653-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
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
2.26.0

