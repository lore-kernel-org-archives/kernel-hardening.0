Return-Path: <SRS0=VFYV=5A=lists.openwall.com=kernel-hardening-return-18138-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AA2C2BB1D
	for <kernel-hardening@archiver.kernel.org>; Sun, 15 Mar 2020 15:27:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FC0D20578
	for <kernel-hardening@archiver.kernel.org>; Sun, 15 Mar 2020 15:27:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FC0D20578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18138-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5129 invoked by uid 550); 15 Mar 2020 15:26:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3924 invoked from network); 15 Mar 2020 15:26:15 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
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
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v9 7/8] proc: move hidepid values to uapi as they are user interface to mount
Date: Sun, 15 Mar 2020 16:25:22 +0100
Message-Id: <08f4488dc372c23c3c8511999cf77814e70ce292.1584285253.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584285253.git.gladkov.alexey@gmail.com>
References: <cover.1584285253.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/proc_fs.h      |  9 +--------
 include/uapi/linux/proc_fs.h | 13 +++++++++++++
 2 files changed, 14 insertions(+), 8 deletions(-)
 create mode 100644 include/uapi/linux/proc_fs.h

diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index afd38cae2339..d259817ec913 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -7,6 +7,7 @@
 
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <uapi/linux/proc_fs.h>
 
 struct proc_dir_entry;
 struct seq_file;
@@ -27,14 +28,6 @@ struct proc_ops {
 	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 };
 
-/* definitions for hide_pid field */
-enum {
-	HIDEPID_OFF	  = 0,
-	HIDEPID_NO_ACCESS = 1,
-	HIDEPID_INVISIBLE = 2,
-	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
-};
-
 /* definitions for proc mount option pidonly */
 enum {
 	PROC_PIDONLY_OFF = 0,
diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
new file mode 100644
index 000000000000..dc6d717aa6ec
--- /dev/null
+++ b/include/uapi/linux/proc_fs.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_PROC_FS_H
+#define _UAPI_PROC_FS_H
+
+/* definitions for hide_pid field */
+enum {
+	HIDEPID_OFF            = 0,
+	HIDEPID_NO_ACCESS      = 1,
+	HIDEPID_INVISIBLE      = 2,
+	HIDEPID_NOT_PTRACEABLE = 4,
+};
+
+#endif
-- 
2.25.1

