Return-Path: <SRS0=bGmB=YX=lists.openwall.com=kernel-hardening-return-17158-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A72CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:31:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30A902054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="sqo0sz7g";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UlU/1t96"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30A902054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17158-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30213 invoked by uid 550); 30 Oct 2019 07:31:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30175 invoked from network); 30 Oct 2019 07:31:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm3; bh=mssX/JsM5ogaFI8hQrBomCiQNI
	6JK2VPU5sG5BOkvxU=; b=sqo0sz7g86Zgw122bLtbPZXSyq+qdB54dZkslVfD9g
	oIiPN29EbfFRX837pTasKQ4ODTfrbbliCT00RMBZt4auyNeQVfF866uiPflgZjdn
	I5ZilGYgkoXdxJ/dtn1zUwLeo4h03we7HS2681l1PPp4GS4ZhK0rxV2NUX/kP5ap
	Wf+BTHdFTx84gDHFRJf1tmLFIITFMGrz9PSSMjX9M6tYonFNuL1gCa5sYMxRbB4Q
	ORzOjQWT5z4apZ48HV9dflAa+IpfIUWwo5yYkPiwTKDFxB71xQcxZrooLeZT6W81
	OsDnySJEBguMBbABub3vwxRXoLyb4Mh0X/KgwfNAu3ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=mssX/JsM5ogaFI8hQ
	rBomCiQNI6JK2VPU5sG5BOkvxU=; b=UlU/1t96timajT615rqwG5vx1QR/ipwar
	GTfCWVCfmMC3vqzxfgb+h4/+yxATsglYSul146vmEt2PNJP4rT8548Gi6r2UFjOE
	+/E2xClckV/BJdNsLRpicDTjJFItktu1DahPipNvLcUUG2RLJ9oqjNhDtck/zhXW
	ZAfROFeQvMHJA4S+YhWYfGAXObcJ1FsoGQYiTAFiYh3b2m3Wl32dBxcXJPRqRXkq
	BJLwT/pyJDL+CKwSGuo6XwytfS+UY8P2RG2fGyoiJH/dGgEQHtXtYoJlCQZtCocc
	fJ1QHPn7py9Vz0pq0bu4SQ2TiWCL1GFIap85wxzty8PqY+FjOICDw==
X-ME-Sender: <xms:VDy5XW7ZHKuyUF5PiPYbrX0pTPXYtKhNHi0LXCBbVSbPhTQsDPJmng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnegovehorghsth
    grlhdqhfeguddvqddtvdculdduhedtmdenucfjughrpefhvffufffkofgggfestdekredt
    redttdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruh
    hsshgvlhhlrdgttgeqnecuffhomhgrihhnpehoiihlrggsshdrohhrghenucfkphepuddv
    vddrleelrdekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrh
    hushhsvghllhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:VDy5XRG7LNlcjNlLQVPdXUF0pdPwMu-WL54eoXPcISXCJUIYzWEB7A>
    <xmx:VDy5XV7Wg77pnKBwN-vJVMjT15YB1gScIeRyXhRcsZ6k044sQs5ITQ>
    <xmx:VDy5Xcg9ri8eJDLSrSK3VvSdYDHg8zOZrjkzNu2K4q5yHrENS2z-jw>
    <xmx:Vjy5XY01lPbca6uwyt4o5O3TJRH5t2KUIeLjCw_4g-5LUf9icc5d_drLuxQ>
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
Subject: [PATCH v5 0/5] Implement STRICT_MODULE_RWX for powerpc
Date: Wed, 30 Oct 2019 18:31:06 +1100
Message-Id: <20191030073111.140493-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v4 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
v3 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html

Changes since v4:
	[1/5]: Addressed review comments from Michael Ellerman (thanks!)
	[4/5]: make ARCH_HAS_STRICT_MODULE_RWX depend on
	       ARCH_HAS_STRICT_KERNEL_RWX to simplify things and avoid
	       STRICT_MODULE_RWX being *on by default* in cases where
	       STRICT_KERNEL_RWX is *unavailable*
	[5/5]: split skiroot_defconfig changes out into its own patch

The whole Kconfig situation is really weird and confusing, I believe the
correct resolution is to change arch/Kconfig but the consequences are so
minor that I don't think it's worth it, especially given that I expect
powerpc to have mandatory strict RWX Soon(tm).

Russell Currey (5):
  powerpc/mm: Implement set_memory() routines
  powerpc/kprobes: Mark newly allocated probes as RO
  powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
  powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
  powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig

 arch/powerpc/Kconfig                   |  2 +
 arch/powerpc/Kconfig.debug             |  6 +-
 arch/powerpc/configs/skiroot_defconfig |  1 +
 arch/powerpc/include/asm/set_memory.h  | 32 +++++++++++
 arch/powerpc/kernel/kprobes.c          |  3 +
 arch/powerpc/mm/Makefile               |  1 +
 arch/powerpc/mm/pageattr.c             | 77 ++++++++++++++++++++++++++
 arch/powerpc/mm/ptdump/ptdump.c        | 21 ++++++-
 8 files changed, 140 insertions(+), 3 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.23.0

