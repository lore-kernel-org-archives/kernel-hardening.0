Return-Path: <SRS0=8czZ=VD=lists.openwall.com=kernel-hardening-return-16362-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,GAPPY_SUBJECT,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665DCC0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:57:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B5C0621670
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 10:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U523Em2K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5C0621670
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16362-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26000 invoked by uid 550); 6 Jul 2019 10:55:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25850 invoked from network); 6 Jul 2019 10:55:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7bgA3KVSNsVJyluNyhiPajryn8BOsiL4nv8POO6e3hg=;
        b=U523Em2KEtwXXxdV/BGn5jTzA7rwZNHEXsm1OcyY68qXcXEIgtM7G0Cet6d7ccvPCH
         xbNCt3TDC5HduqU/DgmJHVWSZe3KHZA5S97dUyH+Nq+WuUGuXAX0ragXjruWpmzsAxwt
         ZI947WMH7fH0XqCrCOg3eUA/2YAFkYNqtSug+CIUNQQHYURAjMXd6h9N5ALvdD0NpxEB
         AK2lAV8bchfSrDSx25gT6m0BWN8JZu//SbcHOnuqBRH2eqm3G2johuskfOsaaGz6nZlh
         deThmGjYCWPUDpw151T+5llw2TOJGBzuERv8CkChSGkkIYR0JLd+dQLERH79C+pRIoUr
         14dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7bgA3KVSNsVJyluNyhiPajryn8BOsiL4nv8POO6e3hg=;
        b=eKc0taZ/lqu/sVoQSV40FeTsldHTFQV6RSfIjiRqWEPj+3OCkoIwzyoFLreJ3DTyOe
         t35gGbGLZ5XebE2FvkHSDaO6tX2Ms91WMHYb0RsvqrpIDwHvegJCgp6og6JcrMNJf2GY
         s65H/5ZBdKfERhNEhqvYLhngWRVD3R0ODG079qgeAbNDWe7gzjhHfPjMWzvmvz+vK4Hi
         crq0DiptWvI+FddxvAQUo5M29nNAI9f+U9TQrP0Dwbln0VYvGva3zqfdESJXto8kdsbD
         TczHUwaAu6GJLaYRag3xtrOgGL+LO4+apWCsvDJsusEOwR5hgWE8+eVplkE0HYIzy09p
         asBg==
X-Gm-Message-State: APjAAAX9hxe40SKEaWAOEUqZFYCiaafLvm0WC/z34Xr6luHYTB/8/BBv
	kdEgPPgnOR11R0df+/SwLCM=
X-Google-Smtp-Source: APXvYqzPbEUIxunmBrxyk9NAIxCXus8RCS7gBuXZApUJVMJ6c1dTQqt5X0xbeRxaG4n4nmyktigDXg==
X-Received: by 2002:adf:e843:: with SMTP id d3mr9048922wrn.249.1562410525376;
        Sat, 06 Jul 2019 03:55:25 -0700 (PDT)
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Brad Spengler <spender@grsecurity.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christoph Hellwig <hch@infradead.org>,
	James Morris <james.l.morris@oracle.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	PaX Team <pageexec@freemail.hu>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v5 12/12] MAINTAINERS: take maintainership for S.A.R.A.
Date: Sat,  6 Jul 2019 12:54:53 +0200
Message-Id: <1562410493-8661-13-git-send-email-s.mesoraca16@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>
References: <1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com>

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f16e5d0..de6dab1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13925,6 +13925,15 @@ F:	drivers/phy/samsung/phy-s5pv210-usb2.c
 F:	drivers/phy/samsung/phy-samsung-usb2.c
 F:	drivers/phy/samsung/phy-samsung-usb2.h
 
+SARA SECURITY MODULE
+M:	Salvatore Mesoraca <s.mesoraca16@gmail.com>
+T:	git git://github.com/smeso/sara.git lsm/sara/master
+W:	https://sara.smeso.it
+S:	Maintained
+F:	security/sara/
+F:	arch/x86/security/sara/
+F:	Documentation/admin-guide/LSM/SARA.rst
+
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwanem@gmail.com>
 S:	Maintained
-- 
1.9.1

