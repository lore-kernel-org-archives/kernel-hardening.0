Return-Path: <SRS0=oXKj=EA=lists.openwall.com=kernel-hardening-return-20266-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BABC55179
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 15:07:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 814A9208A9
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 15:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="YTQEAY/u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814A9208A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20266-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15407 invoked by uid 550); 25 Oct 2020 15:06:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15375 invoked from network); 25 Oct 2020 15:06:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1603638398;
	bh=wuoS53Deov2WuIzLJNZWMN+kyeRs9Ey6AoYGWmib7HU=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTQEAY/uDsAziYS/nBhb9v8t6l7IOw1o3OXzgL8Mx3wvc4uSAoIjKmsvLey2EGiMS
	 zZYtzpWV93+xq5zIdLEBwhPHJREDPDRxHUHrdDTd2WDt/YzjjbI7idQLUg/F8Km2+H
	 O8Ji+OZjDlcLeRurH6xjn6Fkt6SksroGAFJlpYjQ=
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
Subject: [PATCH v2 2/8] security/brute: Define a LSM and manage statistical data
Date: Sun, 25 Oct 2020 14:45:34 +0100
Message-Id: <20201025134540.3770-3-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gj4Pv1tMSqJQblHiMNF3ohGw0eX6O5310SKSKkbOzUwoX1sssju
 nMXHyTGoxwLY6TNnA2crs5k13efBZLs4fzVDOf9Cvg2hO3pcUPahKk07Y6ZR5xbNMoybynv
 aCH++vSQdsUBrVtPjyOmrgUA2cxNIZnXWB7rC1Fgi+zk9tANwKxSFvQVMFnyM/n73Iu3dTe
 KFTMbvG2hDOddl86BgbAQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:h/qcHZd+Stw=:9whRYikgVS7mb6a/XD9wgp
 3MPZ2ed1Pc68v2HMBPgM8Q1eAkHh6Af58JVepeOzZkGvhTMbIzas6AdXjPzmuygbprAEFAWjj
 1KC9B3ELpQus/iuRLN26gBKqxFfWP68SOrFdl93p8jJ0jItgT+KTPohfZT/OuNrRpEyI+Et6Z
 ozmoBlN13PzTIoGqxUOJ/YV+QZrqRMFW1o/QECWO8Ea7pMBGBq7Ci6j2e0tCGiLUm2g5IP1yX
 aZ0l/QxQZe+zi/QEl5sK6E7pm0KZqWqIS3l7opc3U5PXX/eIS8W2xj0LOZLu8fIWoqeAyegdj
 LPPv6LxyWgNci5fEinNOKpAYfDb1yOwY4mkXfKkdoj6yo9PHWb8jJgbYK1aQD8d2/GwWuaFhJ
 qmnYkEklRGGg/V2CozHzJy+wWJxfcZuUMEHIHMW5QG7FoYdyHpZ1wqYdfiFJqrtTuiRlL31ad
 h/d4LMZWxnMIiHdwyTvy2Sdz1cL67Ge7+0FjEfvXySnDPLR6+unqngePIm8PQxnlSRr8f43hy
 BZvqduf3Fcm7g5Baf8ZFwQqxNNMNnUlHErIBc8/pqA307oPVyAcvUh38k3FAyWUam6tJPQiqk
 fnCDVFRFXFR5nISReHaQsZBAGZqShkr15e7ArbEYosXzYU54l9KnBMT40Bn68IgN8Fe7rvNtc
 6pzzKhdxBRBkux6LnPGbHd2rAz79PxuFxdC65IyYR3VW3sLfY2pOpzeB6uTMYmSmR7p5lSnTZ
 3Bwox7dd1lc0LYBfC8RbBpByF/UD5UQpWyi5sEK632n74ehVrJ7CvF5DGcrveEXUqsJxPfgzz
 1DE5Dts3tSH4aSYEcnJ0e2WVv0ihouY+Z8cIK2yJCAE7RSoCuN0F1ai6X2HZyU7rN4RW6g9Jc
 KWxIgmuleZBmnLGOnnJQ==

Add a new Kconfig file to define a menu entry under "Security options"
to enable the "Fork brute force attack detection and mitigation"
feature.

For a correct management of a fork brute force attack it is necessary
that all the tasks hold statistical data. The same statistical data
needs to be shared between all the tasks that hold the same memory
contents or in other words, between all the tasks that have been forked
without any execve call. So, define a statistical data structure to hold
all the necessary information shared by all the fork hierarchy
processes. This info is basically a list of the last crashes timestamps
and a reference counter.

When a forked task calls the execve system call, the memory contents are
set with new values. So, in this scenario the parent's statistical data
no need to be shared. Instead, a new statistical data structure must be
allocated to start a new hierarchy.

The statistical data that is shared between all the fork hierarchy
processes needs to be freed when this hierarchy disappears.

So, based in all the previous information define a LSM with three hooks
to manage all the commented cases. These hooks are "task_alloc" to do
the fork management, "bprm_committing_creds" for do the execve
management and "task_free" to release the resources.

Also, add to the task_struct's security blob the pointer to the
statistical data. This way, all the tasks will have access to this
information.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 security/Kconfig        |  11 +-
 security/Makefile       |   4 +
 security/brute/Kconfig  |  12 ++
 security/brute/Makefile |   2 +
 security/brute/brute.c  | 339 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 363 insertions(+), 5 deletions(-)
 create mode 100644 security/brute/Kconfig
 create mode 100644 security/brute/Makefile
 create mode 100644 security/brute/brute.c

diff --git a/security/Kconfig b/security/Kconfig
index 7561f6f99f1d..204bb311b1f1 100644
=2D-- a/security/Kconfig
+++ b/security/Kconfig
@@ -240,6 +240,7 @@ source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"

 source "security/integrity/Kconfig"
+source "security/brute/Kconfig"

 choice
 	prompt "First legacy 'major LSM' to be initialized"
@@ -277,11 +278,11 @@ endchoice

 config LSM
 	string "Ordered list of enabled LSMs"
-	default "lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,=
apparmor,bpf" if DEFAULT_SECURITY_SMACK
-	default "lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smac=
k,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
-	default "lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAUL=
T_SECURITY_TOMOYO
-	default "lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECUR=
ITY_DAC
-	default "lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,=
apparmor,bpf"
+	default "brute,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,t=
omoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
+	default "brute,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinu=
x,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
+	default "brute,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if =
DEFAULT_SECURITY_TOMOYO
+	default "brute,lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT=
_SECURITY_DAC
+	default "brute,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,t=
omoyo,apparmor,bpf"
 	help
 	  A comma-separated list of LSMs, in initialization order.
 	  Any LSMs left off this list will be ignored. This can be
diff --git a/security/Makefile b/security/Makefile
index 3baf435de541..1236864876da 100644
=2D-- a/security/Makefile
+++ b/security/Makefile
@@ -36,3 +36,7 @@ obj-$(CONFIG_BPF_LSM)			+=3D bpf/
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+=3D integrity
 obj-$(CONFIG_INTEGRITY)			+=3D integrity/
+
+# Object brute file lists
+subdir-$(CONFIG_SECURITY_FORK_BRUTE)	+=3D brute
+obj-$(CONFIG_SECURITY_FORK_BRUTE)	+=3D brute/
diff --git a/security/brute/Kconfig b/security/brute/Kconfig
new file mode 100644
index 000000000000..1bd2df1e2dec
=2D-- /dev/null
+++ b/security/brute/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+config SECURITY_FORK_BRUTE
+	bool "Fork brute force attack detection and mitigation"
+	depends on SECURITY
+	help
+	  This is an LSM that stops any fork brute force attack against
+	  vulnerable userspace processes. The detection method is based on
+	  the application crash period and as a mitigation procedure all the
+	  offending tasks are killed. Like capabilities, this security module
+	  stacks with other LSMs.
+
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/brute/Makefile b/security/brute/Makefile
new file mode 100644
index 000000000000..d3f233a132a9
=2D-- /dev/null
+++ b/security/brute/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_SECURITY_FORK_BRUTE) +=3D brute.o
diff --git a/security/brute/brute.c b/security/brute/brute.c
new file mode 100644
index 000000000000..307d07bf9d98
=2D-- /dev/null
+++ b/security/brute/brute.c
@@ -0,0 +1,339 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <asm/current.h>
+#include <linux/bug.h>
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/lsm_hooks.h>
+#include <linux/printk.h>
+#include <linux/refcount.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+/**
+ * struct brute_stats - Fork brute force attack statistics.
+ * @lock: Lock to protect the brute_stats structure.
+ * @refc: Reference counter.
+ * @timestamps: Last crashes timestamps list.
+ * @timestamps_size: Last crashes timestamps list size.
+ *
+ * This structure holds the statistical data shared by all the fork hiera=
rchy
+ * processes.
+ */
+struct brute_stats {
+	spinlock_t lock;
+	refcount_t refc;
+	struct list_head timestamps;
+	unsigned char timestamps_size;
+};
+
+/**
+ * struct brute_timestamp - Last crashes timestamps list entry.
+ * @jiffies: Crash timestamp.
+ * @node: Entry list head.
+ *
+ * This structure holds a crash timestamp.
+ */
+struct brute_timestamp {
+	u64 jiffies;
+	struct list_head node;
+};
+
+/**
+ * brute_blob_sizes - LSM blob sizes.
+ *
+ * To share statistical data among all the fork hierarchy processes, defi=
ne a
+ * pointer to the brute_stats structure as a part of the task_struct's se=
curity
+ * blob.
+ */
+static struct lsm_blob_sizes brute_blob_sizes __lsm_ro_after_init =3D {
+	.lbs_task =3D sizeof(struct brute_stats *),
+};
+
+/**
+ * brute_stats_ptr() - Get the pointer to the brute_stats structure.
+ * @task: Task that holds the statistical data.
+ *
+ * Return: A pointer to a pointer to the brute_stats structure.
+ */
+static inline struct brute_stats **brute_stats_ptr(struct task_struct *ta=
sk)
+{
+	return task->security + brute_blob_sizes.lbs_task;
+}
+
+/**
+ * brute_new_timestamp() - Allocate a new timestamp structure.
+ *
+ * If the allocation is successful the timestamp is set to now.
+ *
+ * Return: NULL if the allocation fails. A pointer to the new allocated
+ *         timestamp structure if it success.
+ */
+static struct brute_timestamp *brute_new_timestamp(void)
+{
+	struct brute_timestamp *timestamp;
+
+	timestamp =3D kmalloc(sizeof(struct brute_timestamp), GFP_KERNEL);
+	if (timestamp)
+		timestamp->jiffies =3D get_jiffies_64();
+
+	return timestamp;
+}
+
+/**
+ * brute_new_stats() - Allocate a new statistics structure.
+ *
+ * If the allocation is successful the reference counter is set to one to
+ * indicate that there will be one task that points to this structure. Th=
e last
+ * crashes timestamps list is initialized with one entry set to now. This=
 way,
+ * its possible to compute the application crash period at the first faul=
t.
+ *
+ * Return: NULL if the allocation fails. A pointer to the new allocated
+ *         statistics structure if it success.
+ */
+static struct brute_stats *brute_new_stats(void)
+{
+	struct brute_stats *stats;
+	struct brute_timestamp *timestamp;
+
+	stats =3D kmalloc(sizeof(struct brute_stats), GFP_KERNEL);
+	if (!stats)
+		return NULL;
+
+	timestamp =3D brute_new_timestamp();
+	if (!timestamp) {
+		kfree(stats);
+		return NULL;
+	}
+
+	spin_lock_init(&stats->lock);
+	refcount_set(&stats->refc, 1);
+	INIT_LIST_HEAD(&stats->timestamps);
+	list_add_tail(&timestamp->node, &stats->timestamps);
+	stats->timestamps_size =3D 1;
+
+	return stats;
+}
+
+/**
+ * brute_share_stats() - Share the statistical data between processes.
+ * @src: Source of statistics to be shared.
+ * @dst: Destination of statistics to be shared.
+ *
+ * Copy the src's pointer to the statistical data structure to the dst's =
pointer
+ * to the same structure. Since there is a new process that shares the sa=
me
+ * data, increase the reference counter. The src's pointer cannot be NULL=
.
+ *
+ * It's mandatory to disable interrupts before acquiring the lock since t=
he
+ * task_free hook can be called from an IRQ context during the execution =
of the
+ * task_alloc hook.
+ */
+static void brute_share_stats(struct brute_stats **src,
+			      struct brute_stats **dst)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&(*src)->lock, flags);
+	refcount_inc(&(*src)->refc);
+	*dst =3D *src;
+	spin_unlock_irqrestore(&(*src)->lock, flags);
+}
+
+/**
+ * brute_task_alloc() - Target for the task_alloc hook.
+ * @task: Task being allocated.
+ * @clone_flags: Contains the flags indicating what should be shared.
+ *
+ * For a correct management of a fork brute force attack it is necessary =
that
+ * all the tasks hold statistical data. The same statistical data needs t=
o be
+ * shared between all the tasks that hold the same memory contents or in =
other
+ * words, between all the tasks that have been forked without any execve =
call.
+ *
+ * To ensure this, if the current task doesn't have statistical data when=
 forks,
+ * it is mandatory to allocate a new statistics structure and share it be=
tween
+ * this task and the new one being allocated. Otherwise, share the statis=
tics
+ * that the current task already has.
+ *
+ * Return: -ENOMEM if the allocation of the new statistics structure fail=
s. Zero
+ *         otherwise.
+ */
+static int brute_task_alloc(struct task_struct *task, unsigned long clone=
_flags)
+{
+	struct brute_stats **stats, **p_stats;
+
+	stats =3D brute_stats_ptr(task);
+	p_stats =3D brute_stats_ptr(current);
+
+	if (likely(*p_stats)) {
+		brute_share_stats(p_stats, stats);
+		return 0;
+	}
+
+	*stats =3D brute_new_stats();
+	if (!*stats)
+		return -ENOMEM;
+
+	brute_share_stats(stats, p_stats);
+	return 0;
+}
+
+/**
+ * brute_reset_stats() - Reset the statistical data.
+ * @stats: Statistics to be reset.
+ *
+ * Ensure that the last crashes timestamps list holds only one entry and =
set
+ * this timestamp to now. This way, its possible to compute the applicati=
on
+ * crash period at the next fault. The statistics to be reset cannot be N=
ULL.
+ *
+ * Context: Must be called with stats->lock held.
+ */
+static void brute_reset_stats(struct brute_stats *stats)
+{
+	unsigned char entries_to_delete;
+	struct brute_timestamp *timestamp, *next;
+
+	if (WARN(!stats->timestamps_size, "No last timestamps\n"))
+		return;
+
+	entries_to_delete =3D stats->timestamps_size - 1;
+	stats->timestamps_size =3D 1;
+
+	list_for_each_entry_safe(timestamp, next, &stats->timestamps, node) {
+		if (unlikely(!entries_to_delete)) {
+			timestamp->jiffies =3D get_jiffies_64();
+			break;
+		}
+
+		list_del(&timestamp->node);
+		kfree(timestamp);
+		entries_to_delete -=3D 1;
+	}
+}
+
+/**
+ * brute_task_execve() - Target for the bprm_committing_creds hook.
+ * @bprm: Points to the linux_binprm structure.
+ *
+ * When a forked task calls the execve system call, the memory contents a=
re set
+ * with new values. So, in this scenario the parent's statistical data no=
 need
+ * to be shared. Instead, a new statistical data structure must be alloca=
ted to
+ * start a new hierarchy. This condition is detected when the statistics
+ * reference counter holds a value greater than or equal to two (a fork a=
lways
+ * sets the statistics reference counter to a minimum of two since the pa=
rent
+ * and the child task are sharing the same data).
+ *
+ * However, if the execve function is called immediately after another ex=
ecve
+ * call, althought the memory contents are reset, there is no need to all=
ocate
+ * a new statistical data structure. This is possible because at this mom=
ent
+ * only one task (the task that calls the execve function) points to the =
data.
+ * In this case, the previous allocation is used but the statistics are r=
eset.
+ *
+ * It's mandatory to disable interrupts before acquiring the lock since t=
he
+ * task_free hook can be called from an IRQ context during the execution =
of the
+ * bprm_committing_creds hook.
+ */
+static void brute_task_execve(struct linux_binprm *bprm)
+{
+	struct brute_stats **stats;
+	unsigned long flags;
+
+	stats =3D brute_stats_ptr(current);
+	if (WARN(!*stats, "No statistical data\n"))
+		return;
+
+	spin_lock_irqsave(&(*stats)->lock, flags);
+
+	if (!refcount_dec_not_one(&(*stats)->refc)) {
+		/* execve call after an execve call */
+		brute_reset_stats(*stats);
+		spin_unlock_irqrestore(&(*stats)->lock, flags);
+		return;
+	}
+
+	/* execve call after a fork call */
+	spin_unlock_irqrestore(&(*stats)->lock, flags);
+	*stats =3D brute_new_stats();
+	WARN(!*stats, "Cannot allocate statistical data\n");
+}
+
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
+	struct brute_timestamp *timestamp, *next;
+
+	list_for_each_entry_safe(timestamp, next, &stats->timestamps, node) {
+		list_del(&timestamp->node);
+		kfree(timestamp);
+	}
+
+	spin_unlock(&stats->lock);
+	kfree(stats);
+}
+
+/**
+ * brute_task_free() - Target for the task_free hook.
+ * @task: Task about to be freed.
+ *
+ * The statistical data that is shared between all the fork hierarchy pro=
cesses
+ * needs to be freed when this hierarchy disappears.
+ */
+static void brute_task_free(struct task_struct *task)
+{
+	struct brute_stats **stats;
+
+	stats =3D brute_stats_ptr(task);
+	if (WARN(!*stats, "No statistical data\n"))
+		return;
+
+	spin_lock(&(*stats)->lock);
+
+	if (refcount_dec_and_test(&(*stats)->refc))
+		brute_stats_free(*stats);
+	else
+		spin_unlock(&(*stats)->lock);
+}
+
+/**
+ * brute_hooks - Targets for the LSM's hooks.
+ */
+static struct security_hook_list brute_hooks[] __lsm_ro_after_init =3D {
+	LSM_HOOK_INIT(task_alloc, brute_task_alloc),
+	LSM_HOOK_INIT(bprm_committing_creds, brute_task_execve),
+	LSM_HOOK_INIT(task_free, brute_task_free),
+};
+
+/**
+ * brute_init() - Initialize the brute LSM.
+ *
+ * Return: Always returns zero.
+ */
+static int __init brute_init(void)
+{
+	pr_info("Brute initialized\n");
+	security_add_hooks(brute_hooks, ARRAY_SIZE(brute_hooks),
+			   KBUILD_MODNAME);
+	return 0;
+}
+
+DEFINE_LSM(brute) =3D {
+	.name =3D KBUILD_MODNAME,
+	.init =3D brute_init,
+	.blobs =3D &brute_blob_sizes,
+};
+
=2D-
2.25.1

