Return-Path: <SRS0=n+9W=7M=lists.openwall.com=kernel-hardening-return-18906-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E3FC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86E0F206EB
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Gage6s6P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86E0F206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18906-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30279 invoked by uid 550); 30 May 2020 14:35:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30190 invoked from network); 30 May 2020 14:35:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590849303;
	bh=neh9UrSP9bO+wKS/cV7Mb81hOYu1y9//cRNSX6IME/o=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gage6s6P+ywkOKvWAUrO/6qoivELPDqxdLIDl7Gi2GWRuVJ8xx45oAKhuehIP5qlt
	 O1YyDs/DsSke1xiq6Qsyri2WFKGoe0FSGISrgwU7wXhNKem/fX01m3Pj5ZKXVkR8Di
	 vT36vpjo0yOEOqpPvDdPykXIgSVtfNWy3/MwgBgM=
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
Subject: [PATCH v5 2/3] drivers/irqchip: Use new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
Date: Sat, 30 May 2020 16:34:29 +0200
Message-Id: <20200530143430.5203-3-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200530143430.5203-1-oscar.carter@gmx.com>
References: <20200530143430.5203-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:M4l/lu2Ot1isOnN2R13KTRlp5jrXN1XOyn2M/ueqxzZSv7vJOol
 B4I+tRfi763kyiRl8FHathgnioeLXcUFcfGiEqsF+IY2BEa5iknZGem9joaTY1fivqg8HDt
 yVEdPaSqyfcjtKy9Uz6pNZAeUP0DCieRiGUQKy/NSlHOW+iyhaD7J35JYOP6b/e3Twc43YV
 JVZT1u7JJVrDT7BDyk37w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:98X3ue3PCK8=:Ro2SzzpR4fxqY6xevdTRxj
 Si+zeF8Jx/Ck5U6jDOItwHAgZhc6KUD0YbQE6Zv7NF0wzF/S705KH7lx0cKPZlNKJk4HOZg9C
 0SfzWyaD1+JXzLy7ktjrWE8C8of2eCqyCwcY2CBjfJOzNAvwQczfS19boVeIz64aeYxDb8p/h
 6OG5Fyxwc43v4nKRnTJ3iowBt6Zy1L5pnRbJ4EiARp7iYju/A6dDxbxHvA3l1ePX17N+dPpr1
 tQ3JKS8OkH3Ni39gKvKa/Grx/3kK6XyW+W2GltM+Sr8vyQNcKcNz5XC94m+Qvge6hz/Y7z/MY
 TMYPyGY3zz8qBgfW+zhdc0S4PhKF/7KmmOMyfozQHra2O9aeckCxnDReycfTzR0LuUR9Vz5ll
 snrz6yO7yje/DBkipzPybXdB6aA3U8mWDd0dhUZNiUZuiZOebk9OrZiYJm2A9HdAeKr64lyHi
 CXKO2Aep8bHLR2DhDvJ3EXWb+ug7ZMwScVCBBJg6TL9tjT4cHMjk7lXnNz1p3JPvErN28ob6E
 JT3xN0EU0Ks9EF3jyau3WYQwKeY3s64eFEXK+Uett94fK1aTAV0Wye7pCOOeBb4U7J2vp+JwG
 ELe9bJfu8jhePNPHEBFJy5xW0JncfVANKrUuq1ixp2T5mUYysd/XKApmG6zL/DwNS1ziUjnBe
 ERcbYXxzOxk1oTyZidzGRT7+d+k5hK/qwJwYTHUnMGinaqPA5xXU2lMbpMmt5794E1ZmJzozS
 YvUQCkF9bgoIZZk4t3HieqqQA7Qx2X0inLQ2WWYogCfiwQ1/rAx4lwrhnrKVwIoU3MVcdX1zW
 Ol2+7isFcMaiHrRE1rjGtLFz+p/me80JHtwJECQ2BI7K+mpf6DHOHCklNZHvW9E2DRHOVGP4w
 lKiEtAmwptzHL553zERLTNKztFCgomtt7x5mhpjtYRt3Xz4PaBzEzHXnTOqAXubeV2xGqlP9r
 0i8a5p7VI61JByjOXDlQpuNVv6Bpq19u2/KIOFS1/pwfm7iZBgb+LrLLgAZmPSdYpDd+5Z9NB
 3ffH/lpB7yBuqres4SKTOvZl0k176MSMVFy2N7UBCaFAbqKBYUt4otf5HBAvPO+fJT4uyx3ci
 3B9R+ZUYf6/1A27MM1EFdaXRUbPKlz76tVQ747vlrI+uoeImupOseTAfzXCQJCtD0qmmz9gDq
 B73bJxilzmR7RVBVnzgTK1fNRD4HqLbVZ73lyumWQlKYX29KJhDuGYZEiGgKnQ131T/VbQjcJ
 NGGlGTrjbdItsZhPR

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

