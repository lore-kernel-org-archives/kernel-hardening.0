Return-Path: <SRS0=0sTM=XY=lists.openwall.com=kernel-hardening-return-16965-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63D9C4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 15185217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWRgRXLn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15185217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16965-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26315 invoked by uid 550); 29 Sep 2019 16:31:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26262 invoked from network); 29 Sep 2019 16:31:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KfpYDptzyBtrfiWFl3do6w+1Dpvlsv04OGYHKpjG43M=;
        b=BWRgRXLnXN6FrtoDhK74h2DdFUlJCxgSgKaJMETIkwGB3rigA/pg7tlf/z+jUqaZba
         J2bkHiCz9b8d3Ph7rvRJJ1AiFHgwCKbL62myJm77teLCDMnFx5iRms0QEDXMIa1v/t7c
         XMLiuzF2buuRMYwxNqGDZbP/1i/WWNsO1LmDjVRAkOY/qzoVZty60ZPOT1sKOzVdqCsB
         e6NeitpmJQO5nVeJZNthRHtpHt4xyAoslHc0UwNUuBYDH/7q4N3uIPcaWs+7FysYoX8L
         ygzciwDlT6DCOrgrkbi2Emz7q7+FpkmXNoiBCPNuxrlbEZ2naatSw0KsYFKM8yWqRPA6
         T9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KfpYDptzyBtrfiWFl3do6w+1Dpvlsv04OGYHKpjG43M=;
        b=KiybWV2v6dPszjU+AetSsve3m9npiT6v4EeXnqMV2QoTMeAnEgL/XHYkEbCh+/9uYz
         Yz5OD/mO7ZzL8p/zzAqAg3ztmyrnocDDnwNjmiEYduKbuYspYB3jWWu4X5iBh+bcrwvZ
         3c2dt40eZ8z2G044UeZWIqnumduB5k0TeJI4MABdAtBJmFR2L4K3nFaUJBCxT5NSsgiL
         zoSFYLJ0MzhY2P5cJgGKpwVm16mpH/NDmkOy7ra+aBAh3xG1RHVLcD4dN+3cYjkK0hAp
         dkEvjSIBb51fXVFcE5LPLg9bq1+ANyEg5AFNPceEN+zD5OvyhzizdxaJYTn8Cu83WCLs
         OIdQ==
X-Gm-Message-State: APjAAAXAmA8q3Es+jobx39Mt5jbPvS4QvEHx3bpJ4cX108ZsEVlrZS4I
	gsMX7aniObGeI5v+3wu5gms=
X-Google-Smtp-Source: APXvYqwKavpH2YOlJ6wm1emasVxofGFmqbI4aalyQ3ostP6ulBmUB/WXROAst8VZSUOj9UozJl36nQ==
X-Received: by 2002:a7b:c258:: with SMTP id b24mr13980045wmj.21.1569774670116;
        Sun, 29 Sep 2019 09:31:10 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 15/16] tasklet: convert callbacks prototype for using struct tasklet_struct * arguments
Date: Sun, 29 Sep 2019 18:30:27 +0200
Message-Id: <20190929163028.9665-16-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that everything has been converted, we can use the new prototype of
the callbacks. This converts the cast macros, the handler field and
the tasklet initialization functions to the new prototype.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 include/linux/interrupt.h | 10 +++++-----
 kernel/softirq.c          |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index b5ac24b7fea2..506300396db9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -594,17 +594,17 @@ struct tasklet_struct
 	struct tasklet_struct *next;
 	unsigned long state;
 	atomic_t count;
-	void (*func)(unsigned long);
+	void (*func)(struct tasklet_struct *);
 };
 
-#define TASKLET_DATA_TYPE		unsigned long
+#define TASKLET_DATA_TYPE		struct tasklet_struct *
 #define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
 
 #define DECLARE_TASKLET(name, func) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func }
 
 #define DECLARE_TASKLET_DISABLED(name, func) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func }
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func }
 
 
 enum
@@ -673,7 +673,7 @@ static inline void tasklet_enable(struct tasklet_struct *t)
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
 extern void tasklet_init(struct tasklet_struct *t,
-			 void (*func)(unsigned long));
+			 void (*func)(struct tasklet_struct *));
 
 #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
 	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
diff --git a/kernel/softirq.c b/kernel/softirq.c
index feb9ac8e6f0b..7415a7c4b494 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -520,7 +520,7 @@ static void tasklet_action_common(struct softirq_action *a,
 				if (!test_and_clear_bit(TASKLET_STATE_SCHED,
 							&t->state))
 					BUG();
-				t->func((TASKLET_DATA_TYPE)t);
+				t->func(t);
 				tasklet_unlock(t);
 				continue;
 			}
@@ -547,7 +547,7 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
 }
 
 void tasklet_init(struct tasklet_struct *t,
-		  void (*func)(unsigned long))
+		  void (*func)(struct tasklet_struct *))
 {
 	t->next = NULL;
 	t->state = 0;
-- 
2.23.0

