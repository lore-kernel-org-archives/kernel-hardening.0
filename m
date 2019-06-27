Return-Path: <SRS0=Uv/r=U2=lists.openwall.com=kernel-hardening-return-16278-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2106EC48BD7
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:46:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 702F321855
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yZUSulOZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 702F321855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16278-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13498 invoked by uid 550); 27 Jun 2019 04:45:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13382 invoked from network); 27 Jun 2019 04:45:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610717;
	bh=GFanELS7mYpj+8Mm6kvXhJm6aJW1EglXpZSE4hvViJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZUSulOZsbuP4mqVaY60lF4c5yu38hoUrhOvGCYAxsxU3t9mLiMCbCSNhN8O/F7za
	 mrCzK9QUwpDh7LqegVtHNMZVACGfbezvwdZMKnJD7whUzSiWYBnL40UgG6sBmsiJcr
	 ykTCw43v2QK5nnkizseAQuCFwKuf5NKJ9mb4Ffk4=
From: Andy Lutomirski <luto@kernel.org>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Weimer <fweimer@redhat.com>,
	Jann Horn <jannh@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 8/8] selftests/x86: Add a test for process_vm_readv() on the vsyscall page
Date: Wed, 26 Jun 2019 21:45:09 -0700
Message-Id: <0fe34229a9330e8f9de9765967939cc4f1cf26b1.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

get_gate_page() is a piece of somewhat alarming code to make
get_user_pages() work on the vsyscall page.  Test it via
process_vm_readv().

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/x86/test_vsyscall.c | 35 +++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index 34a1d35995ef..4602326b8f5b 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -18,6 +18,7 @@
 #include <sched.h>
 #include <stdbool.h>
 #include <setjmp.h>
+#include <sys/uio.h>
 
 #ifdef __x86_64__
 # define VSYS(x) (x)
@@ -459,6 +460,38 @@ static int test_vsys_x(void)
 	return 0;
 }
 
+static int test_process_vm_readv(void)
+{
+#ifdef __x86_64__
+	char buf[4096];
+	struct iovec local, remote;
+	int ret;
+
+	printf("[RUN]\tprocess_vm_readv() from vsyscall page\n");
+
+	local.iov_base = buf;
+	local.iov_len = 4096;
+	remote.iov_base = (void *)0xffffffffff600000;
+	remote.iov_len = 4096;
+	ret = process_vm_readv(getpid(), &local, 1, &remote, 1, 0);
+	if (ret != 4096) {
+		printf("[OK]\tprocess_vm_readv() failed (ret = %d, errno = %d)\n", ret, errno);
+		return 0;
+	}
+
+	if (vsyscall_map_r) {
+		if (!memcmp(buf, (const void *)0xffffffffff600000, 4096)) {
+			printf("[OK]\tIt worked and read correct data\n");
+		} else {
+			printf("[FAIL]\tIt worked but returned incorrect data\n");
+			return 1;
+		}
+	}
+#endif
+
+	return 0;
+}
+
 #ifdef __x86_64__
 #define X86_EFLAGS_TF (1UL << 8)
 static volatile sig_atomic_t num_vsyscall_traps;
@@ -533,6 +566,8 @@ int main(int argc, char **argv)
 	nerrs += test_vsys_r();
 	nerrs += test_vsys_x();
 
+	nerrs += test_process_vm_readv();
+
 #ifdef __x86_64__
 	nerrs += test_emulation();
 #endif
-- 
2.21.0

