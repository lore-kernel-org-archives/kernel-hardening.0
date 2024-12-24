Return-Path: <kernel-hardening-return-21913-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id F2298E7718B
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Dec 2024 03:27:32 +0000 (UTC)
Received: (qmail 8094 invoked by uid 550); 25 Dec 2024 03:27:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1474 invoked from network); 24 Dec 2024 22:13:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=protonmail3; t=1735078405; x=1735337605;
	bh=s8tMHzHmmJ+SEcYAfDqFaGKe7WAZQZkom1vhjssxqCQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=g28Ue7yOjQ6O1kcuB8CWz0KBgP2K6zpLG0B477sgyMzxUOqKIPxfPYqtu9begsRmg
	 4ePlIlZ5EcqlxNl3swuVONFkjxzbhUZoRL6+2tFh+JqZLJTkg6bYzBEIE8b5qjHFts
	 MhkqI4iCUmUYBAaZf1ljmRMLyAF5DUS0x+FGbm+eYoX+y5SvSofpwxXzLD+2Sqv9Qr
	 8ADd3NUbxgwi3ZpvyUE9I6Y7viRQ9w+mFzD7GVkJdQBYLTdzzjdp4KZ5rcdaX/lV3/
	 EEcVcR81nCkPhu+ukXTZUFmDRv4Y5DW8/ESj6ARmNVvwTVe6ErwnHGfj9ZErsq/R5V
	 ODtgGAMW/u0lw==
Date: Tue, 24 Dec 2024 22:13:21 +0000
To: "agk@redhat.com" <agk@redhat.com>
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: "snitzer@kernel.org" <snitzer@kernel.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, "mpatocka@redhat.com" <mpatocka@redhat.com>
Subject: [PATCH] dm: change kzalloc to kcalloc
Message-ID: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Feedback-ID: 28410670:user:proton
X-Pm-Message-ID: 1bd655178d25c363227416789bb2d5305d0fba03
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
 drivers/md/dm-ps-io-affinity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.=
c
index 461ee6b2044d..716807e511ee 100644
--- a/drivers/md/dm-ps-io-affinity.c
+++ b/drivers/md/dm-ps-io-affinity.c
@@ -116,7 +116,7 @@ static int ioa_create(struct path_selector *ps, unsigne=
d int argc, char **argv)
 =09if (!s)
 =09=09return -ENOMEM;
=20
-=09s->path_map =3D kzalloc(nr_cpu_ids * sizeof(struct path_info *),
+=09s->path_map =3D kcalloc(nr_cpu_ids, sizeof(struct path_info *),
 =09=09=09     GFP_KERNEL);
 =09if (!s->path_map)
 =09=09goto free_selector;
--=20
2.47.1
