Return-Path: <SRS0=8Hw3=VI=lists.openwall.com=kernel-hardening-return-16409-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4F9C742A5
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:44:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 358EF216B7
	for <kernel-hardening@archiver.kernel.org>; Thu, 11 Jul 2019 23:44:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="IGKpfpLd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 358EF216B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16409-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9912 invoked by uid 550); 11 Jul 2019 23:44:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9797 invoked from network); 11 Jul 2019 23:44:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FITTKsy0ccvIyixSPRiCdGiovalZSrd3OHcUD21QK98=;
        b=IGKpfpLdCh9L199i85cDoWBN2sVOwSD+UtAb3c4qrcAw43wxgeMdcgA9g+jve3LID5
         6vOOpxemLXJj1CZ79tB3Pje6chjO0HvYbVetcbgPQoCchXFtYur1Efy9Q7vdAWUF4ngJ
         VBDST6I2Pm3/IeSKN7V5T8vNCOjcm1ESkYOGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FITTKsy0ccvIyixSPRiCdGiovalZSrd3OHcUD21QK98=;
        b=FxCX5FDhKvfPa9ZKCYNvVPOKeqmH4u3Tez05I+OWxxlaf8G7SanuKl0FMIDuVVgYA7
         3+XMdg6YxRD+IZpx1sYo3ZRWu2bnyGGOQpSomORIgZrELmbpROW4NdUi3VuaoPs9DAYL
         ETtilZWkps2RCZbEoZ0jNWt+dLh3frrtfMb57KrxfRtogCWJUJNKW2wWNoAXpk/VF8Ey
         UEa3I7xktmvGZgJJ1aAKNEyCma3g8Xc+OlEaTA3EDixsAVynfLl2Nc/LsHU0xkJ+aGQi
         GxvztK5o7S3G/Bw48MIm91oiGubt209qvlmrIwrO2F7yo61ApyPKqS5QXKPnbygi6rWj
         Obyg==
X-Gm-Message-State: APjAAAVWcMcQnWzdasdz89bI3FENLHFpaWeHulMYZs7LT6cj/olLxx1k
	dMIb+h4ewOvRNl2TgWFeJF8=
X-Google-Smtp-Source: APXvYqwozgq75nMKR73qox3f/PRoDIY5soJTLm7wRfHEcQK+usIOeqo0yORbOwCrmC8k4mWWATDhPg==
X-Received: by 2002:a17:902:e281:: with SMTP id cf1mr7321567plb.271.1562888658619;
        Thu, 11 Jul 2019 16:44:18 -0700 (PDT)
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com,
	"David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	oleg@redhat.com,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	will@kernel.org,
	x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Subject: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader checking
Date: Thu, 11 Jul 2019 19:43:56 -0400
Message-Id: <20190711234401.220336-2-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190711234401.220336-1-joel@joelfernandes.org>
References: <20190711234401.220336-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds support for checking RCU reader sections in list
traversal macros. Optionally, if the list macro is called under SRCU or
other lock/mutex protection, then appropriate lockdep expressions can be
passed to make the checks pass.

Existing list_for_each_entry_rcu() invocations don't need to pass the
optional fourth argument (cond) unless they are under some non-RCU
protection and needs to make lockdep check pass.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rculist.h  | 29 ++++++++++++++++++++++++-----
 include/linux/rcupdate.h |  7 +++++++
 kernel/rcu/Kconfig.debug | 11 +++++++++++
 kernel/rcu/update.c      | 26 ++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 5 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..78c15ec6b2c9 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -40,6 +40,23 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
  */
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
+/*
+ * Check during list traversal that we are within an RCU reader
+ */
+
+#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
+#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)
+
+#ifdef CONFIG_PROVE_RCU_LIST
+#define __list_check_rcu(dummy, cond, ...)				\
+	({								\
+	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
+			 "RCU-list traversed in non-reader section!");	\
+	 })
+#else
+#define __list_check_rcu(dummy, cond, ...) ({})
+#endif
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -348,9 +365,10 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * the _rcu list-mutation primitives such as list_add_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
-		&pos->member != (head); \
+#define list_for_each_entry_rcu(pos, head, member, cond...)		\
+	for (__list_check_rcu(dummy, ## cond, 0),			\
+	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
 /**
@@ -621,8 +639,9 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * the _rcu list-mutation primitives such as hlist_add_head_rcu()
  * as long as the traversal is guarded by rcu_read_lock().
  */
-#define hlist_for_each_entry_rcu(pos, head, member)			\
-	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
+#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
+	for (__list_check_rcu(dummy, ## cond, 0),			\
+	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 922bb6848813..712b464ab960 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -223,6 +223,7 @@ int debug_lockdep_rcu_enabled(void);
 int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 int rcu_read_lock_sched_held(void);
+int rcu_read_lock_any_held(void);
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -243,6 +244,12 @@ static inline int rcu_read_lock_sched_held(void)
 {
 	return !preemptible();
 }
+
+static inline int rcu_read_lock_any_held(void)
+{
+	return !preemptible();
+}
+
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 #ifdef CONFIG_PROVE_RCU
diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
index 0ec7d1d33a14..b20d0e2903d1 100644
--- a/kernel/rcu/Kconfig.debug
+++ b/kernel/rcu/Kconfig.debug
@@ -7,6 +7,17 @@ menu "RCU Debugging"
 config PROVE_RCU
 	def_bool PROVE_LOCKING
 
+config PROVE_RCU_LIST
+	bool "RCU list lockdep debugging"
+	depends on PROVE_RCU
+	default n
+	help
+	  Enable RCU lockdep checking for list usages. By default it is
+	  turned off since there are several list RCU users that still
+	  need to be converted to pass a lockdep expression. To prevent
+	  false-positive splats, we keep it default disabled but once all
+	  users are converted, we can remove this config option.
+
 config TORTURE_TEST
 	tristate
 	default n
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c3bf44ba42e5..9cb30006a5e1 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -298,6 +298,32 @@ int rcu_read_lock_bh_held(void)
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
+int rcu_read_lock_any_held(void)
+{
+	int lockdep_opinion = 0;
+
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	if (!rcu_is_watching())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
+
+	/* Preemptible RCU flavor */
+	if (lock_is_held(&rcu_lock_map))
+		return 1;
+
+	/* BH flavor */
+	if (in_softirq() || irqs_disabled())
+		return 1;
+
+	/* Sched flavor */
+	if (debug_locks)
+		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
+	return lockdep_opinion || !preemptible();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
+
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
-- 
2.22.0.410.gd8fdbe21b5-goog

