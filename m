Return-Path: <SRS0=fJlA=7G=lists.openwall.com=kernel-hardening-return-18864-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8945C433DF
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 08:10:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F405E2072C
	for <kernel-hardening@archiver.kernel.org>; Sun, 24 May 2020 08:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="UkZ5fwVE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F405E2072C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18864-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24495 invoked by uid 550); 24 May 2020 08:10:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24460 invoked from network); 24 May 2020 08:10:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590307797;
	bh=Yh4A99YJCgkA9UbuO3RfCVtF8HiYdKwmMW3V19IImEM=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=UkZ5fwVEuQEPo519I9Bim3bwomLEMCwU16ReQvnBT1hYayPucK9Kd/yr2CyAsCfsP
	 cttCbWQFQ+AwXocbrl/2yj2bOPxeQILT1EJ4VN6HvtCFnMNjIHAmeqNFd5LCOMtyGP
	 ty0Qy/7xjEr6EN2mDa78Ajhq/ex8OuT/Dtbn6Sgc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jason Cooper <jason@lakedaemon.net>,
	Marc Zyngier <maz@kernel.org>
Cc: kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Oscar Carter <oscar.carter@gmx.com>
Subject: [PATCH] drivers/irqchip: Remove function callback casts
Date: Sun, 24 May 2020 10:09:10 +0200
Message-Id: <20200524080910.13087-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DPSzdRpyRux4A5kUtqLHMEMr9pHGkwQE+bKYyADNmfAZpC447sS
 BVR1oCo6gXQUg+ZC3B0H4u04qrR/36ilTAe4FoXmoduPjLqwXF8dgtNgUX7zQfXCaDLMl9U
 oz9L2o6IP2ZpdOHJ79dk10pmPl8bLERfuJOzdfmR/oZMiqlr7HgSMGiXXXPiKGSEveS1lFn
 hljV+i1ABOCLBauvj1Kcw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2CgksPlfxEg=:lbVsvV8SCTgDDaPaOCYklz
 OyoJ6CqTZX6vsMElVRTIXKQwIb3GZdtmDPZDs9f/O/96geY1kGCEiqcYmC7CedcxyBpwFr2aX
 RCuQT4JR2Wyj0Wy70477E/I4TmTwLiu8gvL13Ep9+LjfMj+EWq8wyBXCQKGh0NAdT7ZM1trs1
 2H4f7T5JO1YBNnSJ4OazykSas5qGy1P/0F9GHi46HbHW0vHQ0QjfTmsXIfZzMNQIMh0CsXfI2
 na6JQTMFrQfAfwtR2To6AHhqdiPNGeVTnEWtd4FA3XPvr7S+1ryLSideOgaFmrnDGRhuxmNAI
 wdk73/mK63o/ucMKYgVTwcZO2rnsq7G9j9Fcb5vfPXtArZpdm5iUYYr9Qka6giv2Pokl8slQ/
 gXZWJBpcggcBpPJIEeKdXfryDuOiAgxWhRH7wzR3458FMyxgD/fZM27BqRLAGLd7ieLU/nmHo
 6JcfeCYyKqxoegB3iqbdPB8xjkPjxeMQ79nMf4/u2Fs4WQqe4/PcFZ3LqNf+vG3t24Mlxf+d2
 U6HoYDNSU7RRG7Gac9ZEFwc+jK6cKdHzhnXShBr5L57xBhQ83uLHjkH0oLuEbsONdVZeElBJh
 2ZsqJmwCJPcQn/t7v/EGCnMM659/FCkxRqTSuVNj+OVvQbrJqSxIkJo4/38eg6d656wTrUkn+
 PChQmeMS7PBLoIiuUPhqMPCEas/xFGR/sZ2dk0i8tMXurbIWxzHBthGtLghuJ3SuJFkuBawie
 yeIs2j2KjFvs4jZy/BmfJMg8BNWCx1UJXD9QS/sPF0b89IY0LSa6N2Fv2URQwOIvYCbz9Co5D
 yP75P5QmwF6bTFNune7Z37zG82/UhUwDxqrOmqwGbLmwMFZ8YXDtSg9b7sXzfRyGs1K8ihISy
 WB5h/sPxKrWwUleT+Vdn4YUFlXs29iwc7yFsvWUJzpAZDhPXpum+2IZOw8cSt+7xf/1O+RlHG
 RuhDlB7F8ERpxPd80LqKSuv99HmhUSkvHNiFv/q2WjvTrhnmES2Uy7T7aEsxaL5P4N/PmyRxm
 cWAMc5ng/qSMQ26ItQkTq+SfTLw9aWwqZSjxeftA0KqnxpZ0NRs7kHqq/GKDe4cy9i430bJbP
 qwkM8mxZpOcwCGgWbqA9xPu/LyYn6HZoUvdc+Iz/mm0eabzMqmXGQLiSsXrY6CW51kLz9eQ32
 MlsBGLENs4MZcXsYLBrpSsb7ilQnPGG160geMK6xFdZbEgCAaK7gv2CearH0mPtDkhCopX63C
 +sfOsXti/aMf+X76y

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, remove all the function callback
casts.

To do this, modify the IRQCHIP_ACPI_DECLARE macro initializing the
acpi_probe_entry struct directly instead of use the existent macro
ACPI_DECLARE_PROBE_ENTRY.

In this new initialization use the probe_subtbl field instead of the
probe_table field use in the ACPI_DECLARE_PROBE_ENTRY macro.

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 include/linux/irqchip.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/irqchip.h b/include/linux/irqchip.h
index 950e4b2458f0..1f464fd10df0 100644
=2D-- a/include/linux/irqchip.h
+++ b/include/linux/irqchip.h
@@ -39,8 +39,14 @@
  * @fn: initialization function
  */
 #define IRQCHIP_ACPI_DECLARE(name, subtable, validate, data, fn)	\
-	ACPI_DECLARE_PROBE_ENTRY(irqchip, name, ACPI_SIG_MADT, 		\
-				 subtable, validate, data, fn)
+	static const struct acpi_probe_entry __acpi_probe_##name	\
+		__used __section(__irqchip_acpi_probe_table) =3D {	\
+			.id =3D ACPI_SIG_MADT,				\
+			.type =3D subtable,				\
+			.subtable_valid =3D validate,			\
+			.probe_subtbl =3D (acpi_tbl_entry_handler)fn,	\
+			.driver_data =3D data,				\
+		}

 #ifdef CONFIG_IRQCHIP
 void irqchip_init(void);
=2D-
2.20.1

