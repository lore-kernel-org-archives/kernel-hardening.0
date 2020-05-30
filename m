Return-Path: <SRS0=ciov=7M=lists.openwall.com=kernel-hardening-return-18907-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9E7C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CD3002074D
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="B1TeUi/l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD3002074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18907-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32196 invoked by uid 550); 30 May 2020 14:35:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32117 invoked from network); 30 May 2020 14:35:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590849313;
	bh=4aAFMoHtjyY/Q2RFBNxXGgd+DkpDJi7dqREis+/wdI8=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1TeUi/lsLdF61Cx4hYcW/cBgnibwLwuRW8TIyY20DvfuYMbFI6azop1w/Ka/HlJF
	 k2N8TjmeSS5vrZw4NSVNs0SynWkcLuD61v0+QykvYZGmrUgZQjsP2Z+9u+dfL7PMiX
	 H0fehQpsOV/7diTaCdHRhK1cn0baJaNWjT+Dw6Eg=
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
Subject: [PATCH v5 3/3] drivers/acpi: Remove function cast
Date: Sat, 30 May 2020 16:34:30 +0200
Message-Id: <20200530143430.5203-4-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200530143430.5203-1-oscar.carter@gmx.com>
References: <20200530143430.5203-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6xz29xMs/Yu3U3voBqqhgHSTkGGG3eO26WFOTSFpn94tiVLeGJo
 9391DE3bF2rffmKL18wn9fc38q5tJZH0OtbCSJxW8rmTKheUcxGryjalUl/fmFZoPj+OCZe
 VvXOSEEgqGz1atkIVti7YuAEk81ztpUmLk9cf+fQL5egT0wtwK/CJBZ6f6qMbVj3dLnrRjB
 kgGlilYUsi9urRIlzNeZQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zV+G32aoxGg=:XgX1t82pM5W358TasTUFSl
 P1ufaS8tXtJB/PLAhx/HMX3E2OwF+a1JLTqdQqUA5sSOjbQslkhJHA/GPDKJik5AnbALZvtZ2
 PnatCLxSb5ZwGV7BTffjwemF4+/DAgKX4zBYyox9g8imMjb20rf7oIlx6MBssll37eqyjow9L
 f4zKpV1P0y8M18LFNztKOa2xKD4dp8BDBY+60ef6j0Gp0hYSfQ8rnUxucASIhI5OjH/O20AZW
 Cs1EcaekREKR8r1fRdH80ulEMBC3dbgcbUyTxt8PNSKR3Df+lnEMfxyYhUJ+4UxqpYZ/cxeqG
 bdeqkhifrCN37XP2g82lqB6A6LuhFW/QrInesYcghu6bofP3wkQxGzP1kagUVs7mYkncoKxOo
 7xmDgjwhRmvGhEAyTmScZSUqC7P+VmlxxmRgj6BHB8PpIGB58c4ECvUWfCxaYqxA4SRWdhruw
 EzfJ9PgOgk0J+U3gYkOmov4OsLmkoMJrxeQwnczi03pob4mDW0XNDfHRQAl3LEUBwboUFY1IH
 pPMqtOPEqpLx7oOeQFWVnm1Zjj/fnuVBVhszxsygelVin1mDU24YNZqWvejQSUF5VGous1QB+
 YwrURVb2g85wWXjKXTyRbTHynZuLU6/GxuVY+0AV8vdo2HbmniNOc515qzsdCghBS4hnS20dQ
 g1iTJlt2Z1H4A+DRSN0SaEESmFqlzBnCJQdvHAOIlVjqJinKKRwpr7BgwCu7exoPFLDCv84h/
 CFAahkFWCGofKjikMnAaMJi5cu3Ss7Xc0peNWzzUPPHpoDDhUbrnQ4oBB6bBoVky0fAi4tjYR
 T+j2jEjFEV+H9dL7z/cLg1nTTel3TzguzcLCD0zs9MtguCjEymLsUj4g1vT+Hw1ukORnGy6Vz
 bkHBtZ/bJEg7kmDzck0B4TzEZ4kRVPdU14WuyMmjVTqLB1kHZNazJVf6RD0nyisLdDNzsJ79i
 dJ8B2Iw2EBT5u0Lyg94nfI4FmZpnbuYE0fcPGFEoKlrSddCrz9gBgq22iV6M08Yta1S8f+Xee
 qx+Fi1N+kQlK4WFtF4RpJbEEH2kSTox9zT7pIFOGtOpM9h0AG9kU+neVHupNUhAOccdTIqrzi
 LwErGzOsxjL5zfA7dzVidm8TCtUwmtKV7w9T30/yKgDjvADpq0y7SWxd3jUC/tCXl0gtiu6JF
 jGY4TAS8EcYhp7rlKHTKZsjqXHxSFTFm/ggYn1hDtNy6XmeMhD70WZoGxbc+FGIOoaGoc52kz
 yDcHrSEHvk7L1KtDG

Remove the function cast in the ACPI_DECLARE_PROBE_ENTRY macro to ensure
that the functions passed as a last parameter to this macro have the
right prototype.

This is an effort to enable -Wcast-function-type in the top-level Makefile
to support Control Flow Integrity builds.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 include/linux/acpi.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index cf74e044a570..1cda2d32e4c4 100644
=2D-- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1143,16 +1143,16 @@ struct acpi_probe_entry {
 	kernel_ulong_t driver_data;
 };

-#define ACPI_DECLARE_PROBE_ENTRY(table, name, table_id, subtable, valid, =
data, fn)	\
+#define ACPI_DECLARE_PROBE_ENTRY(table, name, table_id, subtable,	\
+				 valid, data, fn)			\
 	static const struct acpi_probe_entry __acpi_probe_##name	\
-		__used __section(__##table##_acpi_probe_table)		\
-		 =3D {							\
+		__used __section(__##table##_acpi_probe_table) =3D {	\
 			.id =3D table_id,					\
 			.type =3D subtable,				\
 			.subtable_valid =3D valid,			\
-			.probe_table =3D (acpi_tbl_table_handler)fn,	\
-			.driver_data =3D data, 				\
-		   }
+			.probe_table =3D fn,				\
+			.driver_data =3D data,				\
+		}

 #define ACPI_DECLARE_SUBTABLE_PROBE_ENTRY(table, name, table_id,	\
 					  subtable, valid, data, fn)	\
=2D-
2.20.1

