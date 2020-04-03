Return-Path: <SRS0=Byex=5T=lists.openwall.com=kernel-hardening-return-18420-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55297C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 18:19:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AEB5A206CC
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 18:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEB5A206CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18420-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32267 invoked by uid 550); 3 Apr 2020 18:18:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32043 invoked from network); 3 Apr 2020 18:18:04 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <legion@kernel.org>,
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
	David Howells <dhowells@redhat.com>
Subject: [PATCH v11 1/8] proc: rename struct proc_fs_info to proc_fs_opts
Date: Fri,  3 Apr 2020 20:06:41 +0200
Message-Id: <20200403180648.721362-2-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200403180648.721362-1-gladkov.alexey@gmail.com>
References: <20200403180648.721362-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 03 Apr 2020 18:07:24 +0000 (UTC)

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/proc_namespace.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 273ee82d8aa9..9a8b624bc3db 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -37,23 +37,23 @@ static __poll_t mounts_poll(struct file *file, poll_table *wait)
 	return res;
 }
 
-struct proc_fs_info {
+struct proc_fs_opts {
 	int flag;
 	const char *str;
 };
 
 static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 {
-	static const struct proc_fs_info fs_info[] = {
+	static const struct proc_fs_opts fs_opts[] = {
 		{ SB_SYNCHRONOUS, ",sync" },
 		{ SB_DIRSYNC, ",dirsync" },
 		{ SB_MANDLOCK, ",mand" },
 		{ SB_LAZYTIME, ",lazytime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = fs_opts; fs_infop->flag; fs_infop++) {
 		if (sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
@@ -63,7 +63,7 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 
 static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 {
-	static const struct proc_fs_info mnt_info[] = {
+	static const struct proc_fs_opts mnt_opts[] = {
 		{ MNT_NOSUID, ",nosuid" },
 		{ MNT_NODEV, ",nodev" },
 		{ MNT_NOEXEC, ",noexec" },
@@ -72,9 +72,9 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_RELATIME, ",relatime" },
 		{ 0, NULL }
 	};
-	const struct proc_fs_info *fs_infop;
+	const struct proc_fs_opts *fs_infop;
 
-	for (fs_infop = mnt_info; fs_infop->flag; fs_infop++) {
+	for (fs_infop = mnt_opts; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
-- 
2.25.2

