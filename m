Return-Path: <SRS0=knqY=XB=lists.openwall.com=kernel-hardening-return-16843-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C65C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 15:27:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F432214E0
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Sep 2019 15:27:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F432214E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16843-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21548 invoked by uid 550); 6 Sep 2019 15:26:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20264 invoked from network); 6 Sep 2019 15:26:18 -0000
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
Subject: [PATCH v2 5/5] doc: Add documentation for the fs.open_mayexec_enforce sysctl
Date: Fri,  6 Sep 2019 17:24:55 +0200
Message-Id: <20190906152455.22757-6-mic@digikod.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
References: <20190906152455.22757-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

Changes since v1:
* move from LSM/Yama to sysctl/fs

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 Documentation/admin-guide/sysctl/fs.rst | 43 +++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/fs.rst b/Documentation/admin-guide/sysctl/fs.rst
index 2a45119e3331..f2f5bbe428d6 100644
--- a/Documentation/admin-guide/sysctl/fs.rst
+++ b/Documentation/admin-guide/sysctl/fs.rst
@@ -37,6 +37,7 @@ Currently, these files are in /proc/sys/fs:
 - inode-nr
 - inode-state
 - nr_open
+- open_mayexec_enforce
 - overflowuid
 - overflowgid
 - pipe-user-pages-hard
@@ -165,6 +166,48 @@ system needs to prune the inode list instead of allocating
 more.
 
 
+open_mayexec_enforce
+--------------------
+
+The ``O_MAYEXEC`` flag can be passed to :manpage:`open(2)` to only open regular
+files that are expected to be executable.  If the file is not identified as
+executable, then the syscall returns -EACCES.  This may allow a script
+interpreter to check executable permission before reading commands from a file.
+One interesting use case is to enforce a "write xor execute" policy through
+interpreters.
+
+Thanks to this flag, it is possible to enforce the ``noexec`` mount option
+(i.e.  the underlying mount point of the file is mounted with MNT_NOEXEC or its
+underlying superblock is SB_I_NOEXEC) not only on ELF binaries but also on
+scripts.  This may be possible thanks to script interpreters using the
+``O_MAYEXEC`` flag.  The executable permission is then checked before reading
+commands from a file, and thus can enforce the ``noexec`` at the interpreter
+level by propagating this security policy to the scripts.  To be fully
+effective, these interpreters also need to handle the other ways to execute
+code (for which the kernel can't help): command line parameters (e.g., option
+``-e`` for Perl), module loading (e.g., option ``-m`` for Python), stdin, file
+sourcing, environment variables, configuration files...  According to the
+threat model, it may be acceptable to allow some script interpreters (e.g.
+Bash) to interpret commands from stdin, may it be a TTY or a pipe, because it
+may not be enough to (directly) perform syscalls.
+
+There is two complementary security policies: enforce the ``noexec`` mount
+option, or enforce executable file permission.  These policies are handled by
+the ``fs.open_mayexec_enforce`` sysctl (writable only with ``CAP_MAC_ADMIN``)
+as a bitmask:
+
+1 - mount restriction:
+    check that the mount options for the underlying VFS mount do not prevent
+    execution.
+
+2 - file permission restriction:
+    check that the to-be-opened file is marked as executable for the current
+    process (e.g., POSIX permissions).
+
+Code samples can be found in tools/testing/selftests/exec/omayexec.c and
+https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC .
+
+
 overflowgid & overflowuid
 -------------------------
 
-- 
2.23.0

