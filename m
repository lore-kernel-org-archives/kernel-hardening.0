Return-Path: <SRS0=o7c0=43=lists.openwall.com=kernel-hardening-return-18113-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB79C10F25
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:04:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4366620637
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="JrKxWdR5";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IR4E/nLE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4366620637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18113-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24297 invoked by uid 550); 10 Mar 2020 01:04:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24264 invoked from network); 10 Mar 2020 01:04:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=dIh8uC/4N1UI+4ilbuZrGnP794
	RY0IvXvhY5yS9b+GU=; b=JrKxWdR5cimXKdB3kJvADgGfFXrnLGbPTQWUxkON3w
	Q+qF5nQpeOcpdgz18QPcLfhbPVhgtrMTi17lg8ACntX+YLTqQdFH2y62+5seyICp
	tC2PhHQbydxTqLaApejGNU9mn9zChFkK5BGtHmRvUay5qUGFGKm9dAErQYuUTxUg
	KkSIDPLtgf1wLKYCWtzaPK4W1husUoyMEqp9omfXsD1F9cGc4fU9uBpKr9XhMB9c
	dJqeHtU1ik1fu2ZKOtMCHz4eyf4oZRj8KA7dElpohTZ/Sky1FDYVer9dy9y1GIX+
	uqNePIEfSNKkT/iNTYHG2WMxl+yjHMUMXBgrrsjPfKsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=dIh8uC/4N1UI+4ilb
	uZrGnP794RY0IvXvhY5yS9b+GU=; b=IR4E/nLEUDG9fI/dFDrthcxr3DXUxQ0Lq
	JiiraKwnNwoujcmxZqMvG6QJ1WM75M9adiEKk7TthXAKqxBfMWaUlSJW4umQG5Bm
	djJhC+28mBw8qOlohw0THbqAAVsd7FNT8adfrESUAezvK7nPD2iNnYF8QhiajEZI
	wkFlEKZvSceCofVDdZZUR+K/bpcB9fk76u65IgnfRpvUVkW2HuZdZnqABSl0wxIz
	h5/BDQN6B4c3tTSDm/fGSYDm4nrWt5H7vu5B2oWyjSkmMDwhGh8hYJyEgvrQrVff
	msBeSZc/UObwu6BCIE5DuJoNdaVXIMuuCw8N8x/xlZJDay9fUuPlQ==
X-ME-Sender: <xms:g-dmXvFpX7lhQPftJpkmGDNYs9XTmo4nhQW73a5-BSQBEKyWYm4pIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenucfjughrpefhvf
    fufffkofgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgih
    uceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecuffhomhgrihhnpehoiihlrggssh
    drohhrghenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:g-dmXujOt0tDs5lC47uKCUTpi3f7wAcbCfey5PSIrDPnOVpUEUP7_g>
    <xmx:g-dmXj4cQRz90Ri3w62uETh9C0_is1poX7qDJWP1qJIE0hcy4t-0jA>
    <xmx:g-dmXoc6FC2XSSOJTuGdZdwIN3SDfSWv9IwBO8kYAb4gRslML2lNKA>
    <xmx:hedmXuIt-_36sLLBxWsCqd4E35qWRXVeAunLAXvKKfv10y4iTBppnw>
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
Subject: [PATCH v6 0/7] set_memory() routines and STRICT_MODULE_RWX
Date: Tue, 10 Mar 2020 12:03:31 +1100
Message-Id: <20200310010338.21205-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Back again, just minor changes.

v5: https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=160869

Changes since v5:
	[1/8]: Patch 8/8 squashed as suggested by Andrew Donnellan
	       Added a note to the comment of change_page_attr()
	       Rename size to sz to meet 90 chars without multiple lines

	[8/8]: Removed, change_memory_attr() section squashed, rest dropped
	       as suggested by Christophe Leroy (since I just assumed it was
	       the right thing to do instead of actually checking)

Thanks for the feedback.

Christophe Leroy (2):
  powerpc/mm: implement set_memory_attr()
  powerpc/32: use set_memory_attr()

Russell Currey (5):
  powerpc/mm: Implement set_memory() routines
  powerpc/kprobes: Mark newly allocated probes as RO
  powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
  powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
  powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig

 arch/powerpc/Kconfig                   |   2 +
 arch/powerpc/Kconfig.debug             |   6 +-
 arch/powerpc/configs/skiroot_defconfig |   1 +
 arch/powerpc/include/asm/set_memory.h  |  34 ++++++++
 arch/powerpc/kernel/kprobes.c          |  17 +++-
 arch/powerpc/mm/Makefile               |   2 +-
 arch/powerpc/mm/pageattr.c             | 112 +++++++++++++++++++++++++
 arch/powerpc/mm/pgtable_32.c           |  95 +++------------------
 arch/powerpc/mm/ptdump/ptdump.c        |  21 ++++-
 9 files changed, 197 insertions(+), 93 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.25.1

