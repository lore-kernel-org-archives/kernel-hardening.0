Return-Path: <SRS0=yHRp=5J=lists.openwall.com=kernel-hardening-return-18161-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD68C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 625D320774
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuO6IgZn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 625D320774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18161-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25776 invoked by uid 550); 24 Mar 2020 15:37:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25653 invoked from network); 24 Mar 2020 15:37:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064221;
	bh=88VE/OFCJ68wUOdcxhSay8r/8S/aaN+bgGPAlwd52xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuO6IgZnkaarA94D7wpwykQ4xoQZNyPAp3GcmAWUlOD959KpOUcsbLUXezUDq1gQu
	 1XHhKPHtJGTanA/aVzrgdyzwqYNOKDYyG5cXOEGOM3ofhkp37APz6Jwu7Cn4IkyuMp
	 oaxy+sYGeiaeecR0vMVrEJtsNaDEtOQKUt7snBJU=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 04/21] timers: Use hlist_unhashed() instead of open-coding in timer_pending()
Date: Tue, 24 Mar 2020 15:36:26 +0000
Message-Id: <20200324153643.15527-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

timer_pending() open-codes a version of hlist_unhashed() to check
whether or not the 'timer' parameter has been queued in the timer wheel.
KCSAN detects this as a racy operation and explodes at us:

  | BUG: KCSAN: data-race in del_timer / detach_if_pending
  |
  | write to 0xffff88808697d870 of 8 bytes by task 10 on cpu 0:
  |  __hlist_del include/linux/list.h:764 [inline]
  |  detach_timer kernel/time/timer.c:815 [inline]
  |  detach_if_pending+0xcd/0x2d0 kernel/time/timer.c:832
  |  try_to_del_timer_sync+0x60/0xb0 kernel/time/timer.c:1226
  |  del_timer_sync+0x6b/0xa0 kernel/time/timer.c:1365
  |  schedule_timeout+0x2d2/0x6e0 kernel/time/timer.c:1896
  |  rcu_gp_fqs_loop+0x37c/0x580 kernel/rcu/tree.c:1639
  |  rcu_gp_kthread+0x143/0x230 kernel/rcu/tree.c:1799
  |  kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
  |  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352
  |
  | read to 0xffff88808697d870 of 8 bytes by task 12060 on cpu 1:
  |  del_timer+0x3b/0xb0 kernel/time/timer.c:1198
  |  sk_stop_timer+0x25/0x60 net/core/sock.c:2845
  |  inet_csk_clear_xmit_timers+0x69/0xa0 net/ipv4/inet_connection_sock.c:523
  |  tcp_clear_xmit_timers include/net/tcp.h:606 [inline]
  |  tcp_v4_destroy_sock+0xa3/0x3f0 net/ipv4/tcp_ipv4.c:2096
  |  inet_csk_destroy_sock+0xf4/0x250 net/ipv4/inet_connection_sock.c:836
  |  tcp_close+0x6f3/0x970 net/ipv4/tcp.c:2497
  |  inet_release+0x86/0x100 net/ipv4/af_inet.c:427
  |  __sock_release+0x85/0x160 net/socket.c:590
  |  sock_close+0x24/0x30 net/socket.c:1268
  |  __fput+0x1e1/0x520 fs/file_table.c:280
  |  ____fput+0x1f/0x30 fs/file_table.c:313
  |  task_work_run+0xf6/0x130 kernel/task_work.c:113
  |  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  |  exit_to_usermode_loop+0x2b4/0x2c0 arch/x86/entry/common.c:163

Replace the explicit 'pprev' pointer comparison in timer_pending() with
a call to hlist_unhashed() and initialise the 'expires' timer field
explicitly in do_init_timer() so that the compiler doesn't emit bogus
'maybe used uninitialised' warnings now that it cannot reason statically
about the result of timer_pending().

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 include/linux/timer.h | 5 +++--
 kernel/time/timer.c   | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 1e6650ed066d..e9610d2988ba 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -158,13 +158,14 @@ static inline void destroy_timer_on_stack(struct timer_list *timer) { }
  *
  * timer_pending will tell whether a given timer is currently pending,
  * or not. Callers must ensure serialization wrt. other operations done
- * to this timer, eg. interrupt contexts, or other CPUs on SMP.
+ * to this timer, eg. interrupt contexts, or other CPUs on SMP if they
+ * cannot tolerate spurious results.
  *
  * return value: 1 if the timer is pending, 0 if not.
  */
 static inline int timer_pending(const struct timer_list * timer)
 {
-	return timer->entry.pprev != NULL;
+	return !hlist_unhashed(&timer->entry);
 }
 
 extern void add_timer_on(struct timer_list *timer, int cpu);
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 4820823515e9..9e1c6fc8433a 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -780,6 +780,7 @@ static void do_init_timer(struct timer_list *timer,
 			  const char *name, struct lock_class_key *key)
 {
 	timer->entry.pprev = NULL;
+	timer->expires = 0; /* Avoid bogus 'maybe used uninitialized' warning */
 	timer->function = func;
 	timer->flags = flags | raw_smp_processor_id();
 	lockdep_init_map(&timer->lockdep_map, name, key, 0);
-- 
2.20.1

