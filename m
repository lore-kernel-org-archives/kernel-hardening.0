Return-Path: <SRS0=l59F=6Y=lists.openwall.com=kernel-hardening-return-18742-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52ADC47255
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 02:01:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 30C8E208CA
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 02:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="g5EH7kxB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30C8E208CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18742-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11636 invoked by uid 550); 10 May 2020 02:01:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11601 invoked from network); 10 May 2020 02:01:33 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com 04A20oRe019447
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1589076052;
	bh=rJP2b3m7YpXHpek6yW9rO6PfF4Mu2xGZn7YuDG2S4T0=;
	h=From:To:Cc:Subject:Date:From;
	b=g5EH7kxB/O7eOB7cFGM6OHtuR6mKr2LbtVxcamRKFXPvlW5Zz8hdp3LsrmAQaFumw
	 erbo2ygvlj4XWcG+VEGONVSXRIdGE24Cfx6GOKgDJm8b3sKqKF/s2SfmwLv9tQjtmx
	 EWan93eX5AWlyY6HpsoSk4BKz4iGwqdiZTxgAlKRMU1YsAaBQ7wOlQotHEMV+WwJ8j
	 6KjPihNuw1TF91jKXOW/x0MpSnWhnDa2IUUEYGfZIA9wLLa8G25+eIbD0GSZLk3Tzq
	 qM1fXwQj0ONEBTgzgFauouTCwFgzMrZjbTDJzpHyynayWz5aUYMRup7j7UCn6NLL6Z
	 tjyMOnARibYiA==
X-Nifty-SrcIP: [126.90.202.47]
From: Masahiro Yamada <masahiroy@kernel.org>
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
        kernel-hardening@lists.openwall.com
Cc: Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] gcc-plugins: remove always false $(if ...) in Makefile
Date: Sun, 10 May 2020 11:00:44 +0900
Message-Id: <20200510020044.958018-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the remnant of commit c17d6179ad5a ("gcc-plugins: remove unused
GCC_PLUGIN_SUBDIR").

$(if $(findstring /,$(p)),...) is always false because none of plugins
contains '/' in the file name.

Clean up the code.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 scripts/gcc-plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index 80f354289eeb..4014ba7e2fbd 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -14,7 +14,7 @@ $(objtree)/$(obj)/randomize_layout_seed.h: FORCE
 	$(call if_changed,create_randomize_layout_seed)
 targets = randomize_layout_seed.h randomize_layout_hash.h
 
-hostcxxlibs-y := $(foreach p,$(GCC_PLUGIN),$(if $(findstring /,$(p)),,$(p)))
+hostcxxlibs-y := $(GCC_PLUGIN)
 always-y := $(hostcxxlibs-y)
 
 $(foreach p,$(hostcxxlibs-y:%.so=%),$(eval $(p)-objs := $(p).o))
-- 
2.25.1

