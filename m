Return-Path: <SRS0=+SM6=XB=lists.openwall.com=kernel-hardening-return-16839-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237FCC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 15:26:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E7912070C
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 15:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E7912070C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16839-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20242 invoked by uid 550); 6 Sep 2019 15:26:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20221 invoked from network); 6 Sep 2019 15:26:17 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Mimi Zohar <zohar@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
        Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 2/5] fs: Add a MAY_EXECMOUNT flag to infer the noexec mount propertie
Date: Fri,  6 Sep 2019 17:24:52 +0200
Message-Id: <20190906152455.22757-3-mic@digikod.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
References: <20190906152455.22757-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

An LSM doesn't get path information related to an access request to open
an inode.  This new (internal) MAY_EXECMOUNT flag enables an LSM to
check if the underlying mount point of an inode is marked as executable.
This is useful to implement a security policy taking advantage of the
noexec mount option.

This flag is set according to path_noexec(), which checks if a mount
point is mounted with MNT_NOEXEC or if the underlying superblock is
SB_I_NOEXEC.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 fs/namei.c         | 2 ++
 include/linux/fs.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 209c51a5226c..0a6b9483d0cb 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2968,6 +2968,8 @@ static int may_open(const struct path *path, int acc_mode, int flag)
 		break;
 	}
 
+	/* Pass the mount point executability. */
+	acc_mode |= path_noexec(path) ? 0 : MAY_EXECMOUNT;
 	error = inode_permission(inode, MAY_OPEN | acc_mode);
 	if (error)
 		return error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 848f5711bdf0..e57609dac8dd 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -101,6 +101,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_NOT_BLOCK		0x00000080
 /* the inode is opened with O_MAYEXEC */
 #define MAY_OPENEXEC		0x00000100
+/* the mount point is marked as executable */
+#define MAY_EXECMOUNT		0x00000200
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.23.0

