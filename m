Return-Path: <SRS0=TUKg=7M=lists.openwall.com=kernel-hardening-return-18901-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD7AC433E1
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D06572076B
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KOnE/fEg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D06572076B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18901-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12146 invoked by uid 550); 30 May 2020 14:13:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12061 invoked from network); 30 May 2020 14:13:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590847975;
	bh=VwkT9W/eCoeMypTuqR4X64dMx6qnkNnC0OSefVf8Ut0=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOnE/fEgwMGIRcV+X+JFG01J41kK3TwmN9khzSF4Hs5bGbrBGra/AXxWnznHG8uKe
	 y3OEWZ8tm0uojFo01dFKzmP/qO6u0r8dVfQLESHtGaa4YsRLl7grwP97KmEXAC+qCm
	 0X/KXT+9pKxM5S7LL2oWVay1wvTDC2b+Q9O/T8fc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	Marc Zyngier <maz@kernel.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <lenb@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: [PATCH v4 2/3] drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
Date: Sat, 30 May 2020 16:12:17 +0200
Message-Id: <20200530141218.4690-3-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200530141218.4690-1-oscar.carter@gmx.com>
References: <20200530141218.4690-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KSFJmjg5dkwrVKgtoNNJGFp5HGBWuPjWSuoaFf3Pyd8FrL91ODF
 D0aKga5ATiXUGeeglnF0FS7ilmNRRmHJvLFfs1pxJzlZi+Wz0MF+qSMOc/qHS6WzKA2Pnbf
 2JTQvaHJcU+nL1/YKfoj5op9ziwODLSiC+CFWx+iCFBCpgEOOOXqUVASECaajogHxlXwBap
 fbwBF0PwDbLxHMn8F64Eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qORPe2HUidY=:yIsJzNxV6Spub5Z+bZyi93
 NwWxNzvCiTI70Hwz9u82g3hLT4YMU+QGXyJCBaha+0DY0DltbB/bWQCDKTCxwS3WAVX++NHef
 XI5YwGXWiv+RyzsrRGjNvKAyh+Y0SI4GFq+18i/7LQY9s8rOjOUkB/n4JlSc5OKKv0HYoxxhx
 SO4wHaOogVZ9flzXV1DDLaiyt9wuVNXPAZnp8MNZOTftYoAFmfcd/3Cvy2p5kjGSxiEoas8aX
 +T8BChYG00rH0vQs7LcjEL1fTLZR1c7UTO+XKA8+nrbfoG6ZZGBd74OfCRmxHBgt75JugEixu
 UkhHcewKqsdU4nFcYIaTJ5gYZA03WYC/UB6MoD42QcCUz1UWUQCpHFAD8Ao9LW2QA0wH+tnoO
 t2Ebl6Rp5n1yLgls566SIApdeGxUfOirew7yBq4pmeHbCkaCEBeMHGhHA9Sxz4QnJ21tZg/ue
 eAkTKV56FKkRnr8q8QIf2uzY4f0Jv+NaBG9a0EKxnEQIvGGa6DuHtr3Mhbav4zymIF8eXNJs+
 5O9/6orAV97dS2zwLbyc+7eZuMtqXjSKabDK2b8SR+hZWTrmeWSswaEIHcViVaBeD5BUFf1a7
 /eLifMSX1c1TsHbesZJZl1Q1qmwHCMWj9/QVE3wz859XkMbjL3eS3KPNLraQLni7Gvfl89kWT
 UEA1Bm8hBiaIEiEuX5z9+SF22hOOvNfPJGsMKhR383zTmXl3q/i9delze75mzskeuEB+aRRPS
 7nGYIua33/rZAuUoCaUWfeTofbiD4Ty3wF+/hWKAYRNhnQoEubHNDMtocF2s0szh9tJfCi1Fk
 lxeDO1QB06l4K+BhDt8JCpafgHY2oUTuUuZbpcz0Wv7bM0WoYIokoxABNBUtnI0uWC0XOYY8z
 3J3VsfHZGdyMPeeBI/i8agDLEAWc3Pdg9W8/65dC8yo+KCEmUhqo0EKjNalKosY5AxVAmnJjp
 XIpDTvkSjDZI1f4ZgDo0dPDJI/uBzNPOGtGv/0tUHg4+NuTLxYO9rzO+2IVRYXj8HCg232gag
 8E3ZqG1v/UDgNzbf/ypZUvk9/l1zdrmlmlNWixh6fbB5OUuNAumAGRuYbWjDpBaET9aWLI2Kt
 f2CwRWH5kQHw8W9IXt30iMwNaqVWfQn4Z7RkO4llIfHAXFF1PnDaY9M7XlfdHuopPWopPKyJe
 /24nvi5DSh6l1di+x27tyBshtMbeSYCLlelnROYVSThNwnKR4UbGGR2r9XELC9EEHAXWg3JCc
 D2a3kF93yCuK8TXKT

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts.

To do this, modify the IRQCHIP_ACPI_DECLARE macro to use the new defined
macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
ACPI_DECLARE_PROBE_ENTRY. This is necessary to be able to initialize the
the acpi_probe_entry struct using the probe_subtbl field instead of the
probe_table field and avoid function cast mismatches.

Also, modify the prototype of the functions used by the invocation of the
IRQCHIP_ACPI_DECLARE macro to match all the parameters.

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 drivers/irqchip/irq-gic-v3.c | 2 +-
 drivers/irqchip/irq-gic.c    | 2 +-
 include/linux/irqchip.h      | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index d7006ef18a0d..3870e9d4d3a8 100644
=2D-- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2117,7 +2117,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 }

 static int __init
-gic_acpi_init(struct acpi_subtable_header *header, const unsigned long en=
d)
+gic_acpi_init(union acpi_subtable_headers *header, const unsigned long en=
d)
 {
 	struct acpi_madt_generic_distributor *dist;
 	struct fwnode_handle *domain_handle;
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 30ab623343d3..fc431857ce90 100644
=2D-- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1593,7 +1593,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 	gic_set_kvm_info(&gic_v2_kvm_info);
 }

-static int __init gic_v2_acpi_init(struct acpi_subtable_header *header,
+static int __init gic_v2_acpi_init(union acpi_subtable_headers *header,
 				   const unsigned long end)
 {
 	struct acpi_madt_generic_distributor *dist;
diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
index 950e4b2458f0..447f22880a69 100644
=2D-- a/include/linux/irqchip.h
+++ b/include/linux/irqchip.h
@@ -39,8 +39,9 @@
  * @fn: initialization function
  */
 #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
-	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
-				 subtable, validate, data, fn)
+	ACPI_DECLARE_SUBTABLE_PROBE_ENTRY(irqchip, name,		\
+					  ACPI_SIG_MADT, subtable,	\
+					  validate, data, fn)

 #ifdef CONFIG_IRQCHIP
 void irqchip_init(void);
=2D-
2.20.1

