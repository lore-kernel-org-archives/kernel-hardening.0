Return-Path: <kernel-hardening-return-21910-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1CB15E7718B
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Dec 2024 16:27:06 +0000 (UTC)
Received: (qmail 11499 invoked by uid 550); 23 Dec 2024 16:26:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16343 invoked from network); 23 Dec 2024 16:21:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=protonmail3; t=1734970863; x=1735230063;
	bh=akUmr6bOc+fOEizuHMtWgqa48aPdr3+dMVwuE/0mScA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=oFCLbqr9g9+kYm/ypdy6ge5KsZFsBMbilXsEOYPmrnEQrrMf0GF2+H4praGOc5Adq
	 +HGnjKtYFT5Z/kEt00aRVBhBYbkmoNPoecL8XnwSSwBC/QiNH0mnvxKohIRFx2HT3m
	 Dto1akoMjsXdHdbrSivAd0NtCDqSTLwLqdeh80h0msQvOwx7eHvj/ZvhE5TFf8eM4J
	 ql7FckkUEdbKv+MVsb9Nrz7wFVgamO1gQM0v+SOZJZjBhPp4GKotMmfuqG1tpsoa6v
	 NnFxEypOeGneUly5vgdoGAiS/+nXIZ587tqmugORQCkoaVepCjqYDcDoiGcf3SRd57
	 BQFPdqc5EfmOg==
Date: Mon, 23 Dec 2024 16:20:59 +0000
To: "rafael@kernel.org" <rafael@kernel.org>
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: [PATCH] thermal/debugfs: change kzalloc to kcalloc
Message-ID: <LD_0bVRqzr2SEjrmrDHAWn0PurFdkgxZD6QS2zowUh5uqA7or1pd88vdA5wyXbTx1Z6dfZzt7pq6xfQ1EnvD4fIt26nWG5-zGEmNLhIcXTE=@ethancedwards.com>
Feedback-ID: 28410670:user:proton
X-Pm-Message-ID: ef2dd8441b364721ef05f54745cd160004b2625f
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
+       tz_dbg->trips_crossed =3D kcalloc(z->num_trips, sizeof(int), GFP_KE=
RNEL);
        if (!tz_dbg->trips_crossed) {
                thermal_debugfs_remove_id(thermal_dbg);
                return;
--
2.47.1

