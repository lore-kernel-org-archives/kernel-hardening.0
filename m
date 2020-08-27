Return-Path: <SRS0=EddA=CF=lists.openwall.com=kernel-hardening-return-19686-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88D9C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 12:28:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B4AE207CD
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 12:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nps0Q3QE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B4AE207CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19686-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17957 invoked by uid 550); 27 Aug 2020 12:28:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7209 invoked from network); 27 Aug 2020 09:24:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=LKDlLMP9o2eEBH2C9x6MfpYAdPfjU1Lhdny/aQSn3mQ=;
        b=nps0Q3QE2BQWBse5vZkI+sdXMY2D/c8G5TGbzNAIOQra2MtG1iokjOZi7I6baSrlIV
         EgveQc89VgkQKqnNpSwL/Vq1HuuSoW4KD6yNV/RHFvYMeKf9fLBI9na6c/SLjM8P2NVT
         /ccSZKOHAc4TlTWqLSfnGLDWv0uRpigAm8a4Ri39nI4m9sPBQvR+lTxYixIIuxA7I77N
         BfNtKWHDiFGfE2IVyQHWKV2qt1wcuaIn9NwD+am9/UY7tqaTt4U6qDmXLPeJybvgcyfy
         xVJF91TZRLhfuP6JUuFF9UnD/8fVQYBlaicTFUIUWHoifJQ3tKodh7orhvTcVGaUetCx
         FZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=LKDlLMP9o2eEBH2C9x6MfpYAdPfjU1Lhdny/aQSn3mQ=;
        b=Sh1Y7p5QdOi2UFSLd8T7DlY5ecsS2kB6gu7Sfrmi9VQ5+JFOr3165H51zD+ug2Ibfj
         LUy8/5eyjcEvaTHHB04Jc1QnA9+3g92Pbe5eMZgplo4pmfEA/yYfDmC9FZBQ8K9sudog
         Ts1ixIIurRzqG/mwc63dU3GjzARUx7YLY4vQy1GN0cyNdz8kCYzSPAMHeJtQXWiWqT7/
         esEcuMRd3mUe8pasc7X8ren6vKxsVaPeXZyQ8+0webH4puQA3/zRLQhC5Xe3Bud6yLaa
         u4L229jGh6HBELaEaRqDfUfMmdDQw/Iky/sQpNULyCiAa3c+pp74NhBt6ih+WHLQqdss
         DG4w==
X-Gm-Message-State: AOAM531PQVW47PaFTFqyE1xD4Zmss8BI6qNxSdnFsm8EokgvxcaxJnp7
	pTXm0+GDhjDrrvesN8UNM5M=
X-Google-Smtp-Source: ABdhPJyJnn+Y0xkU7A6fORQ70ufnhZfpwvrdE3TVhKTWjAN8yS0FY5rJRek4AruTHw2j7KaURP9ejw==
X-Received: by 2002:a62:7d4c:: with SMTP id y73mr12907266pfc.137.1598520256334;
        Thu, 27 Aug 2020 02:24:16 -0700 (PDT)
Date: Thu, 27 Aug 2020 14:54:05 +0530
From: Mrinal Pandey <mrinalmni@gmail.com>
To: skhan@linuxfoundation.org,
	Linux-kernel-mentees@lists.linuxfoundation.org,
	lukas.bulwahn@gmail.com, keescook@chromium.org, re.emese@gmail.com,
	maennich@google.com, tglx@linutronix.de, gregkh@linuxfoundation.org,
	akpm@linux-foundation.org, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, linux-spdx@vger.kernel.org,
	mrinalmni@gmail.com
Subject: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7psxwnjzxvwj4cgh"
Content-Disposition: inline


--7psxwnjzxvwj4cgh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
spdxcheck-test.sh to the repository without the executable flag and license
information.

commit eb8305aecb95 ("scripts: Coccinelle script for namespace
dependencies.") added the file nsdeps, commit 313dd1b62921 ("gcc-plugins:
Add the randstruct plugin") added the file gcc-plugins/gen-random-seed.sh
and commit 9b4ade226f74 ("xen: build infrastructure for generating
hypercall depending symbols") added the file xen-hypercalls.sh without the
executable bit.

Set to usual modes for these files and provide the SPDX license for
spdxcheck-test.sh. No functional changes.

Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>
---
applies cleanly on next-20200827

Kees, Matthias, Thomas, please ack this patch.

Andrew, please pick this minor non-urgent cleanup patch once the
mainainers ack.

 scripts/gcc-plugins/gen-random-seed.sh | 0
 scripts/nsdeps                         | 0
 scripts/spdxcheck-test.sh              | 1 +
 scripts/xen-hypercalls.sh              | 0
 4 files changed, 1 insertion(+)
 mode change 100644 =3D> 100755 scripts/gcc-plugins/gen-random-seed.sh
 mode change 100644 =3D> 100755 scripts/nsdeps
 mode change 100644 =3D> 100755 scripts/spdxcheck-test.sh
 mode change 100644 =3D> 100755 scripts/xen-hypercalls.sh

diff --git a/scripts/gcc-plugins/gen-random-seed.sh b/scripts/gcc-plugins/g=
en-random-seed.sh
old mode 100644
new mode 100755
diff --git a/scripts/nsdeps b/scripts/nsdeps
old mode 100644
new mode 100755
diff --git a/scripts/spdxcheck-test.sh b/scripts/spdxcheck-test.sh
old mode 100644
new mode 100755
index cfea6a0d1cc0..e2902520a081
--- a/scripts/spdxcheck-test.sh
+++ b/scripts/spdxcheck-test.sh
@@ -1,4 +1,5 @@
 #!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
=20
 for PYTHON in python2 python3; do
 	# run check on a text and a binary file
diff --git a/scripts/xen-hypercalls.sh b/scripts/xen-hypercalls.sh
old mode 100644
new mode 100755
--=20
2.25.1


--7psxwnjzxvwj4cgh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE8DwCG1PwaC2uTI99xIwpEWwxhGQFAl9He60ACgkQxIwpEWwx
hGQO/BAAirslyT/RyRsBnm80OnJYSZ0oaAjsSp0sC0LHZawGPPnCbrZRjS/6FQBe
kKJjI/Y7z7Hi38d2morG9nKhvcjGonI3vxSysJK4/LSD2FvS9FcKJkfHYsf5HPOj
BNqRNvN+CGvUtV6EEBvMoRafI5xAqXinpglR7yd094qv/SzNTL60QtMXVCNiKaph
5kemWnjMmlJQDJVxsK0qVSN5yfGhwt92DUHYBdabPgBMLPADdk0BKo/FHCV4vO5J
8Cz4fGZmO3p3trX5bPTXMMVbhRC2IPHHK+bscQZ3rPAHRSfccTdmN4tP32dQjXiZ
0Dq+QNuTSxtsTdAVXFUCy55CtFGVEl4GXkPZHaWX/jRqpqcvmY4Ih5TgX25MS8gB
+hlVbQ+YQraZRezEdYzt53Orkwlq+8j/I2UvKBs5sBRYMiCnz3DVj1BgKheCL8vI
id5nUpqSCRQau8UWRZgdTFzZiIrs9JZq1qzT1v8U3XVQGRb6XtQWoewYlnP431YA
1sIbVErQKgp+Hrtjdmj/I4shV2Poq1ppu1bpBorMBuZdcId8t6FSqipAi+UaNpm3
lMZ7w0z/TmzAEMCkXlrzh9THaCzbrhclf2cte0IvVvb8NYc+NajOPhVVgUObpFnL
yRODk3RXJK+fDf5fKPnSrHmbBlItBXnncrv32bV2lW+/jc3POSs=
=5uhu
-----END PGP SIGNATURE-----

--7psxwnjzxvwj4cgh--
