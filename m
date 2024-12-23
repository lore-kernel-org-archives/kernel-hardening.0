Return-Path: <kernel-hardening-return-21911-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1FEF3E7718B
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Dec 2024 16:29:21 +0000 (UTC)
Received: (qmail 23578 invoked by uid 550); 23 Dec 2024 16:29:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19568 invoked from network); 23 Dec 2024 16:28:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=protonmail3; t=1734971294; x=1735230494;
	bh=bqyMZPUwM8jdoQ7R6OfI9h6Twr/FyoQIi75Q+q7W9u4=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=dKhJz62UltxDlEmpJaPB4/KU5pncU8BXKp64nZSktCoyu/p2SxGL/p6GJpNE+niVM
	 oRTB6rnkEDxmmsmUR26ZKa7rx4G5gMHFNNYG1jmZCQJV1j3uAyYOLrg0nnXiVGQbDg
	 uBrJVPK+TDnUpBmeW+AZK6tB0Q1bmA+R35d0U1jSf6EJlRN6MyUbjlWv2Mn8OG11eQ
	 r7eWB6KuwZlt51nk/OU7MIERljnMPVX34wr7tabRX/v0mbScPuoxmLBzDBUcVfzww8
	 QwNbJIK/88VBZ7bj63gGpgObQkEzDPpHV/+uE+Et5eWYk48xb9xp2xxkBTFj0VLehv
	 40ntThRWXFv+g==
Date: Mon, 23 Dec 2024 16:28:09 +0000
To: "rafael@kernel.org" <rafael@kernel.org>
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: [PATCH v2] thermal/debugfs: change kzalloc to kcalloc
Message-ID: <LrNqRlU9exQU3mj1YCsmuWHYkpX3ZtUkks2ajMaCbmODAmeO0U0zMIDUVOsIjUyVMaImb67YdBy6M5NFOUqrkdmzgIxILRxZ_pbhOsOvtcI=@ethancedwards.com>
Feedback-ID: 28410670:user:proton
X-Pm-Message-ID: 7953223c63a835d43bd4e9b315c0fdf4d734ad51
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Use 2-factor multiplication argument form kcalloc() instead
of instead of the deprecated kzalloc() [1].

[1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded=
-arithmetic-in-allocator-arguments
Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/thermal/thermal_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_de=
bugfs.c
index c800504c3cfe..29dc1431a252 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -876,7 +876,7 @@ void thermal_debug_tz_add(struct thermal_zone_device *t=
z)

        tz_dbg->tz =3D tz;

-       tz_dbg->trips_crossed =3D kzalloc(sizeof(int) * tz->num_trips, GFP_=
KERNEL);
+       tz_dbg->trips_crossed =3D kcalloc(tz->num_trips, sizeof(int), GFP_K=
ERNEL);
        if (!tz_dbg->trips_crossed) {
                thermal_debugfs_remove_id(thermal_dbg);
                return;
--
2.47.1

