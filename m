Return-Path: <SRS0=+kaU=3O=lists.openwall.com=kernel-hardening-return-17610-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1D7C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jan 2020 13:08:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8A2C92071A
	for <kernel-hardening@archiver.kernel.org>; Sat, 25 Jan 2020 13:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A2C92071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17610-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12193 invoked by uid 550); 25 Jan 2020 13:07:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12076 invoked from network); 25 Jan 2020 13:07:06 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <gladkov.alexey@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v7 08/11] proc: instantiate only pids that we can ptrace on 'hidepid=4' mount option
Date: Sat, 25 Jan 2020 14:05:38 +0100
Message-Id: <20200125130541.450409-9-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200125130541.450409-1-gladkov.alexey@gmail.com>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If "hidepid=4" mount option is set then do not instantiate pids that
we can not ptrace. "hidepid=4" means that procfs should only contain
pids that the caller can ptrace.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/base.c          | 15 +++++++++++++++
 fs/proc/root.c          | 14 +++++++++++---
 include/linux/proc_fs.h |  1 +
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f4f1bcb28603..b55d205a7f6e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -699,6 +699,14 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
+	/*
+	 * If 'hidpid' mount option is set force a ptrace check,
+	 * we indicate that we are using a filesystem syscall
+	 * by passing PTRACE_MODE_READ_FSCREDS
+	 */
+	if (proc_fs_hide_pid(fs_info) == HIDEPID_NOT_PTRACABLE)
+		return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
+
 	if (proc_fs_hide_pid(fs_info) < hide_pid_min)
 		return true;
 	if (in_group_p(proc_fs_pid_gid(fs_info)))
@@ -3274,7 +3282,14 @@ struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
 	if (!task)
 		goto out;
 
+	/* Limit procfs to only ptracable tasks */
+	if (proc_fs_hide_pid(fs_info) == HIDEPID_NOT_PTRACABLE) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
+			goto out_put_task;
+	}
+
 	result = proc_pid_instantiate(dentry, task, NULL);
+out_put_task:
 	put_task_struct(task);
 out:
 	return result;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 3bb8df360cf7..57276cb65528 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -52,6 +52,15 @@ static const struct fs_parameter_description proc_fs_parameters = {
 	.specs		= proc_param_specs,
 };
 
+static inline int
+valid_hidepid(unsigned int value)
+{
+	return (value == HIDEPID_OFF ||
+		value == HIDEPID_NO_ACCESS ||
+		value == HIDEPID_INVISIBLE ||
+		value == HIDEPID_NOT_PTRACABLE);
+}
+
 static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -68,10 +77,9 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 
 	case Opt_hidepid:
+		if (!valid_hidepid(result.uint_32))
+			return invalf(fc, "proc: unknown value of hidepid.\n");
 		ctx->hidepid = result.uint_32;
-		if (ctx->hidepid < HIDEPID_OFF ||
-		    ctx->hidepid > HIDEPID_INVISIBLE)
-			return invalf(fc, "proc: hidepid value must be between 0 and 2.\n");
 		break;
 
 	default:
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index f307940f8311..6822548405a7 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -17,6 +17,7 @@ enum {
 	HIDEPID_OFF	  = 0,
 	HIDEPID_NO_ACCESS = 1,
 	HIDEPID_INVISIBLE = 2,
+	HIDEPID_NOT_PTRACABLE = 4, /* Limit pids to only ptracable pids */
 };
 
 struct proc_fs_info {
-- 
2.24.1

