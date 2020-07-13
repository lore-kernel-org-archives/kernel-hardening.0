Return-Path: <SRS0=WL5f=AY=lists.openwall.com=kernel-hardening-return-19295-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5A3C433E2
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 13:53:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1789A206F4
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Jul 2020 13:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1789A206F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=al2klimov.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19295-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32319 invoked by uid 550); 13 Jul 2020 13:52:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31866 invoked from network); 13 Jul 2020 13:50:38 -0000
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
To: keescook@chromium.org,
	re.emese@gmail.com,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] gcc-plugins: Replace HTTP links with HTTPS ones
Date: Mon, 13 Jul 2020 15:50:18 +0200
Message-Id: <20200713135018.34708-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp.al2klimov.de;
	auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not just HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.

 Sorry again to all maintainers who complained about subject lines.
 Now I realized that you want an actually perfect prefixes,
 not just subsystem ones.
 I tried my best...
 And yes, *I could* (at least half-)automate it.
 Impossible is nothing! :)


 scripts/gcc-plugins/cyc_complexity_plugin.c | 2 +-
 scripts/gcc-plugins/sancov_plugin.c         | 2 +-
 scripts/gcc-plugins/structleak_plugin.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/gcc-plugins/cyc_complexity_plugin.c b/scripts/gcc-plugins/cyc_complexity_plugin.c
index 1909ec617431..73124c2b3edd 100644
--- a/scripts/gcc-plugins/cyc_complexity_plugin.c
+++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
@@ -5,7 +5,7 @@
  * Homepage:
  * https://github.com/ephox-gcc-plugins/cyclomatic_complexity
  *
- * http://en.wikipedia.org/wiki/Cyclomatic_complexity
+ * https://en.wikipedia.org/wiki/Cyclomatic_complexity
  * The complexity M is then defined as:
  * M = E - N + 2P
  * where
diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/sancov_plugin.c
index 0f98634c20a0..caff4a6c7e9a 100644
--- a/scripts/gcc-plugins/sancov_plugin.c
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -11,7 +11,7 @@
  *
  * You can read about it more here:
  *  https://gcc.gnu.org/viewcvs/gcc?limit_changes=0&view=revision&revision=231296
- *  http://lwn.net/Articles/674854/
+ *  https://lwn.net/Articles/674854/
  *  https://github.com/google/syzkaller
  *  https://lwn.net/Articles/677764/
  *
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index e89be8f5c859..b9ef2e162107 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -11,7 +11,7 @@
  * otherwise leak kernel stack to userland if they aren't properly initialized
  * by later code
  *
- * Homepage: http://pax.grsecurity.net/
+ * Homepage: https://pax.grsecurity.net/
  *
  * Options:
  * -fplugin-arg-structleak_plugin-disable
-- 
2.27.0

