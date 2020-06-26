Return-Path: <SRS0=3XFn=AH=lists.openwall.com=kernel-hardening-return-19178-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C66C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 15:59:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FFEB204EC
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 15:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIT0I4Sv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FFEB204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19178-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28448 invoked by uid 550); 26 Jun 2020 15:58:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28416 invoked from network); 26 Jun 2020 15:58:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593187120;
	bh=FC+oTGAs23eBdDUGAh1t176WlXiIhxPuC7xFP7W52W0=;
	h=From:To:Cc:Subject:Date:From;
	b=jIT0I4Svp9S8w+HXR16FZk9s/faTxhTaNm36i51GkF7fn74oRQWEFERHLG8yNepyz
	 FWwlJ7coS8W53XEtJadpUIiZJe8VYj+HKj8HEO68/ckE+ZhblwIiopUXdgKe+nT4+a
	 Wal3iWhQeOKuIKWmkGDt0k71LhruutLjQpvn2CMI=
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-acpi@vger.kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	lorenzo.pieralisi@arm.com,
	sudeep.holla@arm.com,
	kernel-hardening@lists.openwall.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 0/2] arm64/acpi: restrict AML opregion memory access
Date: Fri, 26 Jun 2020 17:58:30 +0200
Message-Id: <20200626155832.2323789-1-ardb@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- do a more elaborate check on the region, against the EFI memory map

v3:
- split into two patches
- fallback to __ioremap() for ACPI reclaim memory, in case it is not covered
  by the linear mapping (e.g., when booting a kdump kernel)

Ard Biesheuvel (2):
  arm64/acpi: disallow AML memory opregions to access kernel memory
  arm64/acpi: disallow writeable AML opregion mapping for EFI code
    regions

 arch/arm64/include/asm/acpi.h | 15 +---
 arch/arm64/kernel/acpi.c      | 75 ++++++++++++++++++++
 2 files changed, 76 insertions(+), 14 deletions(-)

-- 
2.27.0

