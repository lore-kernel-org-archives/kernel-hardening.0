Return-Path: <SRS0=Bfea=7M=lists.openwall.com=kernel-hardening-return-18900-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A1AC433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0DFB12074D
	for <kernel-hardening@archiver.kernel.org>; Sat, 30 May 2020 14:13:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SXoQBLmA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DFB12074D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18900-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11785 invoked by uid 550); 30 May 2020 14:13:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11692 invoked from network); 30 May 2020 14:13:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1590847972;
	bh=WpWBS1h4iFsnXoGPg78caQDYyu6KqHawDxsVmNiamSU=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXoQBLmAwSGqo4tCeYU/Zx9q0f8qgnTmsZDu0G7HdehPbWQCuNOyWD4hlShL3v1wU
	 V4kvaRPWDV8F03mTCEs9zNuwGmN5D5Ta3KTD6Lz2yK0ctUboEri3uCTOLlm5ypOuya
	 41N0gKDM6Bu8g+tk8Cer+K8PeREDkRODuJ/oc7SY=
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
Subject: [PATCH v4 1/3] drivers/acpi: Add new macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
Date: Sat, 30 May 2020 16:12:16 +0200
Message-Id: <20200530141218.4690-2-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200530141218.4690-1-oscar.carter@gmx.com>
References: <20200530141218.4690-1-oscar.carter@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/rzWHQBS9mAF5Dq69ySv2ghKTMSNoHsXtrY06FlbNlCLctBog2h
 GquuZ3gO8MDe6A8Z2BaeYjzuJ3fh0mT886iSp+41lefypofuNPMxqsapdxBE/HvGX24Ad+c
 x01aB3qMVALCkK4+nFlABsd3pJnKDuOUSKfFoUNRwgnmSU04m+fnLHMLN9HJoOvAEV5W+Ev
 aexHAq7rgG/Pz+XyFr/ZQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rZJg1BspP+4=:g9tGS7uJEgIj9WdvSdDiK5
 eJGRfi22XrohexF0AwzPv1+wsZtsv3A5+ArDMBs8BzoRlBQ//i9qJQnzC4uaA19S+tINecsYU
 B0Yf9/pnsP8FRRqouS6MW5Nc8Eere+xEh88Er04vnu5SacWm3uFp2y1HGTb73EINDQ2c1thb/
 Pz5urOY1VyPyy+DHe0Txhz0V8E639SStcjTVUIHzY6zvGGNJCfwCKwk9m7Arm8ArWOSQW9LXN
 ybRUWSmBZAPJiFVBqI7WkY13i0CTebH/dAIk0462nnEunCZ5E64LQQv4J6LGYPMBKvDQ0+WvR
 lRUK2MxwSUFGeUvigQBJdQ2QybiS0dOe5vYHcbn/ahpfbAPUub/razB5lOWwb/xKvqjIXKQYW
 tBLSv7k8dSf63PlrvG2wR0r6YbLan53+GCYNY1kwvNRj98/vS7lXZEv7ps2BZvlIrSE3DE0yN
 N4i9tAsjGoA/PAfs6YBO6KqNHANA4hyL3NCmL4h/vTfjDksKXXKGPuSO42nGrucLI1abHl/xX
 2mthkRQfb0Wf7BBWVhkXiPNgJavDKmfgzj5WSv/zHkwORdvS3OPLN2QcupgSxvudMzaW3TDFr
 nLm37xUgf7JRFZaxer5RKDE4tIKIo0im/ZnBsEy2QTkJau+pXpwaKo4Gm7b0C7YqLra5XRIyi
 bd6r6cZnQEG32eQ8hlZJtmeQGBdD2dpluaeA82CNVchtd/l6/bZ8gLKfLX1lKbmLSOftGiCzI
 aFaXA5l3eo5Ar9kYQyKeWEwa6WgHRBt3vtrCKU+PeNMzjuqW004WZ8dccclcrkQE8/V9LJL0i
 JLFBoUy86NzTfw7ONaDYgoJPXqIKUcyOYq13ZLmhE5CtBSS48D0RGiiNbTS78newGnjkq+8bQ
 V3ZDeVM6UVtDWW7aIttkpsugnBkIOy5sHxJtjUgeQtFXKAhR6JoUhzKuINzkcT3IxMG7ZL/V9
 tTYltu9MYlbXO0w+Ag6mKEiTQIzHohiQCeR2vfJW+IdtWwTz49HVnlKT4aQ45kdF1RH2PSu62
 /bY+fMKsErE9Aj2aRx9DbZUaWC5cCJirEhaz+w5pt0gOcFm4eGvl2+RZvbCbZuNmGkUH41BFB
 5E+kIWR6gfaOZxFr/gVWmXzI02dIeHXBxxutqTiZMQKR6xnSfyj0twurmm+m5Nk6ETzVAqso1
 3KhjSLlShUEdFu3+YEjFuVODEvpO6CJCSaPmonG3Y4M64nF+3EHphKxjjpoQHfJca+gmdzdRD
 Xk2glYlcudPVNtjTT

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, there are the need to remove all
the function callback casts.

To do this, create a new macro called ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
to initialize the acpi_probe_entry struct using the probe_subtbl field
instead of the probe_table field. This is a previous work to be able to
modify the IRQCHIP_ACPI_DECLARE macro to use this new defined macro.

Even though these two commented fields are part of a union, this is
necessary to avoid function cast mismatches. That is, due to the
IRQCHIP_ACPI_DECLARE invocations use as last parameter a function with
the protoype "int (*func)(struct acpi_subtable_header *, const unsigned
long)" it's necessary that this macro initialize the probe_subtbl field
of the acpi_probe_entry struct and not the probe_table field.

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 include/linux/acpi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d661cd0ee64d..cf74e044a570 100644
=2D-- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -1154,6 +1154,17 @@ struct acpi_probe_entry {
 			.driver_data =3D data, 				\
 		   }

+#define ACPI_DECLARE_SUBTABLE_PROBE_ENTRY(table, name, table_id,	\
+					  subtable, valid, data, fn)	\
+	static const struct acpi_probe_entry __acpi_probe_##name	\
+		__used __section(__##table##_acpi_probe_table) =3D {	\
+			.id =3D table_id,					\
+			.type =3D subtable,				\
+			.subtable_valid =3D valid,			\
+			.probe_subtbl =3D fn,				\
+			.driver_data =3D data,				\
+		}
+
 #define ACPI_PROBE_TABLE(name)		__##name##_acpi_probe_table
 #define ACPI_PROBE_TABLE_END(name)	__##name##_acpi_probe_table_end

=2D-
2.20.1

