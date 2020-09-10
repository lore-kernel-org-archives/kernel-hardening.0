Return-Path: <SRS0=gKz6=CT=lists.openwall.com=kernel-hardening-return-19858-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D7DC2D0A7
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB1C520829
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 20:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BclfH4h6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB1C520829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19858-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19637 invoked by uid 550); 10 Sep 2020 20:21:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19614 invoked from network); 10 Sep 2020 20:21:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t7QYn1yhWQ40fqsjl2bkOVXNzJEardYI1LG85/i6U4Y=;
        b=BclfH4h6+3Bniz3hlYX1B8/uwcukDuLERmdv/too1YSZlXK9dBtB6T76hiHYKxbvf9
         ygrdCHBb2d1zvH8fNVjO46IvyeFd1UQ1/ZyJKm4z7MgXVjH3rg/TxqlBaSg381uGWgSp
         a0ksHPHgB/X4oFDK2ba/ovfJCDRHiImWHRs4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t7QYn1yhWQ40fqsjl2bkOVXNzJEardYI1LG85/i6U4Y=;
        b=PqWSgiwq53/3Xwy9+1CSvNXikDDddVLZ8NDYOFu3hzsmHp+A0PY/aDkT/hGvAfsPV8
         bYLlH5p/EVKl3366QG8l64a3IRDwYUSJ118/HM7EK/G15Z/F+7HHAsP+5Y2mlTtwIxcR
         h70VXcpRjYxiInBRpfsAj2dqVup0zbRaR+o9Tww2yyOORdfELWQbUtIM/9Nd82nMzlLY
         6jSXM3IaRop5K/z41U8zgg2zSY9h1nwuvVGgWkc8eIVilPaGU5nDphKWDtnNQD41ECi2
         vQGe25rPRKyc1eek0wxYHJS2tH3EseNMKWnfh1cNqGVhrdl7OF3H9Wp59N5IeyFU2cbr
         rJaQ==
X-Gm-Message-State: AOAM533lzWqINq3HE7KU0k6BPoCS6EqpKSXYcv9+72Ci7VeRLeFrdHWN
	9iHxlwwahqbCeJ4WVm3zTOv4qA==
X-Google-Smtp-Source: ABdhPJx0DRsV2uk7XRhN5WyrdQ3GN+smsELZkM+SGtSpILq3ccN5AWUrZdo9DI6cB7SYJM/QqYly8g==
X-Received: by 2002:a63:4418:: with SMTP id r24mr5838961pga.8.1599769277620;
        Thu, 10 Sep 2020 13:21:17 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	John Wood <john.wood@gmx.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [RFC PATCH 1/6] security/fbfam: Add a Kconfig to enable the fbfam feature
Date: Thu, 10 Sep 2020 13:21:02 -0700
Message-Id: <20200910202107.3799376-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

Add a menu entry under "Security options" to enable the "Fork brute
force attack mitigation" feature.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 security/Kconfig       |  1 +
 security/fbfam/Kconfig | 10 ++++++++++
 2 files changed, 11 insertions(+)
 create mode 100644 security/fbfam/Kconfig

diff --git a/security/Kconfig b/security/Kconfig
index 7561f6f99f1d..00a90e25b8d5 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -290,6 +290,7 @@ config LSM
 	  If unsure, leave this as the default.
 
 source "security/Kconfig.hardening"
+source "security/fbfam/Kconfig"
 
 endmenu
 
diff --git a/security/fbfam/Kconfig b/security/fbfam/Kconfig
new file mode 100644
index 000000000000..bbe7f6aad369
--- /dev/null
+++ b/security/fbfam/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+config FBFAM
+	bool "Fork brute force attack mitigation"
+	default n
+	help
+	  This is a user defense that detects any fork brute force attack
+	  based on the application's crashing rate. When this measure is
+	  triggered the fork system call is blocked.
+
+	  If you are unsure how to answer this question, answer N.
-- 
2.25.1

