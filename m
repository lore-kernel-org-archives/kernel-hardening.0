Return-Path: <SRS0=nJAY=U2=lists.openwall.com=kernel-hardening-return-16274-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93783C48BD6
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:45:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B774521897
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 04:45:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSmilcwV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B774521897
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16274-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11498 invoked by uid 550); 27 Jun 2019 04:45:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11430 invoked from network); 27 Jun 2019 04:45:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610713;
	bh=uUdOygK0rqjRhfS2izHQWMTu74AdMVwZ8TIO8xwkgsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSmilcwVR8LAIS4yO8RxBZPN+ITJVKAugnAB2Am0VWeEd9UiYUbVKo+W9VOZhViXF
	 Dm/IBu3ebpUzRUBREK48RoIzXMJWVDInJo/s1CxGkQXhRCRELQy5TyyWTxoRN6g/iv
	 /IBh4/FxdpO2bi6FGohuotd2+9juNYIsIRONCSHI=
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
Subject: [PATCH v2 2/8] x86/vsyscall: Add a new vsyscall=xonly mode
Date: Wed, 26 Jun 2019 21:45:03 -0700
Message-Id: <d17655777c21bc09a7af1bbcf74e6f2b69a51152.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With vsyscall emulation on, we still expose a readable vsyscall page
that contains syscall instructions that validly implement the
vsyscalls.  We need this because certain dynamic binary
instrumentation tools attempt to read the call targets of call
instructions in the instrumented code.  If the instrumented code
uses vsyscalls, then the vsyscal page needs to contain readable
code.

Unfortunately, leaving readable memory at a deterministic address
can be used to help various ASLR bypasses, so we gain some hardening
value if we disallow vsyscall reads.

Given how rarely the vsyscall page needs to be readable, add a
mechanism to make the vsyscall page be execute only.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++-
 arch/x86/Kconfig                              | 33 ++++++++++++++-----
 arch/x86/entry/vsyscall/vsyscall_64.c         | 16 +++++++--
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0082d1e56999..be8c3a680afa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5100,7 +5100,12 @@
 			targets for exploits that can control RIP.
 
 			emulate     [default] Vsyscalls turn into traps and are
-			            emulated reasonably safely.
+			            emulated reasonably safely.  The vsyscall
+				    page is readable.
+
+			xonly       Vsyscalls turn into traps and are
+			            emulated reasonably safely.  The vsyscall
+				    page is not readable.
 
 			none        Vsyscalls don't work at all.  This makes
 			            them quite hard to use for exploits but
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2bbbd4d1ba31..0182d2c67590 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2293,23 +2293,38 @@ choice
 	  it can be used to assist security vulnerability exploitation.
 
 	  This setting can be changed at boot time via the kernel command
-	  line parameter vsyscall=[emulate|none].
+	  line parameter vsyscall=[emulate|xonly|none].
 
 	  On a system with recent enough glibc (2.14 or newer) and no
 	  static binaries, you can say None without a performance penalty
 	  to improve security.
 
-	  If unsure, select "Emulate".
+	  If unsure, select "Emulate execution only".
 
 	config LEGACY_VSYSCALL_EMULATE
-		bool "Emulate"
+		bool "Full emulation"
 		help
-		  The kernel traps and emulates calls into the fixed
-		  vsyscall address mapping. This makes the mapping
-		  non-executable, but it still contains known contents,
-		  which could be used in certain rare security vulnerability
-		  exploits. This configuration is recommended when userspace
-		  still uses the vsyscall area.
+		  The kernel traps and emulates calls into the fixed vsyscall
+		  address mapping. This makes the mapping non-executable, but
+		  it still contains readable known contents, which could be
+		  used in certain rare security vulnerability exploits. This
+		  configuration is recommended when using legacy userspace
+		  that still uses vsyscalls along with legacy binary
+		  instrumentation tools that require code to be readable.
+
+		  An example of this type of legacy userspace is running
+		  Pin on an old binary that still uses vsyscalls.
+
+	config LEGACY_VSYSCALL_XONLY
+		bool "Emulate execution only"
+		help
+		  The kernel traps and emulates calls into the fixed vsyscall
+		  address mapping and does not allow reads.  This
+		  configuration is recommended when userspace might use the
+		  legacy vsyscall area but support for legacy binary
+		  instrumentation of legacy code is not needed.  It mitigates
+		  certain uses of the vsyscall area as an ASLR-bypassing
+		  buffer.
 
 	config LEGACY_VSYSCALL_NONE
 		bool "None"
diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index d9d81ad7a400..fedd7628f3a6 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -42,9 +42,11 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-static enum { EMULATE, NONE } vsyscall_mode =
+static enum { EMULATE, XONLY, NONE } vsyscall_mode =
 #ifdef CONFIG_LEGACY_VSYSCALL_NONE
 	NONE;
+#elif defined(CONFIG_LEGACY_VSYSCALL_XONLY)
+	XONLY;
 #else
 	EMULATE;
 #endif
@@ -54,6 +56,8 @@ static int __init vsyscall_setup(char *str)
 	if (str) {
 		if (!strcmp("emulate", str))
 			vsyscall_mode = EMULATE;
+		else if (!strcmp("xonly", str))
+			vsyscall_mode = XONLY;
 		else if (!strcmp("none", str))
 			vsyscall_mode = NONE;
 		else
@@ -357,12 +361,20 @@ void __init map_vsyscall(void)
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 
-	if (vsyscall_mode != NONE) {
+	/*
+	 * For full emulation, the page needs to exist for real.  In
+	 * execute-only mode, there is no PTE at all backing the vsyscall
+	 * page.
+	 */
+	if (vsyscall_mode == EMULATE) {
 		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
 			     PAGE_KERNEL_VVAR);
 		set_vsyscall_pgtable_user_bits(swapper_pg_dir);
 	}
 
+	if (vsyscall_mode == XONLY)
+		gate_vma.vm_flags = VM_EXEC;
+
 	BUILD_BUG_ON((unsigned long)__fix_to_virt(VSYSCALL_PAGE) !=
 		     (unsigned long)VSYSCALL_ADDR);
 }
-- 
2.21.0

