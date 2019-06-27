Return-Path: <SRS0=+hrU=U2=lists.openwall.com=kernel-hardening-return-16315-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24CBC4321A
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 22:18:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0CD55208E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 22:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="v9jRMpKc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CD55208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zytor.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16315-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17927 invoked by uid 550); 27 Jun 2019 22:18:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17875 invoked from network); 27 Jun 2019 22:18:39 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5RMIAO2473318
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019061801; t=1561673891;
	bh=JeYe5M8OdcYKuK4UMRuFplJR52KjbndV9b7BUqLhHlk=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=v9jRMpKcUXuHRJW2Ucgm6eUv+rvQaavCBa9PYEoYm1pwRxDgbMs18f+j+3eJ0vClo
	 5gWwTXvadc1DaQOwNh+M5hpZvHaB9DFehy9WG4OUj63G0M8tf5lV7e9KF2cEPNhiHo
	 +BYr1rnS8XSOHnNtwF2+tcuc568Yx5PjeE8myP2tExBhRbJ06ARnuLQd0ibHYuvCiY
	 1SQ71k5sLmzpY49YpPc/mqrNjAqUebNjT5BC6NiCSVRSEwbGk9WU8N7AlnLs0a6ZL6
	 +LPpkkkIdyFRnlcPREWr2lTN36RroK/lkbPtodUbsfW4WRTfcDqN3dcPoU4WQqZNep
	 JemStwPh5qBGA==
Date: Thu, 27 Jun 2019 15:18:10 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-7f0a5e0755832301e7b010eab46fb715c483ba60@git.kernel.org>
Cc: fweimer@redhat.com, jannh@google.com, peterz@infradead.org, hpa@zytor.com,
        tglx@linutronix.de, bp@alien8.de, luto@kernel.org,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, keescook@chromium.org
In-Reply-To: <0fe34229a9330e8f9de9765967939cc4f1cf26b1.1561610354.git.luto@kernel.org>
References: <0fe34229a9330e8f9de9765967939cc4f1cf26b1.1561610354.git.luto@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] selftests/x86: Add a test for process_vm_readv() on
 the vsyscall page
Git-Commit-ID: 7f0a5e0755832301e7b010eab46fb715c483ba60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

Commit-ID:  7f0a5e0755832301e7b010eab46fb715c483ba60
Gitweb:     https://git.kernel.org/tip/7f0a5e0755832301e7b010eab46fb715c483ba60
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Wed, 26 Jun 2019 21:45:09 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2019 00:04:40 +0200

selftests/x86: Add a test for process_vm_readv() on the vsyscall page

get_gate_page() is a piece of somewhat alarming code to make
get_user_pages() work on the vsyscall page.  Test it via
process_vm_readv().

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/0fe34229a9330e8f9de9765967939cc4f1cf26b1.1561610354.git.luto@kernel.org

---
 tools/testing/selftests/x86/test_vsyscall.c | 35 +++++++++++++++++++++++++++++
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
