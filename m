Return-Path: <SRS0=/jkl=43=lists.openwall.com=kernel-hardening-return-18118-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8F1C10F25
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:05:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B55820637
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="dqt/xHsF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gykmWXvP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B55820637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18118-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27657 invoked by uid 550); 10 Mar 2020 01:04:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26560 invoked from network); 10 Mar 2020 01:04:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=fIQUcfHh7QuR4
	38tK6lJLzDWB37n7jovUl45LUEKMUk=; b=dqt/xHsFFvs0lg06urFyb2gzqSi76
	YF8ftWdlUJk+L7KKwtUH5XMJGY/pcS5bBOExUQC4mPDMU0bnXnY74qAgBG5JxDzO
	uFguhW0KFDNcLgdqi6D01nqz8S3LCAgq14vDa6Ndu6GCGDQxUdzKJg0ovOkpbrik
	UY+n1ANFc8biHYWs25PBKULS9bERpbZy35rWwVFiR0qtELlBbUyYG+MoSLA8/K36
	p51hnfHNQ0wvofIch+Rfkk6Hha/U6W2Q4EZ+i7epoBkMq4TFZt00hNZ1HM0Vqhge
	A76AC5yoIE9SCZo9mFBd1GqPcLQUuCqwSKNMSlNKj7JRer6Kq6nEJ3Edw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=fIQUcfHh7QuR438tK6lJLzDWB37n7jovUl45LUEKMUk=; b=gykmWXvP
	n/BhakK7KixuLCtiDcgwIVRniQRq7z6qDlt6vIrNKcDtcXe8BfqLNdfUsImPL0Sa
	ERqUyLOh3NIzl3QJachDjCeNToqNNfP96F7W3S0pfXrFTWXwz3t6t1FwR2XA8cou
	iGhLdo6vD9OaQU9giWpTGKbhtLsPq8nEIXzP6+qIRAZQ0AJsqR5GSlk2OwviMknY
	Q8SJWlmhTdYZ0GbUwXVxjDsIQPOJBeuaFbd7El2OhsUUaOVgwZOdW/lHQCJCHSCd
	TNzUA0wK0U8tGedeUlJqz7NyG2ScogEDNF6WM+6A18nz5bFFnJ62D7Z16V3ftFE+
	7EU+U6kL1QJ88w==
X-ME-Sender: <xms:kudmXgNFEhjyC_ExTYQ1fJ1_WPGgnsHXaNxs5K_zvuql7cms2t0B8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddvrdelledrkedvrddutdenucevlhhushhtvghrufhi
    iigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllh
    drtggt
X-ME-Proxy: <xmx:kudmXvwi5zJLboHt6p-Dnv5LGJvAqsjowesTvGknMmPxnoT6ROV98w>
    <xmx:kudmXt06T67kCX3dyup3sVUEIbhRMm6g0uj_eYqmDCfo2WCUo16wNw>
    <xmx:kudmXmEzXkA2H-93pJIalil6PlfAB-1vIoQwUTDTFF5dXA7jBBI9Sg>
    <xmx:k-dmXkH0-CLEf4gaLpmrvt1VVB2_p3_kI_3Hmp_Y2R8W3wAH4fvuyg>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Joel Stanley <joel@joel.id.au>
Subject: [PATCH v6 5/7] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Tue, 10 Mar 2020 12:03:36 +1100
Message-Id: <20200310010338.21205-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310010338.21205-1-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skiroot_defconfig is the only powerpc defconfig with STRICT_KERNEL_RWX
enabled, and if you want memory protection for kernel text you'd want it
for modules too, so enable STRICT_MODULE_RWX there.

Acked-by: Joel Stanley <joel@joel.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/configs/skiroot_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1b6bdad36b13..66d20dbe67b7 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -51,6 +51,7 @@ CONFIG_CMDLINE="console=tty0 console=hvc0 ipr.fast_reboot=1 quiet"
 # CONFIG_PPC_MEM_KEYS is not set
 CONFIG_JUMP_LABEL=y
 CONFIG_STRICT_KERNEL_RWX=y
+CONFIG_STRICT_MODULE_RWX=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_SIG_FORCE=y
-- 
2.25.1

