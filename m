Return-Path: <SRS0=1MOq=74=lists.openwall.com=kernel-hardening-return-18979-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE584C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 10:44:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 06E1E20663
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 10:44:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="3jnAe/G5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06E1E20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18979-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5420 invoked by uid 550); 15 Jun 2020 10:44:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5383 invoked from network); 15 Jun 2020 10:44:10 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
	:subject:date:message-id:in-reply-to:references:mime-version
	:content-transfer-encoding; s=mail; bh=W+psDjWP34bkbGREKoNGTKiwX
	RY=; b=3jnAe/G5QpfRdhmbQNo/KC6yS+10Fj/j0sHOja4aJa6WQEKmPBksnzJPU
	4PjH2fbCASselEcm2VspxMQJsm7vJdmi5OpWBVSHAN4aOqvaHH/cuVNHi/MgvhUl
	cKoFNxP8rKxEg/tUSOW22eCKEj51G3kK1TrAJ37J1QI+Km++MIB+RTymZxgJzuJJ
	7rYJzWAjWAPz/vAWSYmgUeCIWy/m0+Kjz6KXLeNA3VZMMiOrB5ocUTK7AI3Zv8Im
	PwCQeORfydLLuqc+UA86L1DeLEkXqGS59WsJZdn6QY1mTTHbhdYzphppkbgrFHrm
	gGT5CJMUnpweZZGMpyUJPRipeZSew==
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	mjg59@srcf.ucam.org,
	kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	stable@vger.kernel.org
Subject: [PATCH] acpi: disallow loading configfs acpi tables when locked down
Date: Mon, 15 Jun 2020 04:43:32 -0600
Message-Id: <20200615104332.901519-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like other vectors already patched, this one here allows the root user
to load ACPI tables, which enables arbitrary physical address writes,
which in turn makes it possible to disable lockdown. This patch prevents
this by checking the lockdown status before allowing a new ACPI table to be
installed. The link in the trailer shows a PoC of how this might be
used.

Link: https://git.zx2c4.com/american-unsigned-language/tree/american-unsigned-language-2.sh
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/acpi/acpi_configfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_configfs.c b/drivers/acpi/acpi_configfs.c
index ece8c1a921cc..88c8af455ea3 100644
--- a/drivers/acpi/acpi_configfs.c
+++ b/drivers/acpi/acpi_configfs.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/configfs.h>
 #include <linux/acpi.h>
+#include <linux/security.h>
 
 #include "acpica/accommon.h"
 #include "acpica/actables.h"
@@ -28,7 +29,10 @@ static ssize_t acpi_table_aml_write(struct config_item *cfg,
 {
 	const struct acpi_table_header *header = data;
 	struct acpi_table *table;
-	int ret;
+	int ret = security_locked_down(LOCKDOWN_ACPI_TABLES);
+
+	if (ret)
+		return ret;
 
 	table = container_of(cfg, struct acpi_table, cfg);
 
-- 
2.27.0

