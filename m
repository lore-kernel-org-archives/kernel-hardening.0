Return-Path: <SRS0=ryfl=AD=lists.openwall.com=kernel-hardening-return-19031-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A2EC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 09:27:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A588020708
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jun 2020 09:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bE16+dF6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A588020708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19031-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14281 invoked by uid 550); 22 Jun 2020 09:27:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14246 invoked from network); 22 Jun 2020 09:27:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592818048;
	bh=hWYKPFE9P3J3avt6bqZOYDK5HSShSgcf4lckraPXxZA=;
	h=From:To:Cc:Subject:Date:From;
	b=bE16+dF6SMSB5UO6GsVEiN6JX0rN2w/xk+OGYKNTJUb+jGdZHEf7uhLnvFNC8fgn5
	 Mr55iwAYSjwONJdCYnZn47MA3E/cI6HCCIsD4uAI8lk2WI/oUkrLWVdRioBvc3fBJv
	 WTFEQKNTOlPW3mjJXXTFlE0tK5F/mPg4jxf13T/c=
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-acpi@vger.kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	lorenzo.pieralisi@arm.com,
	sudeep.holla@arm.com,
	kernel-hardening@lists.openwall.com,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access kernel memory
Date: Mon, 22 Jun 2020 11:27:19 +0200
Message-Id: <20200622092719.1380968-1-ardb@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ACPI provides support for SystemMemory opregions, to allow AML methods
to access MMIO registers of, e.g., GPIO controllers, or access reserved
regions of memory that are owned by the firmware.

Currently, we also permit AML methods to access memory that is owned by
the kernel and mapped via the linear region, which does not seem to be
supported by a valid use case, and exposes the kernel's internal state
to AML methods that may be buggy and exploitable.

So close the door on this, and simply reject AML remapping requests for
any memory that has a valid mapping in the linear region.

Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/acpi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index a45366c3909b..18dcef4e6764 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -50,9 +50,9 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
 static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
 					    acpi_size size)
 {
-	/* For normal memory we already have a cacheable mapping. */
+	/* Don't allow access to kernel memory from AML code */
 	if (memblock_is_map_memory(phys))
-		return (void __iomem *)__phys_to_virt(phys);
+		return NULL;
 
 	/*
 	 * We should still honor the memory's attribute here because
-- 
2.27.0

