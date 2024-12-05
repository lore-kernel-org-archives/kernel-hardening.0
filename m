Return-Path: <kernel-hardening-return-21887-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B8D60E7716D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2024 16:10:57 +0000 (UTC)
Received: (qmail 10011 invoked by uid 550); 5 Dec 2024 16:10:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9980 invoked from network); 5 Dec 2024 16:10:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733414995;
	bh=qnmDxHFXi6N4fToRcmhVEwvrvRtsDGj6kxHcV7qI41w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=whclG3JSDD/Ew1OxL9RBYs5MGeSCn4prrQwcJ0jIyZRBfUSfy4hYsrAvSO6A6NsqI
	 hq/rpFUs1xIw8SJXqDSvfYrRnTBpuOlgRpt4uHhrjzjDIKWGBKNRUVnumINBWJMmkO
	 QJhN+SpANCYo0Zk4oiPqSQLxpxfXXSJcju023kYM=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Elliott Hughes <enh@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Scott Shell <scottsh@microsoft.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v22 5/8] samples/check-exec: Add set-exec
Date: Thu,  5 Dec 2024 17:09:22 +0100
Message-ID: <20241205160925.230119-6-mic@digikod.net>
In-Reply-To: <20241205160925.230119-1-mic@digikod.net>
References: <20241205160925.230119-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Add a simple tool to set SECBIT_EXEC_RESTRICT_FILE or
SECBIT_EXEC_DENY_INTERACTIVE before executing a command.  This is useful
to easily test against enlighten script interpreters.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20241205160925.230119-6-mic@digikod.net
---

Changes since v19:
* Rename file and directory.
* Update securebits and related arguments.
* Remove useless call to prctl() when securebits are unchanged.
---
 samples/Kconfig               |  7 +++
 samples/Makefile              |  1 +
 samples/check-exec/.gitignore |  1 +
 samples/check-exec/Makefile   | 14 ++++++
 samples/check-exec/set-exec.c | 85 +++++++++++++++++++++++++++++++++++
 5 files changed, 108 insertions(+)
 create mode 100644 samples/check-exec/.gitignore
 create mode 100644 samples/check-exec/Makefile
 create mode 100644 samples/check-exec/set-exec.c

diff --git a/samples/Kconfig b/samples/Kconfig
index b288d9991d27..efa28ceadc42 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -291,6 +291,13 @@ config SAMPLE_CGROUP
 	help
 	  Build samples that demonstrate the usage of the cgroup API.
 
+config SAMPLE_CHECK_EXEC
+	bool "Exec secure bits examples"
+	depends on CC_CAN_LINK && HEADERS_INSTALL
+	help
+	  Build a tool to easily configure SECBIT_EXEC_RESTRICT_FILE and
+	  SECBIT_EXEC_DENY_INTERACTIVE.
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index b85fa64390c5..f988202f3a30 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -3,6 +3,7 @@
 
 subdir-$(CONFIG_SAMPLE_AUXDISPLAY)	+= auxdisplay
 subdir-$(CONFIG_SAMPLE_ANDROID_BINDERFS) += binderfs
+subdir-$(CONFIG_SAMPLE_CHECK_EXEC)	+= check-exec
 subdir-$(CONFIG_SAMPLE_CGROUP) += cgroup
 obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
 obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
diff --git a/samples/check-exec/.gitignore b/samples/check-exec/.gitignore
new file mode 100644
index 000000000000..3f8119112ccf
--- /dev/null
+++ b/samples/check-exec/.gitignore
@@ -0,0 +1 @@
+/set-exec
diff --git a/samples/check-exec/Makefile b/samples/check-exec/Makefile
new file mode 100644
index 000000000000..d9f976e3ff98
--- /dev/null
+++ b/samples/check-exec/Makefile
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: BSD-3-Clause
+
+userprogs-always-y := \
+	set-exec
+
+userccflags += -I usr/include
+
+.PHONY: all clean
+
+all:
+	$(MAKE) -C ../.. samples/check-exec/
+
+clean:
+	$(MAKE) -C ../.. M=samples/check-exec/ clean
diff --git a/samples/check-exec/set-exec.c b/samples/check-exec/set-exec.c
new file mode 100644
index 000000000000..ba86a60a20dd
--- /dev/null
+++ b/samples/check-exec/set-exec.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Simple tool to set SECBIT_EXEC_RESTRICT_FILE, SECBIT_EXEC_DENY_INTERACTIVE,
+ * before executing a command.
+ *
+ * Copyright © 2024 Microsoft Corporation
+ */
+
+#define _GNU_SOURCE
+#define __SANE_USERSPACE_TYPES__
+#include <errno.h>
+#include <linux/prctl.h>
+#include <linux/securebits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/prctl.h>
+#include <unistd.h>
+
+static void print_usage(const char *argv0)
+{
+	fprintf(stderr, "usage: %s -f|-i -- <cmd> [args]...\n\n", argv0);
+	fprintf(stderr, "Execute a command with\n");
+	fprintf(stderr, "- SECBIT_EXEC_RESTRICT_FILE set: -f\n");
+	fprintf(stderr, "- SECBIT_EXEC_DENY_INTERACTIVE set: -i\n");
+}
+
+int main(const int argc, char *const argv[], char *const *const envp)
+{
+	const char *cmd_path;
+	char *const *cmd_argv;
+	int opt, secbits_cur, secbits_new;
+	bool has_policy = false;
+
+	secbits_cur = prctl(PR_GET_SECUREBITS);
+	if (secbits_cur == -1) {
+		/*
+		 * This should never happen, except with a buggy seccomp
+		 * filter.
+		 */
+		perror("ERROR: Failed to get securebits");
+		return 1;
+	}
+
+	secbits_new = secbits_cur;
+	while ((opt = getopt(argc, argv, "fi")) != -1) {
+		switch (opt) {
+		case 'f':
+			secbits_new |= SECBIT_EXEC_RESTRICT_FILE |
+				       SECBIT_EXEC_RESTRICT_FILE_LOCKED;
+			has_policy = true;
+			break;
+		case 'i':
+			secbits_new |= SECBIT_EXEC_DENY_INTERACTIVE |
+				       SECBIT_EXEC_DENY_INTERACTIVE_LOCKED;
+			has_policy = true;
+			break;
+		default:
+			print_usage(argv[0]);
+			return 1;
+		}
+	}
+
+	if (!argv[optind] || !has_policy) {
+		print_usage(argv[0]);
+		return 1;
+	}
+
+	if (secbits_cur != secbits_new &&
+	    prctl(PR_SET_SECUREBITS, secbits_new)) {
+		perror("Failed to set secure bit(s).");
+		fprintf(stderr,
+			"Hint: The running kernel may not support this feature.\n");
+		return 1;
+	}
+
+	cmd_path = argv[optind];
+	cmd_argv = argv + optind;
+	fprintf(stderr, "Executing command...\n");
+	execvpe(cmd_path, cmd_argv, envp);
+	fprintf(stderr, "Failed to execute \"%s\": %s\n", cmd_path,
+		strerror(errno));
+	return 1;
+}
-- 
2.47.1

