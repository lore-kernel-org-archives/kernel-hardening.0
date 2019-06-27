Return-Path: <SRS0=rgzZ=U2=lists.openwall.com=kernel-hardening-return-16276-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF13C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:46:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CD80F21897
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6a64TQ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD80F21897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16276-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11598 invoked by uid 550); 27 Jun 2019 04:45:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11530 invoked from network); 27 Jun 2019 04:45:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610715;
	bh=Gc0XYDh9VdKQArOdtCH+oMY6poNwXHQC/rBzPi9XHqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6a64TQ59feOIvylVr9sPUS67s4qSRseGzQ/sY+cEsZxvrZzfWbeUuzD577bkr3XX
	 h7ibBugOm+oHmrS0Z32G9lA5eXefgWLpovont/9fXq7GFqJzN4l2hmORhtmg1QcZGZ
	 g7JErp2BRraz4SqhdzxUk9VPWGcaI9MMsmugSp18=
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
Subject: [PATCH v2 5/8] selftests/x86/vsyscall: Verify that vsyscall=none blocks execution
Date: Wed, 26 Jun 2019 21:45:06 -0700
Message-Id: <b413397c804265f8865f3e70b14b09485ea7c314.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If vsyscall=none accidentally still allowed vsyscalls, the test
wouldn't fail.  Fix it.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/x86/test_vsyscall.c | 76 ++++++++++++++-------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index 4c9a8d76dba0..34a1d35995ef 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -49,21 +49,21 @@ static void sethandler(int sig, void (*handler)(int, siginfo_t *, void *),
 }
 
 /* vsyscalls and vDSO */
-bool should_read_vsyscall = false;
+bool vsyscall_map_r = false, vsyscall_map_x = false;
 
 typedef long (*gtod_t)(struct timeval *tv, struct timezone *tz);
-gtod_t vgtod = (gtod_t)VSYS(0xffffffffff600000);
+const gtod_t vgtod = (gtod_t)VSYS(0xffffffffff600000);
 gtod_t vdso_gtod;
 
 typedef int (*vgettime_t)(clockid_t, struct timespec *);
 vgettime_t vdso_gettime;
 
 typedef long (*time_func_t)(time_t *t);
-time_func_t vtime = (time_func_t)VSYS(0xffffffffff600400);
+const time_func_t vtime = (time_func_t)VSYS(0xffffffffff600400);
 time_func_t vdso_time;
 
 typedef long (*getcpu_t)(unsigned *, unsigned *, void *);
-getcpu_t vgetcpu = (getcpu_t)VSYS(0xffffffffff600800);
+const getcpu_t vgetcpu = (getcpu_t)VSYS(0xffffffffff600800);
 getcpu_t vdso_getcpu;
 
 static void init_vdso(void)
@@ -107,7 +107,7 @@ static int init_vsys(void)
 	maps = fopen("/proc/self/maps", "r");
 	if (!maps) {
 		printf("[WARN]\tCould not open /proc/self/maps -- assuming vsyscall is r-x\n");
-		should_read_vsyscall = true;
+		vsyscall_map_r = true;
 		return 0;
 	}
 
@@ -133,12 +133,8 @@ static int init_vsys(void)
 		}
 
 		printf("\tvsyscall permissions are %c-%c\n", r, x);
-		should_read_vsyscall = (r == 'r');
-		if (x != 'x') {
-			vgtod = NULL;
-			vtime = NULL;
-			vgetcpu = NULL;
-		}
+		vsyscall_map_r = (r == 'r');
+		vsyscall_map_x = (x == 'x');
 
 		found = true;
 		break;
@@ -148,10 +144,8 @@ static int init_vsys(void)
 
 	if (!found) {
 		printf("\tno vsyscall map in /proc/self/maps\n");
-		should_read_vsyscall = false;
-		vgtod = NULL;
-		vtime = NULL;
-		vgetcpu = NULL;
+		vsyscall_map_r = false;
+		vsyscall_map_x = false;
 	}
 
 	return nerrs;
@@ -242,7 +236,7 @@ static int test_gtod(void)
 		err(1, "syscall gettimeofday");
 	if (vdso_gtod)
 		ret_vdso = vdso_gtod(&tv_vdso, &tz_vdso);
-	if (vgtod)
+	if (vsyscall_map_x)
 		ret_vsys = vgtod(&tv_vsys, &tz_vsys);
 	if (sys_gtod(&tv_sys2, &tz_sys) != 0)
 		err(1, "syscall gettimeofday");
@@ -256,7 +250,7 @@ static int test_gtod(void)
 		}
 	}
 
-	if (vgtod) {
+	if (vsyscall_map_x) {
 		if (ret_vsys == 0) {
 			nerrs += check_gtod(&tv_sys1, &tv_sys2, &tz_sys, "vsyscall", &tv_vsys, &tz_vsys);
 		} else {
@@ -277,7 +271,7 @@ static int test_time(void) {
 	t_sys1 = sys_time(&t2_sys1);
 	if (vdso_time)
 		t_vdso = vdso_time(&t2_vdso);
-	if (vtime)
+	if (vsyscall_map_x)
 		t_vsys = vtime(&t2_vsys);
 	t_sys2 = sys_time(&t2_sys2);
 	if (t_sys1 < 0 || t_sys1 != t2_sys1 || t_sys2 < 0 || t_sys2 != t2_sys2) {
@@ -298,7 +292,7 @@ static int test_time(void) {
 		}
 	}
 
-	if (vtime) {
+	if (vsyscall_map_x) {
 		if (t_vsys < 0 || t_vsys != t2_vsys) {
 			printf("[FAIL]\tvsyscall failed (ret:%ld output:%ld)\n", t_vsys, t2_vsys);
 			nerrs++;
@@ -334,7 +328,7 @@ static int test_getcpu(int cpu)
 	ret_sys = sys_getcpu(&cpu_sys, &node_sys, 0);
 	if (vdso_getcpu)
 		ret_vdso = vdso_getcpu(&cpu_vdso, &node_vdso, 0);
-	if (vgetcpu)
+	if (vsyscall_map_x)
 		ret_vsys = vgetcpu(&cpu_vsys, &node_vsys, 0);
 
 	if (ret_sys == 0) {
@@ -373,7 +367,7 @@ static int test_getcpu(int cpu)
 		}
 	}
 
-	if (vgetcpu) {
+	if (vsyscall_map_x) {
 		if (ret_vsys) {
 			printf("[FAIL]\tvsyscall getcpu() failed\n");
 			nerrs++;
@@ -414,10 +408,10 @@ static int test_vsys_r(void)
 		can_read = false;
 	}
 
-	if (can_read && !should_read_vsyscall) {
+	if (can_read && !vsyscall_map_r) {
 		printf("[FAIL]\tWe have read access, but we shouldn't\n");
 		return 1;
-	} else if (!can_read && should_read_vsyscall) {
+	} else if (!can_read && vsyscall_map_r) {
 		printf("[FAIL]\tWe don't have read access, but we should\n");
 		return 1;
 	} else if (can_read) {
@@ -431,6 +425,39 @@ static int test_vsys_r(void)
 	return 0;
 }
 
+static int test_vsys_x(void)
+{
+#ifdef __x86_64__
+	if (vsyscall_map_x) {
+		/* We already tested this adequately. */
+		return 0;
+	}
+
+	printf("[RUN]\tMake sure that vsyscalls really page fault\n");
+
+	bool can_exec;
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		vgtod(NULL, NULL);
+		can_exec = true;
+	} else {
+		can_exec = false;
+	}
+
+	if (can_exec) {
+		printf("[FAIL]\tExecuting the vsyscall did not page fault\n");
+		return 1;
+	} else if (segv_err & (1 << 4)) { /* INSTR */
+		printf("[OK]\tExecuting the vsyscall page failed: #PF(0x%lx)\n",
+		       segv_err);
+	} else {
+		printf("[FAILT]\tExecution failed with the wrong error: #PF(0x%lx)\n",
+		       segv_err);
+		return 1;
+	}
+#endif
+
+	return 0;
+}
 
 #ifdef __x86_64__
 #define X86_EFLAGS_TF (1UL << 8)
@@ -462,7 +489,7 @@ static int test_emulation(void)
 	time_t tmp;
 	bool is_native;
 
-	if (!vtime)
+	if (!vsyscall_map_x)
 		return 0;
 
 	printf("[RUN]\tchecking that vsyscalls are emulated\n");
@@ -504,6 +531,7 @@ int main(int argc, char **argv)
 
 	sethandler(SIGSEGV, sigsegv, 0);
 	nerrs += test_vsys_r();
+	nerrs += test_vsys_x();
 
 #ifdef __x86_64__
 	nerrs += test_emulation();
-- 
2.21.0

