Return-Path: <SRS0=Wx7B=5K=lists.openwall.com=kernel-hardening-return-18218-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADF4C43331
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 11:50:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF7B520714
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 11:50:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="Fn32tZyU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF7B520714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18218-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10128 invoked by uid 550); 25 Mar 2020 11:50:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17697 invoked from network); 25 Mar 2020 03:15:24 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02P3EoCw025927
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1585106091;
	bh=S5jEMGj/iPjxiPM2qpwETTmm50qFMMgViufRDHA4UYY=;
	h=From:To:Cc:Subject:Date:From;
	b=Fn32tZyU6S/FbmgTUNVYw/4mgJsDn7KA/fxkT/MCad0McZ3zqYtMJSj1sCVuNl+2A
	 NaXYDYrLmdttewD0irHM2OQFQ5x3LwX9JHjnrDrEifjNgcGJmXmJC06KwqYD4N73Pk
	 EUt3WS4kao/rxOcQKWldzMdttDHJWApWk+mIbFcP8v2g+VmvsKk9pOWd3d8NRUAwO/
	 M3I3R8DR6SAeiyj/Wg3QZ47DJGNdVm16I1eR5nkz0Npa79NVQCGz7C10cMkQ4nfWFd
	 9kIx/6WnzyqL6LvmcOtW+HfbETF2duFoijog6PE+opUO84lGozT7Nuxa+dNAoy+q2A
	 oxyeCKZaYP2uA==
X-Nifty-SrcIP: [153.142.97.92]
From: Masahiro Yamada <masahiroy@kernel.org>
To: linux-kbuild@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
        Masahiro Yamada <masahiroy@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] kconfig: remove unused variable in qconf.cc
Date: Wed, 25 Mar 2020 12:14:31 +0900
Message-Id: <20200325031433.28223-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If this file were compiled with -Wall, the following warning would be
reported:

scripts/kconfig/qconf.cc:312:6: warning: unused variable ‘i’ [-Wunused-variable]
  int i;
      ^

The commit prepares to turn on -Wall for C++ host programs.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 scripts/kconfig/qconf.cc | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 82773cc35d35..50a5245d87bb 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -309,8 +309,6 @@ ConfigList::ConfigList(ConfigView* p, const char *name)
 	  showName(false), showRange(false), showData(false), mode(singleMode), optMode(normalOpt),
 	  rootEntry(0), headerPopup(0)
 {
-	int i;
-
 	setObjectName(name);
 	setSortingEnabled(false);
 	setRootIsDecorated(true);
-- 
2.17.1

