Return-Path: <SRS0=SZIc=EA=lists.openwall.com=kernel-hardening-return-20269-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB16C55179
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 17:07:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A689E208A9
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 17:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="NPKRYkx+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A689E208A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20269-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22007 invoked by uid 550); 25 Oct 2020 17:07:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21972 invoked from network); 25 Oct 2020 17:07:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1603645607;
	bh=qJWyMrjXpeE+rjYpUtbfZPi2nfj0bI6PEUYZ+A9TfME=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPKRYkx+eOfNAIhW+xIuStO2QsD5wrLZ6ymsj/ZQ2esY+11mnjL7KCoHWp9p8RjW0
	 o35wV9q8kHxPGoWUz3XJYyVL+yUUst/CvuCdSopsp9Ht2kEvdOvGyzABNDK5NEmSKV
	 hQtNR3KZ3P1RK64oeyh1sqRkNyFthyjXwf2Z/eg0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>
Cc: John Wood <john.wood@gmx.com>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2 5/8] security/brute: Mitigate a fork brute force attack
Date: Sun, 25 Oct 2020 14:45:37 +0100
Message-Id: <20201025134540.3770-6-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:77xi6IvKdGSSBMMKfua9wA0Oa9DZLborxMu1NdaOiO2Lj+qhobI
 e38gbQKHc3gzjETsO/vAVViY33uuYot1GogAhq+40KanLotMoD8GGMw4JBxbMp2O8Y2mKYO
 d7BOq5wvtqJOWvevUTmA6D/NNTQhrPrYRqhRrITCDA4zhhJ62rUvMLc0nnU4gWnaDe+mg9A
 QlYZBFz4U2KzsP6JvLKGg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:T2PcRj1NkPg=:nHqPkat2rraJOPUjD5nn47
 ip6v6TVOH0UHQFsLGj/QxRW/1FEgBtIWu46PUzycDhjzsEf/hAqZEVhXdj0NRqYDHk+A+/K6Y
 byJP6l93IOzGX0X3iJXZyc39BUHrU+P8t29c715bdTLMUPj1aoMOOQ6BLaBuyD1Ncnr99UVbR
 hqKcHmMpUhBjnrRbYUpBqgufMPgqSphdHaJNEuo0zO0KJut1U3S8obTnnBcu2z6gXPfghBfh8
 THxCN/rdVxDccxxJIg/Pwmw450W3MlQQzDjAUHBlpH1YNjRmearOtpxVHbnBbHTdiPD6/94Ps
 xi0JYeFbmh4NQNIiGJOw0FtUSaU7V3qVR2qMWjh6TzWtX7xl5r9d92tcrtRj0MpNhThfWAwyX
 Jaafed1Ir6/E2GPpDIRPSRKydit+Cr5IqyaVm53FdvnTRiTmHDqgEweYvR6+E1NKmFlhht55T
 n3LqXUaZLSOSHHfzQvSwzgsp39tk0kBtBGGXsWjB9tFLtE4oI2xfbU+EbtwunU61ZqoHdraB9
 j8opcY7Eb5nDskXBCE+8VBKHMEBJ2pibx0DhZ+K73YL6loYMClMIwjju54ZdVZw+b6blf1kp/
 QlFyX+GkX50+hgnuRPBiJR3WuMn/ZEyArSsw4HBW2VqSrBBZvoQTha0xzgYfoSpUaKfr/CSCV
 RhqsyGXMNr2thrimFjFn2FXS5xQKT9IOwhWKmlfGBI69kDqDOVLO4NZlKx0PUS1EmF/mzXEmw
 /s1R3d8u6qT67cu2Nz7aeg3uX7bUOEGGAaEMmrv93yC3B9Sd4T1EZ2+7ddMC5bd35JNcnH20f
 rxO6/U4Qy3wVSfmp8AyqXPnTGXKmyidn8JDLaKh9/jQjEsJVGigFgeihmuYAOZWLudErigRsv
 iCNREpE+jL4hXCdQn+sA==

In order to mitigate a fork brute force attack it is necessary to kill
all the offending tasks. This tasks are all the ones that share the
statistical data with the current task (the task that has crashed).

Since the attack detection is done in the task_fatal_signal LSM hook
only is needed to kill the other tasks that share the same statistical
data, not the ones that have the same group_leader that the current task
since the latter are in the path to be killed.

When the SIGKILL signal is sent to the offending tasks, the
brute_kill_offending_tasks function will be called in a recursive way
from the task_fatal_signal LSM hook due to a small crash period. So, to
avoid kill again the same tasks due to a recursive call of this
function, it is necessary to disable the attack detection for this fork
hierarchy.

To disable this attack detection, empty the last crashes timestamps list
and avoid to compute the application crash period if the size of this
list is zero.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 security/brute/brute.c | 144 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 135 insertions(+), 9 deletions(-)

diff --git a/security/brute/brute.c b/security/brute/brute.c
index 223a18c2084a..a1bdf25ffcf9 100644
=2D-- a/security/brute/brute.c
+++ b/security/brute/brute.c
@@ -3,6 +3,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

 #include <asm/current.h>
+#include <asm/rwonce.h>
 #include <linux/bug.h>
 #include <linux/cache.h>
 #include <linux/compiler.h>
@@ -14,9 +15,14 @@
 #include <linux/limits.h>
 #include <linux/list.h>
 #include <linux/lsm_hooks.h>
+#include <linux/pid.h>
 #include <linux/printk.h>
 #include <linux/refcount.h>
+#include <linux/rwlock.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/signal.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/sysctl.h>
@@ -295,23 +301,39 @@ static void brute_task_execve(struct linux_binprm *b=
prm)
 }

 /**
- * brute_stats_free() - Deallocate a statistics structure.
- * @stats: Statistics to be freed.
+ * brute_timestamps_free() - Empty a last crashes timestamp list.
+ * @timestamps: Last crashes timestamps list to be emptied.
  *
- * Deallocate all the last crashes timestamps list entries and then the
- * statistics structure. The statistics to be freed cannot be NULL.
+ * Empty the last crashes timestamps list and deallocate all the entries.=
 This
+ * list cannot be NULL.
  *
- * Context: Must be called with stats->lock held and this function releas=
es it.
+ * Context: Must be called with stats->lock held.
  */
-static void brute_stats_free(struct brute_stats *stats)
+static void brute_timestamps_free(struct list_head *timestamps)
 {
 	struct brute_timestamp *timestamp, *next;

-	list_for_each_entry_safe(timestamp, next, &stats->timestamps, node) {
+	if (list_empty(timestamps))
+		return;
+
+	list_for_each_entry_safe(timestamp, next, timestamps, node) {
 		list_del(&timestamp->node);
 		kfree(timestamp);
 	}
+}

+/**
+ * brute_stats_free() - Deallocate a statistics structure.
+ * @stats: Statistics to be freed.
+ *
+ * Deallocate all the last crashes timestamps list entries and then the
+ * statistics structure. The statistics to be freed cannot be NULL.
+ *
+ * Context: Must be called with stats->lock held and this function releas=
es it.
+ */
+static void brute_stats_free(struct brute_stats *stats)
+{
+	brute_timestamps_free(&stats->timestamps);
 	spin_unlock(&stats->lock);
 	kfree(stats);
 }
@@ -426,6 +448,104 @@ static u64 brute_get_crash_period(struct brute_times=
tamp *new_entry,
 	return jiffies64_to_msecs(jiffies);
 }

+/**
+ * brute_disabled() - Test the fork brute force attack detection disablin=
g.
+ * @stats: Statistical data shared by all the fork hierarchy processes.
+ *
+ * The fork brute force attack detection enabling / disabling is based on=
 the
+ * last crashes timestamps list current size. A size of zero indicates th=
at this
+ * feature is disabled. A size greater than zero indicates that this atta=
ck
+ * detection is enabled.
+ *
+ * The statistical data shared by all the fork hierarchy processes cannot=
 be
+ * NULL.
+ *
+ * It's mandatory to disable interrupts before acquiring the lock since t=
he
+ * task_free hook can be called from an IRQ context during the execution =
of the
+ * task_fatal_signal hook.
+ *
+ * Return: True if the fork brute force attack detection is disabled. Fal=
se
+ *         otherwise.
+ */
+static bool brute_disabled(struct brute_stats *stats)
+{
+	unsigned long flags;
+	bool disabled;
+
+	spin_lock_irqsave(&stats->lock, flags);
+	disabled =3D !stats->timestamps_size;
+	spin_unlock_irqrestore(&stats->lock, flags);
+
+	return disabled;
+}
+
+/**
+ * brute_disable() - Disable the fork brute force attack detection.
+ * @stats: Statistical data shared by all the fork hierarchy processes.
+ *
+ * To disable the fork brute force attack detection it's only necessary t=
o empty
+ * the last crashes timestamps list. So, a list size of zero indicates th=
at this
+ * feature is disabled and a list size greater than zero indicates that t=
his
+ * attack detection is enabled.
+ *
+ * The statistical data shared by all the fork hierarchy processes cannot=
 be
+ * NULL.
+ *
+ * Context: Must be called with stats->lock held.
+ */
+static void brute_disable(struct brute_stats *stats)
+{
+	brute_timestamps_free(&stats->timestamps);
+	stats->timestamps_size =3D 0;
+}
+
+/**
+ * brute_kill_offending_tasks() - Kill the offending tasks.
+ * @stats: Statistical data shared by all the fork hierarchy processes.
+ *
+ * When a fork brute force attack is detected it is necessary to kill all=
 the
+ * offending tasks involved in the attack. In other words, it is necessar=
y to
+ * kill all the tasks that share the same statistical data but not the on=
es that
+ * have the same group_leader that the current task since the latter are =
in the
+ * path to be killed.
+ *
+ * When the SIGKILL signal is sent to the offending tasks, this function =
will be
+ * called again from the task_fatal_signal hook due to a small crash peri=
od. So,
+ * to avoid kill again the same tasks due to a recursive call of this fun=
ction,
+ * it is necessary to disable the attack detection for this fork hierarch=
y.
+ *
+ * The statistical data shared by all the fork hierarchy processes cannot=
 be
+ * NULL.
+ *
+ * Context: Must be called with stats->lock held.
+ */
+static void brute_kill_offending_tasks(struct brute_stats *stats)
+{
+	struct task_struct *p;
+	struct brute_stats **p_stats;
+
+	if (refcount_read(&stats->refc) =3D=3D 1)
+		return;
+
+	brute_disable(stats);
+	read_lock(&tasklist_lock);
+
+	for_each_process(p) {
+		if (p->group_leader =3D=3D current->group_leader)
+			continue;
+
+		p_stats =3D brute_stats_ptr(p);
+		if (READ_ONCE(*p_stats) !=3D stats)
+			continue;
+
+		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_PID);
+		pr_warn_ratelimited("Offending process %d (%s) killed\n",
+				    p->pid, p->comm);
+	}
+
+	read_unlock(&tasklist_lock);
+}
+
 /**
  * brute_task_fatal_signal() - Target for the task_fatal_signal hook.
  * @siginfo: Contains the signal information.
@@ -433,7 +553,8 @@ static u64 brute_get_crash_period(struct brute_timesta=
mp *new_entry,
  * To detect a fork brute force attack is necessary that the list that ho=
lds the
  * last crashes timestamps be updated in every fatal crash. Then, an only=
 when
  * this list is large enough, the application crash period can be compute=
d an
- * compared with the defined threshold.
+ * compared with the defined threshold. If at this moment an attack is de=
tected,
+ * all the offending tasks must be killed.
  *
  * It's mandatory to disable interrupts before acquiring the lock since t=
he
  * task_free hook can be called from an IRQ context during the execution =
of the
@@ -450,6 +571,9 @@ static void brute_task_fatal_signal(const kernel_sigin=
fo_t *siginfo)
 	if (WARN(!*stats, "No statistical data\n"))
 		return;

+	if (brute_disabled(*stats))
+		return;
+
 	new_entry =3D brute_new_timestamp();
 	if (WARN(!new_entry, "Cannot allocate last crash timestamp\n"))
 		return;
@@ -461,8 +585,10 @@ static void brute_task_fatal_signal(const kernel_sigi=
nfo_t *siginfo)
 		crash_period =3D brute_get_crash_period(new_entry, old_entry);
 		kfree(old_entry);

-		if (crash_period < (u64)brute_crash_period_threshold)
+		if (crash_period < (u64)brute_crash_period_threshold) {
 			pr_warn("Fork brute force attack detected\n");
+			brute_kill_offending_tasks(*stats);
+		}
 	}

 	spin_unlock_irqrestore(&(*stats)->lock, flags);
=2D-
2.25.1

