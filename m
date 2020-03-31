Return-Path: <SRS0=JaAh=5Q=lists.openwall.com=kernel-hardening-return-18314-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA727C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2776D206DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="WTVQJnlW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="rf5sU28a"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2776D206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18314-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17562 invoked by uid 550); 31 Mar 2020 04:49:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17530 invoked from network); 31 Mar 2020 04:48:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=yY8X33qvg/yRwHhINvujWxa4XK
	uItnDDjdDahuZGPeg=; b=WTVQJnlWEiOA/heukWV5Hwoz7jZwL7h7p0pYQcCp4u
	2kvFvq08tkHLEQpc55+H1I+1MR8XbcuRw4/Ntpu5FHvzlhQLnu0J0yCYi/HyjQDX
	1km1XHQ2CfXzt42O5AR+EYPNiddupYpublxsN3CgyD98CFM7UT38yt2DqVSposHJ
	zd+EFm/zBnb1Xa7EwtyjDBbKauWLzVRErcyAIlapUXIvHewsBgXNjS9xMABz3kAC
	823ZS/b/34WeSSySGI29pE00KgC4R6Zr/UWga4MWzbBjnSk8seCqhPsYvjOBMRBY
	lqImRO3eoc18pldJ2njEkRbmMeP6kSeYb0P3Y/5/U2uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yY8X33qvg/yRwHhIN
	vujWxa4XKuItnDDjdDahuZGPeg=; b=rf5sU28amT7+teD62/QPQPQcdO+aAZURi
	4jrvcCHgCQacTOWvrAF+i8Oqnt/fjwtCw2eHhzBnyKHt1MAuFmk+nuIxLC3LLIy5
	gfb+lTs2AXq/IBSYY4bButzBAIAiHyz1Z75mNZV9HlR6yzQrPUIMV4XuFZrSFmBL
	bP3RlAA+hEL97vJP8+j5rcxwlgvkP0gLz3X2nBJcKYkcc2sW5bRT2smLsq6dkU8B
	nvgCPwgGX1EJSvf/SoYBPWNbcqxvLLcIxz/p2K7J6EI6EPJixonku1u+j+jikO/y
	ylKp6IlOFRcuvflDNmPp3V86g/zRa5WLyIdwsq0cXjZ5W5oN0RrIg==
X-ME-Sender: <xms:q8uCXhZ89m7wgrEPr1azLl5QZR58fjOjmz5kTXgFjNJew5ucRiRWkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdludehmdenogevohgrshhtrg
    hlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvufffkffoggfgsedtkeertder
    tddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduvddu
    rdeghedrvdduvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:q8uCXogqcm2Iv85hPvg9qfoyXQSuO4ca17wK4VvwCdZEuUi5vhOBZg>
    <xmx:q8uCXrZgZ9hIm-f06xH2JJul-hbkV1bEe4G4I8LudNzXm1FwC8Awqw>
    <xmx:q8uCXmNRdq16GQBtZxe_eFJvvu5eWLrNKo6ntuIpxmlCe5IV4DR4WA>
    <xmx:rcuCXreEe-rdDx-XBwx9KHd2PqAo0db0iIP-UPGVtAwqP-cKRz5ZWA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7 0/7] set_memory() routines and STRICT_MODULE_RWX
Date: Tue, 31 Mar 2020 15:48:18 +1100
Message-Id: <20200331044825.591653-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Addressing review comments from Daniel Axtens.

v6: https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=163335
v5: https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=160869

Changes since v6:
	[1/7] and [6/7]: Check for negative values of numpages and use
	      	  	 apply_to_existing_page_range() thanks to dja

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
 arch/powerpc/mm/pageattr.c             | 114 +++++++++++++++++++++++++
 arch/powerpc/mm/pgtable_32.c           |  95 +++------------------
 arch/powerpc/mm/ptdump/ptdump.c        |  21 ++++-
 9 files changed, 199 insertions(+), 93 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.26.0

