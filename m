Return-Path: <SRS0=MJc/=7M=lists.openwall.com=kernel-hardening-return-18902-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C7AC433E0
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A286F2074B
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="hSVTnX4k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A286F2074B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18902-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13631 invoked by uid 550); 30 May 2020 14:13:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13545 invoked from network); 30 May 2020 14:13:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590847980;
	bh=4aAFMoHtjyY/Q2RFBNxXGgd+DkpDJi7dqREis+/wdI8=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSVTnX4kBTDTy1eOv2iIoarNQ3WSaVS2CrZdsj8lVZ0jWEbMJwTSv7u72jBzvRSOI
	 RM21oS1cblvRC7TopVKQzkiJ2PBme/O1qKNmcLnYUnpM+rYAjv15xo2TijiCfUkKKl
	 ureeUaNvnGsIr8hASZdZh773MshbiY4k0/84PF2A=
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
Subject: [PATCH v4 3/3] drivers/acpi: Remove function cast
Date: Sat, 30 May 2020 16:12:18 +0200
Message-Id: <20200530141218.4690-4-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200530141218.4690-1-oscar.carter@gmx.com>
References: <20200530141218.4690-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oHXe89xpsuoMF9wFHTqM4CUIIcLdbkiC6aMpNXHAGF+bxFJyxhO
 irBB/KIQQ7139fmvSgWKMK3ZYF3yl02bZYtOfk1vK6O6SQ9dj5fwNJ5yYxAx3YiY31Fn7/F
 aS2Hmyvs/e/UkL6Z1+k/t9Ht2XZKAjqQdJEGFsGALSGs4ZZOg1dLv0dYfelmKbVxT8t/c5c
 PLUB4UL6V2MH0UxLF7U1w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9v+tb5wYTic=:Lz/Llf0nT+R+h7ush2e53D
 /nPuOCZcUavFFRXew3E0wdbyRXs1knXXvfAdW3QvLd2+g1N7BwO3JibnyjTH59eKlikioGsFv
 sq/j5WIdBtb8FDhpNUC3JGYWC5/uKbvAQJIfI/vt/tznpPVYjYKjFPG2AfwYx6MKSw/RQ8MNC
 t/gzUSZVhGFrLrIL7wyBb3iJugwjj5XlT4AYhhvdtFisPdLviWA2gI27emPnqdFP0FBgOtxvh
 uPwsWYZjk3bFURY/c1SR6qF8T//33g1cAba7gzCOMV9oqxjIR2VRD7QxPH8Q8PfMG60Cl5EHo
 hUniwBsmo7VFccu5ImAc3q2Dn436pCPZtA/iSEgqtMrQOLdAjyO8VUAW5+daN8EEJ7EJ93UGz
 atNAmSATR7SQWRMF1YZMd9p5f73zhdo3uYiVd8nlZK3KMBM6Szz0JijzxAOoAItWJVYEoTvO6
 9eySx6rGrvzAWcLz64MB1W5C4VVaTKfU4LAeSMAdWri3XU5HbTTriV/514QEURiP5iDLUTQJP
 GLrYTlo8Seof8LubURa8VuXazhoXi9ZioLPuI56FxDRr44DrI83qGM2+SSVg/zbJMd9UckDJu
 TVqBPSaarppPVivqNW4DEazMdJa7YzwuFRm/pAV7ZSYDPl6vhQK6IRusfzjnEhPilnWtfN9gY
 tka1zbUuVDlH+ZgiTlDXjTgOKfWiBPWCPZyNmqFSrpcqJfGfgrTwXnpn8oa3YUF32+xtWoeJH
 iqMjQkSHCMDL/VAphMyf2fzW7xtQJx/PWvFX70IZu8y14Ac4rr/9dy3t0OxNQohAyYReHe4Lh
 15Kw6VVdH3EHcft1sllLYEuJqJ0pRE9jpqYU6qadVsO/RxER65GP12sxWUJ00q22WuGKFv8bl
 seTSS7dzznHGvjIn+78qkriX+JUETNjFd1QDpMpqjqyW3m1VP7h95SbVCBDkLUxTsB0JaW6x2
 ljunxoNZ9of0eV35G7Ehwc5GqtIqUDGmHdIo2q8SJLob5VZ1EgeLuizoeBMD49TKhjPJdea4y
 qOoYtwuGUjWt53zzNxT9hvB12wvEWpZJ0yX1y7negUfBNOrBs0I/1vLBEw0c2CudxiccrN1VD
 C8xvX0AMoujHAhSxlqiaV6qDCYet4+/5/RGUhoOBH6fYnRMj7vDM4LXXHTs+WSDKI7QFU5Xls
 cfTv7qOtJvdjVfgSk90SvYKWeOtZdkTIgmDcY5Ju036K5MdxXQfIBvYMS2vk4dw4ZIxQfHtPR
 wsHBJqZxNHoe3gfI3

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

