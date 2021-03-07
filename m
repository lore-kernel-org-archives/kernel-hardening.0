Return-Path: <SRS0=Uwlp=IF=lists.openwall.com=kernel-hardening-return-20876-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BC0C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 11:53:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E34DF6501D
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Mar 2021 11:53:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E34DF6501D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20876-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28046 invoked by uid 550); 7 Mar 2021 11:53:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28013 invoked from network); 7 Mar 2021 11:53:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1615117999;
	bh=0mOFH/whRcxwCCNf1FaCVfPgq3zuoVr5XMs4msmzXEk=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fP/89F57Uvd6wz+HXrnrALfcyL2tIGkyzmhTNPThCqx+itY8xekbKfuA28nl94+TQ
	 E5HlyuaL6bc6hTgQWg3oBN0itIesNWk+9gUA+8Bl8N5foEjA7HbrrX+LCBZQ1eMIV1
	 /x1QkIefOuiI/1UK1JssrmXh+Pn6WpbsAbswIJqI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 1/8] security: Add LSM hook at the point where a task gets a fatal signal
Date: Sun,  7 Mar 2021 12:30:24 +0100
Message-Id: <20210307113031.11671-2-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307113031.11671-1-john.wood@gmx.com>
References: <20210307113031.11671-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gjW1lxsS4O/k5Sf+wMA+VJHoZ1qM11KXQETBYwid34I0oYBNmr2
 C/OqkV5z9INlzUtp7FYtQoLqydzU9bhhstzt50l8ENfqMYH+YOzd2coK6Ju4El8FUXOa3jk
 xoXo4At48nMaIfEd8BXPlo1qQgeF1V41qKMoF/n8RLOOh1DVoHmG7gmpe0GuFxNDdSnwhOf
 IPMxaFSEsnB5la6LeBgQg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ekdqLgRPggU=:Ry3SJ1lEftaEQFRP1dW004
 uegRYmgq1qD2F4CQCDaE7r+J9EhwabNP4PICLFAgl6soYo+l8mXoPmdC9ekLhwasJtBdrvAGY
 b+e/6RctVObiuiI4ZFxtV1ZdKulXUTfx7HYTSyz3JCom9/bUK8KADSdusoYMeQcEyHCu8na33
 Ztv+Ii532DUvsRg+m/90I/m9WjYZyB5oBqQn67wPVvlcG2Na4j6uy9kw55JIu5b+21o2BCMkl
 jnG2shzC9TKnKrLlLkNeYe2om9jDscUubUB8K5p4PIcGRKoN4n2z1eSJTzDIcJHyrKv2V71oQ
 b03jo20VqZf1P7BQ/p4af0PK8YtH/Hilxit2mALEEzuqvXZSeGpnv9FANijUJdvtwisKc+zqk
 13ni2mxgVi6k20SjoEkm5xC64NAcjjfpty9bTjPGLErpO59llY6SD2MGPbXv1YcTTzxYi186+
 9Wm0kkoJWYYXtwxm9WdHkiY4VkQi6qDCU42rON5ZK9vHPaVv243kxc1CNLfipEVH7BUhUAEJx
 tvE81noKEfMRsGDCCX5miAuQM2Ic/OhogDViU9idzkMXmu3wct8fmtTjBmaN+kXAkxkRgt/Ck
 30nNbmaqPxoyuPDbXVhFR2zEXekxCfNbQtyPddaDuLFr1n1/kUH8pppjEmzd9O1MNK/1RaNzj
 wjsPh0SUprrbiirIbd1svYdTKGDFgPZ5zNvVaMlslBFmmJHT0NUdrhf8xMKn02NspdFE5Qx0F
 LNtJWPrMLw3QJVsIcQAbtT3IIS1IgcF3zyfa+dWHjk6xQRGbiUqmgOcqJYZn1RFiEyA7H5Nro
 QMuBa0NKqhuJpdfukUba3qGp6zdR7ZO9p5mvD6nog76zbwIOx+3dBzUELxh98zNG0AegAMska
 +x8XVkaPzKh9hILDyJVA==

Add a security hook that allows a LSM to be notified when a task gets a
fatal signal. This patch is a previous step on the way to compute the
task crash period by the "brute" LSM (linux security module to detect
and mitigate fork brute force attack against vulnerable userspace
processes).

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 4 ++++
 include/linux/security.h      | 4 ++++
 kernel/signal.c               | 1 +
 security/security.c           | 5 +++++
 5 files changed, 15 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 477a597db013..0208df0955fa 100644
=2D-- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -220,6 +220,7 @@ LSM_HOOK(int, -ENOSYS, task_prctl, int option, unsigne=
d long arg2,
 	 unsigned long arg3, unsigned long arg4, unsigned long arg5)
 LSM_HOOK(void, LSM_RET_VOID, task_to_inode, struct task_struct *p,
 	 struct inode *inode)
+LSM_HOOK(void, LSM_RET_VOID, task_fatal_signal, const kernel_siginfo_t *s=
iginfo)
 LSM_HOOK(int, 0, ipc_permission, struct kern_ipc_perm *ipcp, short flag)
 LSM_HOOK(void, LSM_RET_VOID, ipc_getsecid, struct kern_ipc_perm *ipcp,
 	 u32 *secid)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index fb7f3193753d..beedaa6ee745 100644
=2D-- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -784,6 +784,10 @@
  *	security attributes, e.g. for /proc/pid inodes.
  *	@p contains the task_struct for the task.
  *	@inode contains the inode structure for the inode.
+ * @task_fatal_signal:
+ *	This hook allows security modules to be notified when a task gets a
+ *	fatal signal.
+ *	@siginfo contains the signal information.
  *
  * Security hooks for Netlink messaging.
  *
diff --git a/include/linux/security.h b/include/linux/security.h
index 8aeebd6646dc..e4025a13630f 100644
=2D-- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -430,6 +430,7 @@ int security_task_kill(struct task_struct *p, struct k=
ernel_siginfo *info,
 int security_task_prctl(int option, unsigned long arg2, unsigned long arg=
3,
 			unsigned long arg4, unsigned long arg5);
 void security_task_to_inode(struct task_struct *p, struct inode *inode);
+void security_task_fatal_signal(const kernel_siginfo_t *siginfo);
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag);
 void security_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid);
 int security_msg_msg_alloc(struct msg_msg *msg);
@@ -1165,6 +1166,9 @@ static inline int security_task_prctl(int option, un=
signed long arg2,
 static inline void security_task_to_inode(struct task_struct *p, struct i=
node *inode)
 { }

+static inline void security_task_fatal_signal(const kernel_siginfo_t *sig=
info)
+{ }
+
 static inline int security_ipc_permission(struct kern_ipc_perm *ipcp,
 					  short flag)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index ba4d1ef39a9e..d279df338f45 100644
=2D-- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2750,6 +2750,7 @@ bool get_signal(struct ksignal *ksig)
 		/*
 		 * Anything else is fatal, maybe with a core dump.
 		 */
+		security_task_fatal_signal(&ksig->info);
 		current->flags |=3D PF_SIGNALED;

 		if (sig_kernel_coredump(signr)) {
diff --git a/security/security.c b/security/security.c
index 5ac96b16f8fa..d9cf653a4e70 100644
=2D-- a/security/security.c
+++ b/security/security.c
@@ -1840,6 +1840,11 @@ void security_task_to_inode(struct task_struct *p, =
struct inode *inode)
 	call_void_hook(task_to_inode, p, inode);
 }

+void security_task_fatal_signal(const kernel_siginfo_t *siginfo)
+{
+	call_void_hook(task_fatal_signal, siginfo);
+}
+
 int security_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
 {
 	return call_int_hook(ipc_permission, 0, ipcp, flag);
=2D-
2.25.1

