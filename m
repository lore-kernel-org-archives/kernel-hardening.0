Return-Path: <SRS0=ldLv=AH=lists.openwall.com=kernel-hardening-return-19180-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2EC6C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 15:59:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F37C9204EC
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 15:59:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMTRSoP0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37C9204EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19180-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29955 invoked by uid 550); 26 Jun 2020 15:58:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29837 invoked from network); 26 Jun 2020 15:58:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593187125;
	bh=MI1bCIGMLcKccd2dmrayi3mwq6PLyLqFmsxPhzVVj+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMTRSoP0LXtmeOSgiI76477HiCGpazaJWj4NOXf4jg37wdu7QJRO+hgH7/lbWlegp
	 YbMVEvycZyfYFIw7lvXVRybyHe8zWKkHfI1tp0NnY6Ii7+0F1yeppV9UA9SqboJnmG
	 d43IUvvLg9Bbk9CBd3EtE1y9ClPj/ONI/O8B3hsw=
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-acpi@vger.kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	lorenzo.pieralisi@arm.com,
	sudeep.holla@arm.com,
	kernel-hardening@lists.openwall.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 2/2] arm64/acpi: disallow writeable AML opregion mapping for EFI code regions
Date: Fri, 26 Jun 2020 17:58:32 +0200
Message-Id: <20200626155832.2323789-3-ardb@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626155832.2323789-1-ardb@kernel.org>
References: <20200626155832.2323789-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given that the contents of EFI runtime code and data regions are
provided by the firmware, as well as the DSDT, it is not unimaginable
that AML code exists today that accesses EFI runtime code regions using
a SystemMemory OpRegion. There is nothing fundamentally wrong with that,
but since we take great care to ensure that executable code is never
mapped writeable and executable at the same time, we should not permit
AML to create writable mapping.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/acpi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 01b861e225b0..455966401102 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -301,6 +301,15 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
 			pr_warn(FW_BUG "requested region covers kernel memory @ %pa\n", &phys);
 			return NULL;
 
+		case EFI_RUNTIME_SERVICES_CODE:
+			/*
+			 * This would be unusual, but not problematic per se,
+			 * as long as we take care not to create a writable
+			 * mapping for executable code.
+			 */
+			prot = PAGE_KERNEL_RO;
+			break;
+
 		case EFI_ACPI_RECLAIM_MEMORY:
 			/*
 			 * ACPI reclaim memory is used to pass firmware tables
-- 
2.27.0

