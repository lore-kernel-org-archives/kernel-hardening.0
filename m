Return-Path: <SRS0=VxEn=4O=lists.openwall.com=kernel-hardening-return-17949-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABEAC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9967C206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="KtVIqkj8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lB7vyfEX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9967C206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17949-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17544 invoked by uid 550); 26 Feb 2020 06:36:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17451 invoked from network); 26 Feb 2020 06:36:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=fIQUcfHh7QuR4
	38tK6lJLzDWB37n7jovUl45LUEKMUk=; b=KtVIqkj8BE8Oq1Gvs3Ggl43PRo0R4
	aoNpVoFyzoBlvwmSKTDntsNs50VtS0nx7BgTbT8OxNAoOHy7+pJzViU4lLUeTbSK
	/LBzVne5VH1Z7ticCINY2tONc0Iy0R8BkFAkUdq4MQclvQvqrKOitFc5MI9LAK/N
	vFAB9SShrgM3i6QMN7mYJcgz99FhWzZXhyKmk62jM2gQ99rgntUV+OGaubYTWNub
	6GcKN8JtrTTm5NUWL1VPFIddmcAPnERoAVlCKogYrymffyJeS+dNQ7hROXk2C54G
	qT5eqcJDemaAstjneLCfCKc/pBiJC+GEViG6ksfU6+AABeVkSiAkcFZ9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=fIQUcfHh7QuR438tK6lJLzDWB37n7jovUl45LUEKMUk=; b=lB7vyfEX
	emymQP8r7kmsSRduPIojaa9ggvXPfJVDSmndSP/Nq2CFNaTJchQjFtXrvn7yd9lW
	wdshVGcdtwI1V6dMKzsZ7XTG+UdPJ/Yi1QyEGclOKvTMEWmBCvqf84j8WCjuDZto
	P+nvQnd0d5g/oq5loEA5Eda2dDX+ge/fhV7y4R83cqjiYBLhVUkM427vbvu8mbFh
	/JHdQ/hQtAWUCIC7SKaOsz4/IUtvZnFmvmzS6Gfgon4sWsOuRSGNY7FJQaUzPV+7
	BbbXwSZPET98IxGe3JskN+mw7ow35NJOapnsQWFF2nOFbpjKReVt2SiV5OASKNoC
	zgsX3dbkBBhOuw==
X-ME-Sender: <xms:7BFWXpB6UwXXciAZ_frGUvDNQJDIEIyipFblvhBKb-Pp_lcRhcTBVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgepgeenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:7BFWXqyX5lWVOkPWQcPTyaPaUZpWFmY9CVKO52cNp10CFLg2QnMUew>
    <xmx:7BFWXuCfzaIx7gUcSuQaYFv0f0A3fMdzlu-8sYQxytmJlF8ngIvuSw>
    <xmx:7BFWXvbNERzdi04bzvbUfXtt5mNPBHYByTUjub3czi2VCUiDTca_XQ>
    <xmx:7BFWXrLELRoj-OKJU6XO711na3aC1X3by3xkEPS94KEotpYCxKOfu8q_gpY>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com,
	Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Joel Stanley <joel@joel.id.au>
Subject: [PATCH v5 5/8] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Wed, 26 Feb 2020 17:35:48 +1100
Message-Id: <20200226063551.65363-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
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

