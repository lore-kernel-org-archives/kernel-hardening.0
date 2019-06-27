Return-Path: <SRS0=v6IF=U2=lists.openwall.com=kernel-hardening-return-16311-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3D2C5B576
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 22:15:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E52A208E3
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 22:15:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="eLCHTMjY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E52A208E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zytor.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16311-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9647 invoked by uid 550); 27 Jun 2019 22:15:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9626 invoked from network); 27 Jun 2019 22:15:47 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5RMFImh472851
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019061801; t=1561673719;
	bh=8ZTuFEkOgg6P4ySct4Z1PzgcWHbNGCdp1oLL8agGzvs=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=eLCHTMjYgAxz6SBFeKpoHl3LPl/4iksicuPt06p+S2RjpJBTXxx3NWq2r5tzSOGnT
	 71+eNG7vDDRUdMm1ORNy2alTpHQ90Pa66jYglckghCLFFqmo/lcZn4XpjjB67u87Ns
	 b236J1zdoNTYaXMsV3QMMw6eLe4TGuprUQDcfspLc7K0TTAB6ukRyR9jq2fka5C7CG
	 iFIcLyZDIzGBPT76n+H9aF/bp1ywLVmUI2S+HgZ6yOJ6SMFmT29vFjxmO6JtSNNu6t
	 jNB5ZS2nY2sHTfddNBR/KcZEH3de20ZJSGpS0+3T1by62iJLxlgT3+8F8S6OOoGysF
	 oP8UIkNiaJmiQ==
Date: Thu, 27 Jun 2019 15:15:18 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-e0a446ce394a7915f2ffc03f9bb610c5ac4dbbf1@git.kernel.org>
Cc: hpa@zytor.com, mingo@kernel.org, kernel-hardening@lists.openwall.com,
        keescook@chromium.org, fweimer@redhat.com, luto@kernel.org,
        bp@alien8.de, jannh@google.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org>
References: <75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] x86/vsyscall: Document odd SIGSEGV error code for
 vsyscalls
Git-Commit-ID: e0a446ce394a7915f2ffc03f9bb610c5ac4dbbf1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

Commit-ID:  e0a446ce394a7915f2ffc03f9bb610c5ac4dbbf1
Gitweb:     https://git.kernel.org/tip/e0a446ce394a7915f2ffc03f9bb610c5ac4dbbf1
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Wed, 26 Jun 2019 21:45:05 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2019 00:04:39 +0200

x86/vsyscall: Document odd SIGSEGV error code for vsyscalls

Even if vsyscall=none, user page faults on the vsyscall page are reported
as though the PROT bit in the error code was set.  Add a comment explaining
why this is probably okay and display the value in the test case.

While at it, explain why the behavior is correct with respect to PKRU.

Modify also the selftest to print the odd error code so that there is a
way to demonstrate the odd behaviour.

If anyone really cares about more accurate emulation, the behaviour could
be changed. But that needs a real good justification.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org

---
 arch/x86/mm/fault.c                         | 7 +++++++
 tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 288a5462076f..58e4f1f00bbc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -710,6 +710,10 @@ static void set_signal_archinfo(unsigned long address,
 	 * To avoid leaking information about the kernel page
 	 * table layout, pretend that user-mode accesses to
 	 * kernel addresses are always protection faults.
+	 *
+	 * NB: This means that failed vsyscalls with vsyscall=none
+	 * will have the PROT bit.  This doesn't leak any
+	 * information and does not appear to cause any problems.
 	 */
 	if (address >= TASK_SIZE_MAX)
 		error_code |= X86_PF_PROT;
@@ -1375,6 +1379,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 *
 	 * The vsyscall page does not have a "real" VMA, so do this
 	 * emulation before we go searching for VMAs.
+	 *
+	 * PKRU never rejects instruction fetches, so we don't need
+	 * to consider the PF_PK bit.
 	 */
 	if (is_vsyscall_vaddr(address)) {
 		if (emulate_vsyscall(hw_error_code, regs, address))
diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index 0b4f1cc2291c..4c9a8d76dba0 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -183,9 +183,13 @@ static inline long sys_getcpu(unsigned * cpu, unsigned * node,
 }
 
 static jmp_buf jmpbuf;
+static volatile unsigned long segv_err;
 
 static void sigsegv(int sig, siginfo_t *info, void *ctx_void)
 {
+	ucontext_t *ctx = (ucontext_t *)ctx_void;
+
+	segv_err =  ctx->uc_mcontext.gregs[REG_ERR];
 	siglongjmp(jmpbuf, 1);
 }
 
@@ -416,8 +420,11 @@ static int test_vsys_r(void)
 	} else if (!can_read && should_read_vsyscall) {
 		printf("[FAIL]\tWe don't have read access, but we should\n");
 		return 1;
+	} else if (can_read) {
+		printf("[OK]\tWe have read access\n");
 	} else {
-		printf("[OK]\tgot expected result\n");
+		printf("[OK]\tWe do not have read access: #PF(0x%lx)\n",
+		       segv_err);
 	}
 #endif
 
