Return-Path: <SRS0=uSsN=5S=lists.openwall.com=kernel-hardening-return-18375-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3747C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:33:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41AF020784
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="AeMKmsWv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TAqpJN+M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41AF020784
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18375-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9968 invoked by uid 550); 2 Apr 2020 12:32:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9838 invoked from network); 2 Apr 2020 12:32:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=D35Sp4/q5XH3f
	eqqq2i54P8WdPsSvOStPArRH93EKL4=; b=AeMKmsWvSKArCGXlNReAmXhM0DVdA
	RygWzGXT9sB+/SMVYr/VRDeQhx4cWoC5oawJ+P8f8T8mulnslOCAcwoeEOszRjnN
	vaA59EJXE1q65aJ7q/n9PqK/hmOX35v5rDptze1Gw4NJNkfG6zSHd5bsIGVaulSn
	P3CeuqOlMPEUXF3JAnuPyZ06SbHmFvcxgU4MfGYKTbwVYzbAw1t1b0VT5GHWhFlB
	iehphtSPOOwWKI/eml3jMzDpdA6EEibhb7g04wHaYZpN/iTIEFpAeD13bSbN27gG
	XMvel3xXk1VyeP+t6e6hf47fEeqLjz9fGpbsWcpMopY6CjQkv84zwamUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=D35Sp4/q5XH3feqqq2i54P8WdPsSvOStPArRH93EKL4=; b=TAqpJN+M
	6OolBIUOTLuC2SjQ3TIfFxECndjl+7Q4nWv7WiDbcYoa0OGXkHso/jZTKGZ7pRoe
	MnCRoeMDxmpJHkthO2WmlR4uHUxJeNPRq45o3gKcaj1w14aB0m0SKgg4P5khVg7k
	bxo3w6kNWBfg9aVCNydpZUnZFxQSSEczZz9sRV89tBSToSIo6Gs1R1mTYLtbftSC
	WM5UHmbyWPlPUYkYzV/YPHM9aYRjn95IEpEbpYXl1dU8VqTRSU4Nz2nevMV8HXx/
	8PXDoZBpXrA5yM1c/9KuxrOcojI+YQsJBRuy70MDpE791NaH9iwxqP806TNg20GU
	+H72s2NMf5m32A==
X-ME-Sender: <xms:M6WFXolO0l1SC6vChmJ-HX-U_TpbsaxxGsH4r2Im-Pm7PMgxi3hs4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvuddrgeehrddvud
    dvrddvfeelnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhho
    mheprhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:M6WFXsF7i7qLPCnHyuwObJMglM4Vu8HkLOCb9Ct0ZvBEEu6waLD95Q>
    <xmx:M6WFXhoEKvQG9-YR-gZhlnm_yWd0Oqk4TIwljYa8LYitbhy7Mca_JA>
    <xmx:M6WFXo4kihhoFnWC613Cb8AVNxAPX3DIDiSg8LLl1O-jpwiHRp_4Jw>
    <xmx:M6WFXr0-BjWywE2TCF1Bk4r_-0GZHy6QsqZ1X8YggA0krhxRxdz3nA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v8 4/7] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Thu,  2 Apr 2020 19:40:49 +1100
Message-Id: <20200402084053.188537-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200402084053.188537-1-ruscur@russell.cc>
References: <20200402084053.188537-1-ruscur@russell.cc>
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
index 399a4de28ff0..1488bb5f4179 100644
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

