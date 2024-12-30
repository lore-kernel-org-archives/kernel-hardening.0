Return-Path: <kernel-hardening-return-21915-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8E352E77188
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Dec 2024 05:29:24 +0000 (UTC)
Received: (qmail 13894 invoked by uid 550); 30 Dec 2024 05:29:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13862 invoked from network); 30 Dec 2024 05:29:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=protonmail3; t=1735536542; x=1735795742;
	bh=z1tbn6LI4vl+YBo18LDIWQRtOtRiBFMCb910mSXG7cw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=Zz+OiCX2Xx5bWEmeK5nnR0zJicm4mDJY2qP8WXWcGEm4CJRfBzyhIk5nUpHMlrAiy
	 qACymolqPfeQ0oRmKFgNO83NaaKuLDi6eMm49luMd7Ox4WN3V97Rk7yuVqUHRQpWmu
	 qFb0V3RTJsYHfyKb2yN4J6APE/odc9bHOO5O9r1JVwIvQH7m2Dp0p3e6e/gSL49dQZ
	 qqgXjR0AB0Fg8UrxUnEBN+eYQ5gAtRPnI6ahDrEhIP7lJ22DASd65oZK7F7nCy00aV
	 sPYOx3QD+SphcicQgA1RTvrwznPwidKQWxc1ech84w/SmBarlzbETAxM8Ug5JDu8yQ
	 w2yS26kefmBZQ==
Date: Mon, 30 Dec 2024 05:28:58 +0000
To: kristo@kernel.org
From: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: mturquette@baylibre.com, sboyd@kernel.org, linux-omap@vger.kernel.org, linux-clk@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: [PATCH] clk: ti: use kcalloc() instead of kzalloc()
Message-ID: <xfjn4wqrhukvi45dkgkbulamq3242eijn7567vxwaxznh4ebdr@waat7u3l2mhi>
Feedback-ID: 28410670:user:proton
X-Pm-Message-ID: b630a1367cff86984b54c694637490e109da7999
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Use 2-factor multiplication argument form kcalloc() instead
of kzalloc().

Link: https://github.com/KSPP/linux/issues/162

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 drivers/clk/ti/mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index 216d85d6aac6..f684fc306ecc 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -180,7 +180,7 @@ static void of_mux_clk_setup(struct device_node *node)
 =09=09pr_err("mux-clock %pOFn must have parents\n", node);
 =09=09return;
 =09}
-=09parent_names =3D kzalloc((sizeof(char *) * num_parents), GFP_KERNEL);
+=09parent_names =3D kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
 =09if (!parent_names)
 =09=09goto cleanup;
=20
--=20
2.47.1

