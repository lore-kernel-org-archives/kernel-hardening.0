Return-Path: <SRS0=BrdR=VM=lists.openwall.com=kernel-hardening-return-16462-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A10C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:37:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4576D21873
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jul 2019 14:37:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="IozIr9z+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4576D21873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16462-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27829 invoked by uid 550); 15 Jul 2019 14:37:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27720 invoked from network); 15 Jul 2019 14:37:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CJEwPPrtJyDTV3piEkDE+ONyRMH9m2RDRbmoV5ZEGS8=;
        b=IozIr9z+GIb5mPdKiPaf5UHiYIz+Oat0gqj58xKeNgOqIcav4VXtm41dS18QhgHWuP
         08bOfzHsvFlkA1+slmz0mYgCQced6RM3EOenJJaGW8k4oiXykx/eoqvUaynExjS780ga
         gIRPex9R8tFcEqFj6fn/uCxhibShb2XLfLQao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CJEwPPrtJyDTV3piEkDE+ONyRMH9m2RDRbmoV5ZEGS8=;
        b=J8OrAImcU7MCYQLwInG4hWVWu7bpP9usKupZQWl17z85ssWvBU1cMTyD5e/Jz4Nosc
         iy2JWC4VEMX9DiRptNMD2WXvdZGkcC24uvUPZKQ9EWc51/4lkTSz1tz7TW8VAyXzlUgh
         6oEx4uR/f9wOS7ZnwzvK+sdlcn9S7Ih8j7E/PvNajXV5hC3Ldf0cir+eQ6CGDMDvOeID
         5hFNfuTDJQfVA+C0biRbtrzDf+6cFFUywrO5PtMW18XZlAZjCD9lxugMgYq04AF+5d3X
         GyaJIpmECipzl0SxCysWj5Uvk6hE3OUTmPq4/ZkHpN4VMmGMcDV6l/hgR2AdGY1ooM6z
         SiPw==
X-Gm-Message-State: APjAAAUnOAfAaQGV5mk1OmXclESro/AXqBqr9NUgu/vt7nTiBYkorTho
	LZjxXVewopfjZb4m4fU0GVM=
X-Google-Smtp-Source: APXvYqzrTtDshfHRTIApwfR2uw8rmwlBdmV5rfV/lQ/WFFtfVs/RxHxaLHWVf+yG1vS25zf50JO+qA==
X-Received: by 2002:a17:902:290b:: with SMTP id g11mr28300017plb.26.1563201442188;
        Mon, 15 Jul 2019 07:37:22 -0700 (PDT)
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
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	kernel-team@android.com,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	neilb@suse.com,
	netdev@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>,
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
Subject: [PATCH 2/9] rcu: Add support for consolidated-RCU reader checking (v3)
Date: Mon, 15 Jul 2019 10:36:58 -0400
Message-Id: <20190715143705.117908-3-joel@joelfernandes.org>
X-Mailer: git-send-email 2.22.0.510.g264f2c817a-goog
In-Reply-To: <20190715143705.117908-1-joel@joelfernandes.org>
References: <20190715143705.117908-1-joel@joelfernandes.org>
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
 include/linux/rculist.h  | 28 ++++++++++++++++++++-----
 include/linux/rcupdate.h |  7 +++++++
 kernel/rcu/Kconfig.debug | 11 ++++++++++
 kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
 4 files changed, 67 insertions(+), 23 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e91ec9ddcd30..1048160625bb 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
  */
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
+/*
+ * Check during list traversal that we are within an RCU reader
+ */
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
@@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the list_head within the struct.
+ * @cond:	optional lockdep expression if called from non-RCU protection.
  *
  * This list-traversal primitive may safely run concurrently with
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
@@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.
  * @member:	the name of the hlist_node within the struct.
+ * @cond:	optional lockdep expression if called from non-RCU protection.
  *
  * This list-traversal primitive may safely run concurrently with
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
index 8f7167478c1d..f3c29efdf19a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -221,6 +221,7 @@ int debug_lockdep_rcu_enabled(void);
 int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 int rcu_read_lock_sched_held(void);
+int rcu_read_lock_any_held(void);
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -241,6 +242,12 @@ static inline int rcu_read_lock_sched_held(void)
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
index 5ec3ea4028e2..7fbd21dbfcd0 100644
--- a/kernel/rcu/Kconfig.debug
+++ b/kernel/rcu/Kconfig.debug
@@ -8,6 +8,17 @@ menu "RCU Debugging"
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
index 9dd5aeef6e70..b7a4e3b5fa98 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -91,14 +91,18 @@ module_param(rcu_normal_after_boot, int, 0);
  * Similarly, we avoid claiming an SRCU read lock held if the current
  * CPU is offline.
  */
+#define rcu_read_lock_held_common()		\
+	if (!debug_lockdep_rcu_enabled())	\
+		return 1;			\
+	if (!rcu_is_watching())			\
+		return 0;			\
+	if (!rcu_lockdep_current_cpu_online())	\
+		return 0;
+
 int rcu_read_lock_sched_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return lock_is_held(&rcu_sched_lock_map) || !preemptible();
 }
 EXPORT_SYMBOL(rcu_read_lock_sched_held);
@@ -257,12 +261,8 @@ NOKPROBE_SYMBOL(debug_lockdep_rcu_enabled);
  */
 int rcu_read_lock_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return lock_is_held(&rcu_lock_map);
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_held);
@@ -284,16 +284,24 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_held);
  */
 int rcu_read_lock_bh_held(void)
 {
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
+	rcu_read_lock_held_common();
+
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
+int rcu_read_lock_any_held(void)
+{
+	rcu_read_lock_held_common();
+
+	if (lock_is_held(&rcu_lock_map) ||
+	    lock_is_held(&rcu_bh_lock_map) ||
+	    lock_is_held(&rcu_sched_lock_map))
+		return 1;
+	return !preemptible();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
+
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
-- 
2.22.0.510.g264f2c817a-goog

