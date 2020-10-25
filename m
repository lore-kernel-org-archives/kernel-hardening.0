Return-Path: <SRS0=yggP=EA=lists.openwall.com=kernel-hardening-return-20268-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA756C388F7
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 16:27:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B6C8A20874
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 16:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Nf18DFPn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6C8A20874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20268-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19595 invoked by uid 550); 25 Oct 2020 16:27:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19557 invoked from network); 25 Oct 2020 16:27:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1603643204;
	bh=pNENR6NYpvtez0wq6byw3Bmq32UAhJHvRjyV0Y2UrCw=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nf18DFPn1FJtAhUjcCn9Myacw3Ib7PWLI1PH/jkfN9J+q9kWo+6ADefF0fhpZ2pKV
	 rFDx7pNMtfAEuyNjRZVL4jBc/ADnzd2xVxPefyn4SPF8qEpy+KYrWfgW3O3+AgR098
	 bKABUvh1zpHrNUdcXfjqSJ+zItP41th/vo7sODc4=
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
Subject: [PATCH v2 4/8] security/brute: Detect a fork brute force attack
Date: Sun, 25 Oct 2020 14:45:36 +0100
Message-Id: <20201025134540.3770-5-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jpDULrgTFkzvRL5MdNbDprGG+7NOjPXmtdh02SKJ/gibuend0zu
 4FpzOT6e517C6yk6mpkDK5zei6S+mowxi3z8/XZLVMRF+SCI9NLVVW308BINp9aOwL11bnm
 GGjKkNzTDqhcTjSA6oZTLTsTRCHa2Tzfa08wIZatg80wkAAMYfXLKS+dKySQcJDQ4GEV6EZ
 qE8Gtl25sCH5YHq3cx5OQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:wZBrcUl8kvA=:NnjH4p8YLrCWYMo+aDWE0E
 a13no4H61b/h3tkI6THq0QraQmfKXpzJxOLL8cZGl58ociWuQ/jrAKbJ68gyLiMWVabs9RLC7
 OKPJgTyr5NMHtTGf39WBqn2i5SDoti5fhXq7FW7syccRZNOMIQB8PT7dVBTyp2knaAY/aJrjS
 2nLFZgy46qwzkewLjoMp9PFnc7vsB7LBDgMEObNtYvS4+d7sS0mTkR6j+UPOcexwkxu7whk1T
 rO4/NZIeRVoEyrPsLiBhSj5BiQe6VxkGT/jYIXVALluh9ncqcSxT7AZiZ7mcOHthuK9SDYJuJ
 rH/LknJBZS2vBSI3DueTKCv31vMphq3DN87teMlbC+z1+KKW6s9NXU92aAT9nO3u946aOpEBx
 JqXItebzpQ3enyVaLLjo8K9dDvsSED/5sXA6ItNi0sNSX8CPWgKo5Ue4sbF8msaslx0zqcaJr
 sDZNsQesD73hi26icj/kT+a7ggWX41NKvwIiIyHjfCa73qygqsJyKHgOGMqkGeIH/HmdL3Efc
 9FicgxJQyRCrNAW9FFb34VlcZTpQ63ulxHLggD3oG2/y8OCYUinU5jKDpYYySIpTZhO+A5d2t
 AksmbPeyr8LSbMAD+nzqc2H7DfnkU4dGhu+N/FHIiFvqzx72uU0UczeX7dKA1aOo195cmz23m
 KUfodjC7RYpdz6wOd7ivozh3zoaZkiCu78Hc/yyBnbSU94z3KedTBSDscZtGtBiMAqPNaGE5t
 2dToidE3hJe+rE50vFsvRI6VGSaL02wYu+7wffC3g8H9YTFK6FxpgieO+3mNnyIb0iGZzgU3R
 ed7ZK+M8ptVn6miIunqVtGU+1V4vTYUwmZNjKEi0Q+d7KVb5gMqghoqZy1m11LrFYr1GwwClR
 EEGFjubBkxpO1jqUHhIw==

To detect a fork brute force attack is necessary that the list that
holds the last crashes timestamps be updated in every fatal crash. To do
so, use the "task_fatal_signal" LSM hook added in a previous step.

Then, an only when this list is large enough, the application crash
period can be computed as the difference between the newest crash
timestamp and the oldest one divided by the size of the list. This way,
the scenario where an application crashes few times in a short period of
time due to reasons unrelated to a real attack is avoided.

Finally, an application crash period that falls under the defined
threshold shows that the application is crashing quickly and there is a
clear signal that an attack is happening.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 security/brute/brute.c | 130 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/security/brute/brute.c b/security/brute/brute.c
index 29835fe2f141..223a18c2084a 100644
=2D-- a/security/brute/brute.c
+++ b/security/brute/brute.c
@@ -339,6 +339,135 @@ static void brute_task_free(struct task_struct *task=
)
 		spin_unlock(&(*stats)->lock);
 }

+/**
+ * brute_add_timestamp() - Add a new entry to the last crashes timestamps=
 list.
+ * @stats: Statistics that hold the last crashes timestamps list.
+ * @new_entry: New timestamp to add to the list.
+ *
+ * The statistics that hold the last crashes timestamps list cannot be NU=
LL. The
+ * new timestamp to add to the list cannot be NULL.
+ *
+ * Context: Must be called with stats->lock held.
+ */
+static void brute_add_timestamp(struct brute_stats *stats,
+				struct brute_timestamp *new_entry)
+{
+	list_add_tail(&new_entry->node, &stats->timestamps);
+	stats->timestamps_size +=3D 1;
+}
+
+/**
+ * brute_old_timestamp_entry() - Get the oldest timestamp entry.
+ * @head: Last crashes timestamps list.
+ *
+ * Context: Must be called with stats->lock held.
+ * Return: The oldest entry added to the last crashes timestamps list.
+ */
+#define brute_old_timestamp_entry(head) \
+	list_first_entry(head, struct brute_timestamp, node)
+
+/**
+ * brute_update_timestamps_list() - Update the last crashes timestamps li=
st.
+ * @stats: Statistics that hold the last crashes timestamps list.
+ * @new_entry: New timestamp to update the list.
+ *
+ * Add a new timestamp structure to the list if this one has not reached =
the
+ * maximum size yet. Replace the oldest timestamp entry otherwise.
+ *
+ * The statistics that hold the last crashes timestamps list cannot be NU=
LL. The
+ * new timestamp to update the list cannot be NULL.
+ *
+ * Context: Must be called with stats->lock held.
+ * Return: The oldest timestamp that has been replaced. NULL otherwise.
+ */
+static struct brute_timestamp *
+brute_update_timestamps_list(struct brute_stats *stats,
+			     struct brute_timestamp *new_entry)
+{
+	unsigned int list_size;
+	struct brute_timestamp *old_entry;
+
+	list_size =3D (unsigned int)stats->timestamps_size;
+	if (list_size < brute_timestamps_list_size) {
+		brute_add_timestamp(stats, new_entry);
+		return NULL;
+	}
+
+	old_entry =3D brute_old_timestamp_entry(&stats->timestamps);
+	list_replace(&old_entry->node, &new_entry->node);
+	list_rotate_left(&stats->timestamps);
+
+	return old_entry;
+}
+
+/**
+ * brute_get_crash_period() - Get the application crash period.
+ * @new_entry: New timestamp added to the last crashes timestamps list.
+ * @old_entry: Old timestamp replaced in the last crashes timestamps list=
.
+ *
+ * The application crash period is computed as the difference between the=
 newest
+ * crash timestamp and the oldest one divided by the size of the list. Th=
is way,
+ * the scenario where an application crashes few times in a short period =
of time
+ * due to reasons unrelated to a real attack is avoided.
+ *
+ * The new and old timestamp cannot be NULL.
+ *
+ * Context: Must be called with stats->lock held.
+ * Return: The application crash period in milliseconds.
+ */
+static u64 brute_get_crash_period(struct brute_timestamp *new_entry,
+				  struct brute_timestamp *old_entry)
+{
+	u64 jiffies;
+
+	jiffies =3D new_entry->jiffies - old_entry->jiffies;
+	jiffies /=3D (u64)brute_timestamps_list_size;
+
+	return jiffies64_to_msecs(jiffies);
+}
+
+/**
+ * brute_task_fatal_signal() - Target for the task_fatal_signal hook.
+ * @siginfo: Contains the signal information.
+ *
+ * To detect a fork brute force attack is necessary that the list that ho=
lds the
+ * last crashes timestamps be updated in every fatal crash. Then, an only=
 when
+ * this list is large enough, the application crash period can be compute=
d an
+ * compared with the defined threshold.
+ *
+ * It's mandatory to disable interrupts before acquiring the lock since t=
he
+ * task_free hook can be called from an IRQ context during the execution =
of the
+ * task_fatal_signal hook.
+ */
+static void brute_task_fatal_signal(const kernel_siginfo_t *siginfo)
+{
+	struct brute_stats **stats;
+	struct brute_timestamp *new_entry, *old_entry;
+	unsigned long flags;
+	u64 crash_period;
+
+	stats =3D brute_stats_ptr(current);
+	if (WARN(!*stats, "No statistical data\n"))
+		return;
+
+	new_entry =3D brute_new_timestamp();
+	if (WARN(!new_entry, "Cannot allocate last crash timestamp\n"))
+		return;
+
+	spin_lock_irqsave(&(*stats)->lock, flags);
+	old_entry =3D brute_update_timestamps_list(*stats, new_entry);
+
+	if (old_entry) {
+		crash_period =3D brute_get_crash_period(new_entry, old_entry);
+		kfree(old_entry);
+
+		if (crash_period < (u64)brute_crash_period_threshold)
+			pr_warn("Fork brute force attack detected\n");
+	}
+
+	spin_unlock_irqrestore(&(*stats)->lock, flags);
+}
+
 /**
  * brute_hooks - Targets for the LSM's hooks.
  */
@@ -346,6 +475,7 @@ static struct security_hook_list brute_hooks[] __lsm_r=
o_after_init =3D {
 	LSM_HOOK_INIT(task_alloc, brute_task_alloc),
 	LSM_HOOK_INIT(bprm_committing_creds, brute_task_execve),
 	LSM_HOOK_INIT(task_free, brute_task_free),
+	LSM_HOOK_INIT(task_fatal_signal, brute_task_fatal_signal),
 };

 #ifdef CONFIG_SYSCTL
=2D-
2.25.1

