Return-Path: <SRS0=cpra=2O=lists.openwall.com=kernel-hardening-return-17519-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9DCC2D0CF
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE18D206B7
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="RNY1BDc3";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="X/dXvbKi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE18D206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17519-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22310 invoked by uid 550); 24 Dec 2019 05:56:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22224 invoked from network); 24 Dec 2019 05:56:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=4VL2rvXf5bbo/
	YYVlys+nvN5T+AYKTkC0MAqwoxcqsI=; b=RNY1BDc3jqyQ7snuL6VqhiYFbV451
	qo5KtP0LkobTzZTw9CcwZMP/JyCJWr6gx6hTfjDGxY4bTlRJuU+uj00Sxk2RAhit
	Rdw1CvQhsScp4lcd43tyJtHRhJ3PvU8/0NZ9pbgpqr25Cn8oHFwAD6ddIhRszjKq
	ran4fi76zAGVuGQgo6HfKlGWy/2lU0WMBrn9YFCwSHknjeme5G3uquNf9g2SeZqn
	fYO/S9fEGDoRo26g+kut2nebFUrDv7TKzko+2onAdO99c7o5B0WdPwXUd0fG+Hsa
	C65846M1vA3AhFhvbWCq4mb7SMbAR75tpfzxAFAv3ue3rQ/h2CKPxZhzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=4VL2rvXf5bbo/YYVlys+nvN5T+AYKTkC0MAqwoxcqsI=; b=X/dXvbKi
	fOvuRuADJ1aBGEP88UvQHraAOuT2/5AWDr7lJtWg+8Q6gjhc/E6A7r19MSQ2zR3W
	8RUzRACWn6Q4EocfTpS9Bg5V7O0V4Q/2pdj3hH3RQti5M/UHIOyZhfODOl4NIQGY
	e8KSg5cTu/W8s7tT8OpQL0tqt8PzhOUKGrK5U1yP3IN06yWIVYxZF5yzAelcvTc2
	7RvySaQiYKWZ4OKAPs8Rf+es0yLcVvDl1AWnn+3ZGdl2CMBggZLv+CasNTkLD5tz
	gA+Pfiac6Z+VN561qjn/ZKql/Oh+YNNs6DvoyGxMwwh+xIOa5z+B95Fxv32qWLfO
	VVLJyhIU6J+jnQ==
X-ME-Sender: <xms:eagBXsFeNKetXKcXTgWX_Dq8Y3uKLqiDdqZlyvOrtMi3SsFunKEFQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddvrdelledrkedvrddutdenucfrrghrrghmpehmrghi
    lhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrdgttgenucevlhhushhtvghrufhiii
    gvpeeg
X-ME-Proxy: <xmx:eagBXk79d5TuN1A2mSRleroxHixGPj2EQl69WgjSkaLJ4-jj2G418A>
    <xmx:eagBXqeBDg_KkYUuGqZuthmA_U3-G7SkploUjsUvw8xaTPyReQrvwg>
    <xmx:eagBXgm-fQoIZ7CC8LONNkSk8-Oi5vI3Vs0l5xBdFYtYebTQGPog2A>
    <xmx:eqgBXgRCVNvTqr4KNUunT_bpxaOqBbw4fMG_S76vYClT9NmyMUuV5g>
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
Subject: [PATCH v6 5/5] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Tue, 24 Dec 2019 16:55:45 +1100
Message-Id: <20191224055545.178462-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224055545.178462-1-ruscur@russell.cc>
References: <20191224055545.178462-1-ruscur@russell.cc>
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
index 069f67f12731..b74358c3ede8 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -31,6 +31,7 @@ CONFIG_PERF_EVENTS=y
 CONFIG_SLAB_FREELIST_HARDENED=y
 CONFIG_JUMP_LABEL=y
 CONFIG_STRICT_KERNEL_RWX=y
+CONFIG_STRICT_MODULE_RWX=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_SIG=y
-- 
2.24.1

