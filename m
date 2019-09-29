Return-Path: <SRS0=t+Nz=XY=lists.openwall.com=kernel-hardening-return-16966-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE3AC4360C
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F128217F5
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Sep 2019 16:34:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1EKp0PG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F128217F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16966-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26498 invoked by uid 550); 29 Sep 2019 16:31:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26405 invoked from network); 29 Sep 2019 16:31:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dlFlkuQMoyoEHNHFU7Tl8/owe+E5UzmTMCtahBrosDU=;
        b=V1EKp0PGTOMQCufwYf606odeal48FJXl1/nPd7CNBAdP5+Mck0gOV+Us/yrwcRcxdf
         YHIjhJBBIE0l/2Kj8X6I2cHlKtK1JB/Ri9USfOSQT+Z0eLkwFpEwc2qaa78Yae6JYkXy
         Bu6vkTL881se4zwQ+IlsdMGGuEdvL+JJNUVFnpvXy0wQCx+1GjtPzIfrOgxinJUtKTqO
         TowK/5IqTHX2vDS3OBG1gqcEcoHI5eyEt/iLUWrGeXd81pUOb1BDorRgBcOkUD8SJpM1
         L4tuuL/jkWXgbh7r79OPelcPA4Zc5fGpz+d3nZ4kidHUsktcS0H+adUCHCgkzGW1a5aO
         mP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dlFlkuQMoyoEHNHFU7Tl8/owe+E5UzmTMCtahBrosDU=;
        b=pa3I+O7I1D7J8PZey5qvwNykQ8LKyFZNhOtFQNZYy0mi2IPHvIggf0EjlcaBM80VeW
         l/7cUvj66eI8GpaR6XA24fzSfrmun8k7AtsNq2iGqGFruU5XRVGmmX+QcJk3VkVhEUIt
         HaRa4WvFHyVfTCuclwTQavoQy3mgW3ptlDQNE++3qZE7W5RFvRaHkDRebOXkYDYPu/PF
         ptFFI87Q3I2zmnaOWj3s9ZOg7T76HFanZnFUY3hB58eWOltskRwBo3oCj6HqJgBal5g5
         yzH9BPD8KQlHhBoal79tqHmwnt8lk1cMWoABzl+s4gNOWAhkWy8kn9dNBqwQgaGfgAC/
         iNjw==
X-Gm-Message-State: APjAAAVHq3i0JTXtLrtiWnRnbEh0bCIviLZ13k6dWKanYaMFMF7nF4mb
	xkvbT9jHxumVOoMMm8DTllTHcDyt
X-Google-Smtp-Source: APXvYqx5tXKZkh9nD8GaSy4zXSYzhk+FaiJ55KQpGKbjp/sbPD82NBeniS/h4njyUcCDBtG5rY18Yw==
X-Received: by 2002:a05:600c:295b:: with SMTP id n27mr14148475wmd.128.1569774671661;
        Sun, 29 Sep 2019 09:31:11 -0700 (PDT)
From: Romain Perier <romain.perier@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PRE-REVIEW PATCH 16/16] tasklet: Add the new initialization function permanently
Date: Sun, 29 Sep 2019 18:30:28 +0200
Message-Id: <20190929163028.9665-17-romain.perier@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929163028.9665-1-romain.perier@gmail.com>
References: <20190929163028.9665-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that everything has been converted to the new API, we can remove
tasklet_init() and replace it by tasklet_setup().

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 include/linux/interrupt.h | 9 +--------
 kernel/softirq.c          | 4 ++--
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 506300396db9..0e8f6bca45a4 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -672,18 +672,11 @@ static inline void tasklet_enable(struct tasklet_struct *t)
 
 extern void tasklet_kill(struct tasklet_struct *t);
 extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
-extern void tasklet_init(struct tasklet_struct *t,
+extern void tasklet_setup(struct tasklet_struct *t,
 			 void (*func)(struct tasklet_struct *));
 
 #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
 	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
-
-static inline void tasklet_setup(struct tasklet_struct *t,
-				 void (*callback)(struct tasklet_struct *))
-{
-	tasklet_init(t, (TASKLET_FUNC_TYPE)callback);
-}
-
 /*
  * Autoprobing for irqs:
  *
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7415a7c4b494..179dce78fff8 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -546,7 +546,7 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
 	tasklet_action_common(a, this_cpu_ptr(&tasklet_hi_vec), HI_SOFTIRQ);
 }
 
-void tasklet_init(struct tasklet_struct *t,
+void tasklet_setup(struct tasklet_struct *t,
 		  void (*func)(struct tasklet_struct *))
 {
 	t->next = NULL;
@@ -554,7 +554,7 @@ void tasklet_init(struct tasklet_struct *t,
 	atomic_set(&t->count, 0);
 	t->func = func;
 }
-EXPORT_SYMBOL(tasklet_init);
+EXPORT_SYMBOL(tasklet_setup);
 
 void tasklet_kill(struct tasklet_struct *t)
 {
-- 
2.23.0

