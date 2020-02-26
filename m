Return-Path: <SRS0=eUSF=4O=lists.openwall.com=kernel-hardening-return-17939-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE035C4BA0B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BFB821556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="bJ+ybytN";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YYhTw7Ip"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BFB821556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17939-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28553 invoked by uid 550); 26 Feb 2020 06:25:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28436 invoked from network); 26 Feb 2020 06:25:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=fIQUcfHh7QuR4
	38tK6lJLzDWB37n7jovUl45LUEKMUk=; b=bJ+ybytNw+AgsIL1M9PUKtLkAJyNb
	9EX+LPSQZRzQ3mSfNnh0E7cWyUb2vkxMxDKd7Cp/MrQC+aWIIdAqzK3KLBVhFsdp
	RfA8ZKKrDLYocx6DJxMoCIyEEdc7pNfISq5Bkj+T5ZCSevMCjP2GQpJNpLcg5U1g
	qeIfln0dxE8Pf/pCuzmCxK75gN6EEk+lLDyqwx69koesDTleXnxhpZ6zPJwdvQnY
	tIQlI12ZS8gTyXEheLg/hxpvD2NUq1J7mi6kTIy4LpZ1vnEg6djs3KWui7gFAD4S
	VWJmVC8jMasiZLRjcQ9P3labbHrtN9LMUGMVBDtmHxQ6PQnmbPGMLXXqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=fIQUcfHh7QuR438tK6lJLzDWB37n7jovUl45LUEKMUk=; b=YYhTw7Ip
	+MaYW2FOuBQoC0hwu15yFBuvVQ/M5BeX84WMuaEO7wim1oZIqKZxHaTTeBIbQZDa
	ABxkvXeJEp19sWyBOU59+5m5ukB8WPwglRp2/GmAEao5IvH/6l8WoEtVeKDe4qKY
	gwLWlcdIx4OWndHPd7o4InICAttG2a8TyH+2uNgSbpUz1ci2MD23Y440Dha7Adgo
	BR0O4iHa4rMD9jcp25HwdRsNLDhiM7A9p6wQ5ahAJv9YFPXXORNDpaCFTj2La05H
	3SWadYy5Cof3CHAiXHD/CnOufhPXlUnlPAr4RESi0eFfjyFYMyZey6W9FLie43By
	CB6kNaOz+2hCSw==
X-ME-Sender: <xms:Lw9WXorGNM58Q6lt7qGajM6EnKN0448xBnweSySu_76CvrzTzQkYCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgepfeenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:Lw9WXqRKkns6ewi7zPXMVs_CBnMaovIMJ4VelXmNEAmymrVr_O1OtQ>
    <xmx:Lw9WXvW2MLOLt6Xsmplr-_jKef7lnqEJn9CPwpEEur_QodkwBWWrQQ>
    <xmx:Lw9WXuRUet_5axeQu1Qzde_ncxsTUN_Wj_y9Exg-AGdYW0LkT58MNw>
    <xmx:MA9WXpMv7yQUHzQqWjn00uD2UZ6RldZvVLVwVGqJf7cs2eedmkP_ag>
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
Subject: [PATCH v4 5/8] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Wed, 26 Feb 2020 17:24:00 +1100
Message-Id: <20200226062403.63790-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226062403.63790-1-ruscur@russell.cc>
References: <20200226062403.63790-1-ruscur@russell.cc>
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

