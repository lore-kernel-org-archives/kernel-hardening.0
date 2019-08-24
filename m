Return-Path: <SRS0=Yl36=WU=lists.openwall.com=kernel-hardening-return-16801-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9034C3A59E
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Aug 2019 15:24:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9EC121874
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Aug 2019 15:24:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="IDD9briY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9EC121874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.co.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16801-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32585 invoked by uid 550); 24 Aug 2019 15:24:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29981 invoked from network); 24 Aug 2019 15:21:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1566660054;
	bh=21g5UFCvn3oFn35pF2pL6tSHWuVW0ZKs5+RW/c9+xrU=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=IDD9briYoUXWz43GxLSq7b2Y7rMq1FhCgTYmbEkcILfahCcXAEz7RE9R1vXHpMxrD
	 QcWLEM7AeWNC7D4BmxrL+hRyCK/TmjMEVbMG5kDj2kFFe9oMbqho7tUn9aOMqv72Iu
	 s/s9gTIge0xY73Er0e0Av26blnELYgfDbR9Ok49I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Alex Dewar <alex.dewar@gmx.co.uk>
To: keescook@chromium.org,
	re.emese@gmail.com
Cc: kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org,
	Alex Dewar <alex.dewar@gmx.co.uk>
Subject: [PATCH] scripts/gcc-plugins: Add SPDX header for files without
Date: Sat, 24 Aug 2019 16:20:41 +0100
Message-Id: <20190824152041.19127-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qSDt+v/H/vNfoO3FeyMOZYs0LmytlhdxJriO184bpEsJVfUCN+m
 XdwMgzD1VqRNi4ar8o58tJ55OKgw2MV5mZwA43hd8cXj+NgvAJ07+zZp4FiWroIsZ68w4Uf
 hbLgwviQk6T3e5cSUQ08mrC4zM5O7cUSlw7TF7PqnUsrRtcOdr0b20RQmql9ELDxARJZ1F4
 iobVEyWnnc3mmPi3S4UlA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yYkRyIhfMoE=:24wEuPsLl3mgTzS5w306WM
 pkmmYgq7vtxz4WVrN4a6ptbEQwa/ZCdUUvXyLenbimTidYLZIFndW783viDcxJuWmZCO9eZu/
 SVyZM/wsfC45CjAjd05D5juRA+PeTB7ZS9NdaqONnkXyPJEY0wXRRI76LM2xwqlhBRHaNeGyD
 3KC0rF2SSm87KTTUQ/1hKlO4EMm4mnPNa8NMPRTgm/2e0EZxS+iDQeFRMdRHRZFqpIfMG45xO
 mDc0BdvrVb+9qGdkmjvcZK6wTCRrgUsyrp5l/LjLATjau1z9ZLkrHPw3+ohS60Ih3urXuhjyM
 eylm+d7IA0LvaKXTn0DUsMcnK5fPL0CVpmEIq8oqic8WUg+QO3kTeg4ZX1jTmiRBOmlteYN3h
 F/MQa/dN44cl7duxNYpsAAkD5UVfkEhQNwmXmsExBcyFnjfsGG3e0XhgKGsnTfGNSUIGSnkUh
 c4x3PMHYQpu0gUabbcoGIxOGdGYTomTsPXrucHpI2nyqUXZ7EZfojX1gblDU9zopCJSxTiSXI
 sl4KUhD6CWl3CDInwZ5D7zoBp5Mxgzh/huhV3azjh8dp9BfrtdurtXhwVHS8GWDJSLXuYugYx
 jAcGtJA8GjD91VOQfPGyohGvGo7jp1to7aHUpi3bfM9Te7zZr+KcslwWEW8xR4Dhi7p9cxlX7
 yLik0TaDk0MsWf8mYjhSgZ8N7hnEoCvmGy/SE1JBE6Fc48sCkEHmoc8NmAFJCgsBNsiwzPCWI
 A8794mHCjE6J1YYvxsjbMxzWLRWlMX/6eoysiyiE1QaqDf6KQOCDyn4Kp+1zUZKjTrWJV6911
 7cJzEydGfvmWGogH0GgVkdW0DbMmEcqay4n4bcDxDmXzQw8Qg1uQfj0weAkJPtbKTYIAeywqF
 IN5kvn1uR6gNOkI392p/3rZq5E+HwG7dOnuBy0FKnoWZbf0kE1vqjccSSFlLK6Q0imUd3aS6D
 oyXtsHoGjAmac1zg6LPU/1SvCRuM6ScxMYjTXBhNm3GRajOjm2406AOd9ooniJac+2ojU66eO
 abLB9cCSj0r+TjHleY2QEL6BdB+QgejntjWs22ZqCFV8ba85HF1xc3Z/gKnEEjOurP8b7SSkC
 Xolm7//WUIuctjzYo20J+TAds2pry80shk8pOzDu671dhh9wycrC1LWlw==

Replace boilerplate with approproate SPDX header. Vim also auto-trimmed
whitespace from one line.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 scripts/gcc-plugins/cyc_complexity_plugin.c   | 2 +-
 scripts/gcc-plugins/latent_entropy_plugin.c   | 2 +-
 scripts/gcc-plugins/randomize_layout_plugin.c | 4 ++--
 scripts/gcc-plugins/sancov_plugin.c           | 2 +-
 scripts/gcc-plugins/stackleak_plugin.c        | 2 +-
 scripts/gcc-plugins/structleak_plugin.c       | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/scripts/gcc-plugins/cyc_complexity_plugin.c b/scripts/gcc-plu=
gins/cyc_complexity_plugin.c
index 1909ec617431..870266f36b5c 100644
=2D-- a/scripts/gcc-plugins/cyc_complexity_plugin.c
+++ b/scripts/gcc-plugins/cyc_complexity_plugin.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2, or (at your option) v3
  *
  * Homepage:
  * https://github.com/ephox-gcc-plugins/cyclomatic_complexity
diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plu=
gins/latent_entropy_plugin.c
index cbe1d6c4b1a5..c693ac27ddf1 100644
=2D-- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
  * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL =
v3,
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-p=
lugins/randomize_layout_plugin.c
index bd29e4e7a524..f46d049da26c 100644
=2D-- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2014-2016 by Open Source Security, Inc., Brad Spengler <spen=
der@grsecurity.net>
  *                   and PaX Team <pageexec@freemail.hu>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL =
v3,
@@ -909,7 +909,7 @@ static unsigned int find_bad_casts_execute(void)
 			} else {
 				const_tree ssa_name_var =3D SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
-				if (ssa_name_var !=3D NULL_TREE && DECL_NAME(ssa_name_var) &&
+				if (ssa_name_var !=3D NULL_TREE && DECL_NAME(ssa_name_var) &&
 				    !strcmp((const char *)DECL_NAME_POINTER(ssa_name_var), "__mptr"))
 					continue;
 #ifndef __DEBUG_PLUGIN
diff --git a/scripts/gcc-plugins/sancov_plugin.c b/scripts/gcc-plugins/san=
cov_plugin.c
index 0f98634c20a0..9845ad67a7d8 100644
=2D-- a/scripts/gcc-plugins/sancov_plugin.c
+++ b/scripts/gcc-plugins/sancov_plugin.c
@@ -1,6 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
- * Licensed under the GPL v2, or (at your option) v3
  *
  * Homepage:
  * https://github.com/ephox-gcc-plugins/sancov
diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/=
stackleak_plugin.c
index dbd37460c573..3abaea274651 100644
=2D-- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -1,7 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2011-2017 by the PaX Team <pageexec@freemail.hu>
  * Modified by Alexander Popov <alex.popov@linux.com>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  * NOT 'eligible' as defined by gcc's library exception to the GPL v3,
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins=
/structleak_plugin.c
index e89be8f5c859..eb8d6b5c83b5 100644
=2D-- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -1,6 +1,6 @@
+// Licensed under the GPL v2
 /*
  * Copyright 2013-2017 by PaX Team <pageexec@freemail.hu>
- * Licensed under the GPL v2
  *
  * Note: the choice of the license means that the compilation process is
  *       NOT 'eligible' as defined by gcc's library exception to the GPL =
v3,
=2D-
2.23.0

