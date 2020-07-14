Return-Path: <SRS0=rdCs=AZ=lists.openwall.com=kernel-hardening-return-19313-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F48C43465
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 18:17:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86CDF22955
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 18:17:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86CDF22955
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19313-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3354 invoked by uid 550); 14 Jul 2020 18:17:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3253 invoked from network); 14 Jul 2020 18:17:04 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 3/7] exec: Move path_noexec() check earlier
Date: Tue, 14 Jul 2020 20:16:34 +0200
Message-Id: <20200714181638.45751-4-mic@digikod.net>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714181638.45751-1-mic@digikod.net>
References: <20200714181638.45751-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

From: Kees Cook <keescook@chromium.org>

The path_noexec() check, like the regular file check, was happening too
late, letting LSMs see impossible execve()s. Check it earlier as well
in may_open() and collect the redundant fs/exec.c path_noexec() test
under the same robustness comment as the S_ISREG() check.

My notes on the call path, and related arguments, checks, etc:

do_open_execat()
    struct open_flags open_exec_flags = {
        .open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
        .acc_mode = MAY_EXEC,
        ...
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            file = alloc_empty_file(open_flags, current_cred());
            do_open(nameidata, file, open_flags)
                may_open(path, acc_mode, open_flag)
                    /* new location of MAY_EXEC vs path_noexec() test */
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        security_file_open(f)
                        open()
    /* old location of path_noexec() test */

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20200605160013.3954297-4-keescook@chromium.org
---
 fs/exec.c  | 12 ++++--------
 fs/namei.c |  4 ++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index bdc6a6eb5dce..4eea20c27b01 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -147,10 +147,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	 * and check again at the very end too.
 	 */
 	error = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
-		goto exit;
-
-	if (path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
 		goto exit;
 
 	fsnotify_open(file);
@@ -897,10 +895,8 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 	 * and check again at the very end too.
 	 */
 	err = -EACCES;
-	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
-		goto exit;
-
-	if (path_noexec(&file->f_path))
+	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
+			 path_noexec(&file->f_path)))
 		goto exit;
 
 	err = deny_write_access(file);
diff --git a/fs/namei.c b/fs/namei.c
index a559ad943970..ddc9b25540fe 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2863,6 +2863,10 @@ static int may_open(const struct path *path, int acc_mode, int flag)
 			return -EACCES;
 		flag &= ~O_TRUNC;
 		break;
+	case S_IFREG:
+		if ((acc_mode & MAY_EXEC) && path_noexec(path))
+			return -EACCES;
+		break;
 	}
 
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
-- 
2.27.0

