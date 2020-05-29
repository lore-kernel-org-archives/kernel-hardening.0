Return-Path: <SRS0=tB6X=7L=lists.openwall.com=kernel-hardening-return-18895-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4038DC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 17:19:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 969002074D
	for <kernel-hardening@archiver.kernel.org>; Fri, 29 May 2020 17:19:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="T1T9LR/w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 969002074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18895-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7984 invoked by uid 550); 29 May 2020 17:19:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7897 invoked from network); 29 May 2020 17:19:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590772765;
	bh=neh9UrSP9bO+wKS/cV7Mb81hOYu1y9//cRNSX6IME/o=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1T9LR/w3kBuqWO8Su09Op1EFM06tPZn4twLi9YwSV4LstFuZw8hrEoa5l5R8Ij+u
	 ZhaED2tY7CVwC6hqKCXXxiMNO5bZyR/xtHF6Uuq1dsQs6PfCfmY/avjTdNxiXYzpcP
	 EFtXIpEhp+7VbeTeVLwOTO8oifcEU8hmbUULqkx4=
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
Subject: [PATCH v3 2/2] drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
Date: Fri, 29 May 2020 19:18:47 +0200
Message-Id: <20200529171847.10267-3-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529171847.10267-1-oscar.carter@gmx.com>
References: <20200529171847.10267-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Xbh6bc2AmKF5eUpe1JkLy04Gyi3Hb9L75YPMV4IOuT+BURFd86X
 QvCGG2899ZFmQmHxw4xv0sgrlbLGNr6vXbyyEUTV/j7WUl1KXnS/cSM5ZOFaWzMkqwMOUlh
 lAJfFVQQErGpc1+tiKPw+AKBMTpJ+duPgHDtZcDIR2dt98493If6An2WKlqLdDcZVvsdgWm
 i4pAUsQPQz8viQ6vtuxGA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cK5pSdYPuYw=:cgBVRC43BeXuVFlw7NN1y5
 UBXR7VOvd0fbpnIL6EOPaqUSD23+KtXJCFi13A1RPvw8934ONa3QUNJ7HeK/a5bELNDW7b3YV
 KpTux8y6DvlapqfhfKnBO7UQdH1mCUag5uLd2i182hO7RMvZGeS3z2oacIuSL+RSGk9WNlv6z
 zO65gGkxuJ6zKQ40vXqeWeExhzToVnsnUvPQrWtay+tn2biPumJz7OW9gs+hg7UnsZC5UBNt4
 6sLnj3EAJ3+rCMalXr4hJZEqzF7QkGNjfZPQuhEQGvoNptSDGoNK/SVDnIlNONYolOex5b2xF
 l4OR1jWPkPgpgfCimojidEoKin2EOE4GIiWTIYemXBeDT5ge8tpjsgam6RyakcNL3vKFnimRp
 OEeEoFVAhbQx7ag34TEdyZNAIBIMA1UbLQqAYE7UkKe88alRgBcxkIUGwFrM4VrlFFKpnf0zq
 aMeMXpeLnwN/me1S6Ua/QQDh6a9GKaBI24WI5MBAV/NTT3Nb8A1uIEIXbhIK+6DI8Vjw7i8ZH
 FXPpQyQVgxAbv79UcORvXb3CIqQOendix1Wv+xVum9hlR8DnSa9SNwDBgcWkgNO66s4P/xOkR
 LHbYU5feM+QDugil6JBHIp4zng6vfNOivSdrlQYGqGBBXO0FH+6PulUw9HPSvYtbQALOjgUuj
 SzSkhRkjkJxNsKX5V69hnISQApJtYKEsS+hVrDq1aQUL2oT2xEeBtowactJKMHGJjJyzTJ74B
 CErkJPo9H2mmYdekKODtaN1f5AciV2dquEQ4TrZYhT6odGevQ8b+AFAYy7T9QffDiTmmxMD+7
 d++FsMUhOU14+kbGAMHvURc2e/4+sQdmHgD30AO3P+5TxeP+0wsXY1OpbkjU0uyMy+heXlkXt
 MQU0HWuo5plfNxf7lFqtCMHCtBr6EvywqKFZdock4Ux28MYfR3Tkmc30hxehESkh9eNpqkot+
 +9MQOnIjBslV8o/OIIKFBqwCEYQEJV0mnvxcfqJaPTWGLI6wLp6WDMiavYTxiQ1Wn5MI5cH+a
 zJEV44S/t+juj945Snbv+AyrmHKEqXYFjXN9vOjkVfdeT0MUYHUAXcn1WZqgDj+lETTD2cNAv
 87YicXY4DNA7+t58loMex8QgKKsG5fwW32QziQXxbLGxAsg5JSB9xgtQwlT5O57mZF8YIRkFM
 3hjnCIOTRWMXbjZvmAls+EGFwqVP0BBo3O6nDyTf1bbPduV0ReV+HL6X+e28Bxod0ZNLwFl13
 qMzqawkInlseylrYd

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

Co-developed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
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

