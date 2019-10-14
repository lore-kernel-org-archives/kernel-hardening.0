Return-Path: <SRS0=XG6I=YH=lists.openwall.com=kernel-hardening-return-17016-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B878C47404
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A6A73214AE
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="ut4yuAgo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kHS//ORn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A6A73214AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17016-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10213 invoked by uid 550); 14 Oct 2019 05:14:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10111 invoked from network); 14 Oct 2019 05:14:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=lMkDjBFcfwIOZ
	6xfhLpVA4oe1RN5dMpcJAbN8HNarN8=; b=ut4yuAgoyJ90jsmHqs4X8oL9TKBq3
	nqlw/iwMJ3EfCtDn6kLxbs6WMU4M7R/1NrIgxx+53+o8balaPD91A/1M5ZxhiRDk
	4rn3F4Ox364EzDNKJnCYc0loUVGf5C1XGRB9tWKJwCPIKIL5heokLQ6DR7SQtr1x
	LaeaBgZ4CCLPY9S1Z/0b7693KShA+ARzVksnLI/PDk7tChe1KHcF/rey4eKbdEHz
	C2xgNcKwNNzQIvleacVDEhJ12in7x+GUItccT/naSWbaGJsm5t/TlFQthtkuE5QT
	O57MLuuCEsJi3iKI5+PCTwk2XRwTjbRwIt5+D4675m3gwfPKH4v2eP7Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=lMkDjBFcfwIOZ6xfhLpVA4oe1RN5dMpcJAbN8HNarN8=; b=kHS//ORn
	TeWTv9J31RxHGIbwfqEGn+lFqkBrYIlVcX4fgkpvZLQDe6Ft0ATpC0S2uhmeiVUy
	7T2TiQwPciYjgvVDVtPs38OfNxkcYWwq04sDlYENmL50KB7NsC/n0ulatdQ+KwSX
	tjvnbQ3ZXy6s9AoUpoxbyNljNJeDPVqELBsby8RScbtpczLO6Absd1zjO6P4GGjo
	TWJIkcr0+/XKfwVOGyxZnSiBUtlH96xEccgLbQwwxwEg/ekjPGfkosCOAFGEvl43
	wDuTEPFJxdautuKc696DISIJ+vzMITyAT4O+9qHsBKzD7IhlQCVmVTzAAdl7CsDo
	jfjRkbq7+d/kmw==
X-ME-Sender: <xms:FwSkXVtr2GR9aL21Ou5Fockf9ZvslH8abghfxuSwnMCai4udITWSpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedtgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdr
    tggtnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:FwSkXSttouP785Rm8AMId1LXY5DEuDnRP4eLtrnaLFBaYdrj7nUhbg>
    <xmx:FwSkXTwKjImec5Ld9iZMjyaMU7DZXK_ENsC17_XybYCK3fc3eZMEXQ>
    <xmx:FwSkXQhNIeh_BiF0B2tmyqAr2J_8vnHcsMnwLNGQ6bQF9eAWNXjr6g>
    <xmx:FwSkXaltl3GocEmej47kZHYTPuNJBNQqJByT4C364MFN0jDQNITQqw>
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
Subject: [PATCH v4 4/4] powerpc: Enable STRICT_MODULE_RWX
Date: Mon, 14 Oct 2019 16:13:20 +1100
Message-Id: <20191014051320.158682-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014051320.158682-1-ruscur@russell.cc>
References: <20191014051320.158682-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Whether STRICT_MODULE_RWX is enabled by default depends on powerpc
platform - in arch/Kconfig, STRICT_MODULE_RWX depends on
ARCH_OPTIONAL_KERNEL_RWX, which in arch/powerpc/Kconfig is selected if
ARCH_HAS_STRICT_KERNEL_RWX is selected, which is only true with
CONFIG_RELOCATABLE *disabled*.

defconfigs like skiroot_defconfig which turn STRICT_KERNEL_RWX on when
it is not already on by default also do NOT enable STRICT_MODULE_RWX
automatically, so it is explicitly enabled there in this patch.

Thus, on by default for ppc32 only.  Module RWX doesn't provide a whole
lot of value with Kernel RWX off, but it doesn't hurt, either.  The next
step is to make STRICT_KERNEL_RWX compatible with RELOCATABLE so it can
be on by default.

Tested-by: Daniel Axtens <dja@axtens.net> # e6500
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig                   | 1 +
 arch/powerpc/configs/skiroot_defconfig | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8f7005f0d097..212c4d02be40 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -135,6 +135,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1253482a67c0..719d899081b3 100644
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
2.23.0

