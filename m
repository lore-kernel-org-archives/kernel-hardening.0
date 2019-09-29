Return-Path: <SRS0=KRTG=XY=lists.openwall.com=kernel-hardening-return-16951-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14F0C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 179B4217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:31:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iNn8RoDx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 179B4217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16951-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21505 invoked by uid 550); 29 Sep 2019 16:30:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20426 invoked from network); 29 Sep 2019 16:30:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3dk/GoObAs1quc5+PrEEiAAG96eDZfzvCQ5Ga5o9QY=;
        b=iNn8RoDxKb2i7rzbsi6L615cqkvQ9Z42IWluudV48yV4i+fS/wM3TjK4NMvmz8x1oj
         o1mpdb/1E0EbdsbBRdPyCGUuSOUuWMRmgdySHOeQoaMub46IxdFjD0e2xpZiGyS2jCJq
         RX3CvVLgv8Qdl6aW1anjFM/mojK1H7zMG1+wcMMNIhlRUojNm3xaMUHriPJ9waKiDjOd
         WLXB6+1wRonKcrw5MqrwgKcCVsbHl56O/M8ap2LvW0XwzTz414Hr2YbNuqX+42NhAxO4
         Rfh3ksDJQOe8RCGvJWsfz0awPPo+dHcTJ/jGVammnVeXZrhH2hsXm1yYiIHEMC0OOMAz
         zvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3dk/GoObAs1quc5+PrEEiAAG96eDZfzvCQ5Ga5o9QY=;
        b=d97Z6Zw7+IbVKyi2nRjo+StJhEqOSjWiygSurLfMHKrY1SDV/DLh57Tlp3OjBnexRx
         yrf/FgEzBCksrb8Smiy8elXwRh20N/L0eGd/kyVnHcTgDopxCXQUW/J3VFtdOBZN5lig
         JUxd4ZhaKnvtLCqNJMetYDGSeHSNaoQP0+8qIpozWmb1rDcpcd+BkeJIGuis97PLknJQ
         QwtE2awePz31FkpwaEXjDF4WINlmdsLljAtVZlk/l89Zxr7DSmgiKnRDN64A7RD+Ft2d
         xnZN6i+cmBQNIfA741IhmZV7MdCgDoyxPI78Fo5IE0w0YC2n/sGpFUZYFSC57Ljuq7bF
         ZFyw==
X-Gm-Message-State: APjAAAUVBlTtmJLCsJOr+BeOiUED2OITNOeuBLrGlZCUKwK64ju0MGOd
	ihwI3nelCQuDCD794mniRUY=
X-Google-Smtp-Source: APXvYqwaMs1jxPpC71jld+SrUFwxv7zXVJAeC4XjM8mxQSu5LW4inm8XWDF1fPLpjsfqBQ+bnBpslg==
X-Received: by 2002:adf:e812:: with SMTP id o18mr9994516wrm.398.1569774640586;
        Sun, 29 Sep 2019 09:30:40 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 01/16] tasklet: Prepare to change tasklet callback argument type
Date: Sun, 29 Sep 2019 18:30:13 +0200
Message-Id: <20190929163028.9665-2-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Nowadays, modern kernel subsystems that use callbacks pass the data
structure associated with a given callback as argument to the callback.
The tasklet subsystem remains the one to pass callback argument as an
arbitrary unsigned long argument. This has several problems:

- This keeps an extra field for storing the argument in each tasklet
data structure, it bloats the tasklet_struct structure with a redundant
.data field

- No type checking cannot be performed on this argument. Instead of
using container_of() like other callback subsystems, it forces callbacks
to do explicit type cast of the unsigned long argument into the required
object type.

- Buffer overflows can overwrite the .function and the .data field, so
an attacker can easily overwrite the function and its first argument
to whatever it wants.

This adds a new tasklet initialization API which will gradually replace
the existing one.

This work is greatly inspired from the timer_struct conversion series,
see commit e99e88a9d ("treewide: setup_timer() -> timer_setup()")

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 include/linux/interrupt.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 89fc59dab57d..f5332ae2dbeb 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -673,6 +673,18 @@ extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
 			 void (*func)(unsigned long), unsigned long data);
 
+#define TASKLET_DATA_TYPE		unsigned long
+#define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
+
+#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
+	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
+
+static inline void tasklet_setup(struct tasklet_struct *t,
+				 void (*callback)(struct tasklet_struct *))
+{
+	tasklet_init(t, (TASKLET_FUNC_TYPE)callback, (TASKLET_DATA_TYPE)t);
+}
+
 /*
  * Autoprobing for irqs:
  *
-- 
2.23.0

