Return-Path: <SRS0=33Cj=76=lists.openwall.com=kernel-hardening-return-19005-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69081C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 20:56:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B153B21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 20:56:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B153B21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19005-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13439 invoked by uid 550); 17 Jun 2020 20:56:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13407 invoked from network); 17 Jun 2020 20:56:30 -0000
Date: Wed, 17 Jun 2020 16:56:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>,
 kernel-hardening@lists.openwall.com, Oscar Carter <oscar.carter@gmx.com>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tracing: Use linker magic instead of recasting
 ftrace_ops_list_func()
Message-ID: <20200617165616.52241bde@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, all function casts need to be
removed.

This means that ftrace_ops_list_func() can no longer be defined as
ftrace_ops_no_ops(). The reason for ftrace_ops_no_ops() is to use that when
an architecture calls ftrace_ops_list_func() with only two parameters
(called from assembly). And to make sure there's no C side-effects, those
archs call ftrace_ops_no_ops() which only has two parameters, as
ftrace_ops_list_func() has four parameters.

Instead of a typecast, use vmlinux.lds.h to define ftrace_ops_list_func() to
arch_ftrace_ops_list_func() that will define the proper set of parameters.

Link: https://lore.kernel.org/r/20200614070154.6039-1-oscar.carter@gmx.com

Requested-by: Oscar Carter <oscar.carter@gmx.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/asm-generic/vmlinux.lds.h |  7 ++++++-
 kernel/trace/ftrace.c             | 23 ++++++++++-------------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db600ef218d7..120babd9ba44 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -145,13 +145,18 @@
  * Need to also make ftrace_stub_graph point to ftrace_stub
  * so that the same stub location may have different protocols
  * and not mess up with C verifiers.
+ *
+ * ftrace_ops_list_func will be defined as arch_ftrace_ops_list_func
+ * as some archs will have a different prototype for that function
+ * but ftrace_ops_list_func() will have a single prototype.
  */
 #define MCOUNT_REC()	. = ALIGN(8);				\
 			__start_mcount_loc = .;			\
 			KEEP(*(__mcount_loc))			\
 			KEEP(*(__patchable_function_entries))	\
 			__stop_mcount_loc = .;			\
-			ftrace_stub_graph = ftrace_stub;
+			ftrace_stub_graph = ftrace_stub;	\
+			ftrace_ops_list_func = arch_ftrace_ops_list_func;
 #else
 # ifdef CONFIG_FUNCTION_TRACER
 #  define MCOUNT_REC()	ftrace_stub_graph = ftrace_stub;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f060838e9cbb..b775d399026e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -119,14 +119,9 @@ struct ftrace_ops __rcu *ftrace_ops_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 struct ftrace_ops global_ops;
 
-#if ARCH_SUPPORTS_FTRACE_OPS
-static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op, struct pt_regs *regs);
-#else
-/* See comment below, where ftrace_ops_list_func is defined */
-static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
-#define ftrace_ops_list_func ((ftrace_func_t)ftrace_ops_no_ops)
-#endif
+/* Defined by vmlinux.lds.h see the commment above arch_ftrace_ops_list_func for details */
+void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
+			  struct ftrace_ops *op, struct pt_regs *regs);
 
 static inline void ftrace_ops_init(struct ftrace_ops *ops)
 {
@@ -6859,21 +6854,23 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
  * Note, CONFIG_DYNAMIC_FTRACE_WITH_REGS expects a full regs to be saved.
  * An architecture can pass partial regs with ftrace_ops and still
  * set the ARCH_SUPPORTS_FTRACE_OPS.
+ *
+ * In vmlinux.lds.h, ftrace_ops_list_func() is defined to be
+ * arch_ftrace_ops_list_func.
  */
 #if ARCH_SUPPORTS_FTRACE_OPS
-static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-				 struct ftrace_ops *op, struct pt_regs *regs)
+void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
+			       struct ftrace_ops *op, struct pt_regs *regs)
 {
 	__ftrace_ops_list_func(ip, parent_ip, NULL, regs);
 }
-NOKPROBE_SYMBOL(ftrace_ops_list_func);
 #else
-static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip)
+void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	__ftrace_ops_list_func(ip, parent_ip, NULL, NULL);
 }
-NOKPROBE_SYMBOL(ftrace_ops_no_ops);
 #endif
+NOKPROBE_SYMBOL(arch_ftrace_ops_list_func);
 
 /*
  * If there's only one function registered but it does not support
-- 
2.25.4

