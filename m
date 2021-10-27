Return-Path: <SRS0=9cyR=PP=lists.openwall.com=kernel-hardening-return-21451-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F0C433F5
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Oct 2021 23:33:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3CAC461073
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Oct 2021 23:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3CAC461073
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 24219 invoked by uid 550); 27 Oct 2021 23:32:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24120 invoked from network); 27 Oct 2021 23:32:48 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ng2YLAGjTgfi7ZXzsgiV1oU6rhi1WCE6xhGOALow6N8=;
        b=38HCr9R/iUCeCLqOouuxsLEFL1CugijKYWpJc8QQD/jGqL3w7ACuMe1Uk5/74YlpoK
         h1d5tTqKpPoBHH4REVQ/CInwIKrOZUg96UoFrI2uAu0ZgGW1IsPOLdJkG4dSjqhNCvvi
         Ie8Cr/C6LOcEkkig0gslcXxbRDzYgcc+FSCxwNHKqj+ewg2lsQv0o8WTPKnLG8amaRL9
         S3Jmoon+Kj/tVfOYXUapHqapaeIe4wL0pjA4K78nMOcJLq+cqEhe/LMmWCnA4qv6GfMO
         tLz6o1FX8XaBh0VUljhcYGrucK/WDuouQqdxO2YhO+6mpOJl/eqj/wS6UyvejIS8rmkV
         JLMA==
X-Gm-Message-State: AOAM533lTWE9265Qs9suk3dSwM0gJgH+RZsoUBUbj7zCqDFd5azhrFaW
	jOrcFCiO38GVrYXg2MEUtqE=
X-Google-Smtp-Source: ABdhPJx/oH1sQYM3ucOrkOeiRhDVvUY8ozgOUVCjvcOZapDAKXV3lWX63KCqcaM0MusX11Fh9mCwIw==
X-Received: by 2002:a5d:4845:: with SMTP id n5mr878769wrs.251.1635377556876;
        Wed, 27 Oct 2021 16:32:36 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul McKenney <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Joerg Roedel <jroedel@suse.de>,
	Maciej Rozycki <macro@orcam.me.uk>,
	Muchun Song <songmuchun@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Petr Mladek <pmladek@suse.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Wei Liu <wl@xen.org>,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Laura Abbott <labbott@kernel.org>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Scull <ascull@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Jessica Yu <jeyu@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Wang Qing <wangqing@vivo.com>,
	Mel Gorman <mgorman@suse.de>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Andrew Klychkov <andrew.a.klychkov@gmail.com>,
	Mathieu Chouquet-Stringer <me@mathieu.digital>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stephen Kitt <steve@sk2.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Rapoport <rppt@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Alexander Popov <alex.popov@linux.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: notify@kernel.org
Subject: [PATCH v2 1/2] bug: do refactoring allowing to add a warning handling action
Date: Thu, 28 Oct 2021 02:32:14 +0300
Message-Id: <20211027233215.306111-2-alex.popov@linux.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027233215.306111-1-alex.popov@linux.com>
References: <20211027233215.306111-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do refactoring that allows adding a warning handling action,
in particular, pkill_on_warn. No functional changes intended.

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 include/asm-generic/bug.h | 31 +++++++++++++++++++++----------
 lib/bug.c                 | 19 +++++++++++++------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index edb0e2a602a8..881aeaf5a2d5 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -91,7 +91,15 @@ void warn_slowpath_fmt(const char *file, const int line, unsigned taint,
 		warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);	\
 		instrumentation_end();					\
 	} while (0)
-#else
+#ifndef WARN_ON_ONCE
+#define WARN_ON_ONCE(condition) ({					\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		DO_ONCE_LITE(__WARN_printf, TAINT_WARN, NULL);		\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+#else /* __WARN_FLAGS */
 extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
 #define __WARN()		__WARN_FLAGS(BUGFLAG_TAINT(TAINT_WARN))
 #define __WARN_printf(taint, arg...) do {				\
@@ -141,16 +149,19 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	unlikely(__ret_warn_on);					\
 })
 
-#ifndef WARN_ON_ONCE
-#define WARN_ON_ONCE(condition)					\
-	DO_ONCE_LITE_IF(condition, WARN_ON, 1)
-#endif
-
-#define WARN_ONCE(condition, format...)				\
-	DO_ONCE_LITE_IF(condition, WARN, 1, format)
+#define WARN_ONCE(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		DO_ONCE_LITE(__WARN_printf, TAINT_WARN, format);	\
+	unlikely(__ret_warn_on);					\
+})
 
-#define WARN_TAINT_ONCE(condition, taint, format...)		\
-	DO_ONCE_LITE_IF(condition, WARN_TAINT, 1, taint, format)
+#define WARN_TAINT_ONCE(condition, taint, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		DO_ONCE_LITE(__WARN_printf, taint, format);		\
+	unlikely(__ret_warn_on);					\
+})
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
diff --git a/lib/bug.c b/lib/bug.c
index 45a0584f6541..1a91f01412b8 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -156,16 +156,17 @@ struct bug_entry *find_bug(unsigned long bugaddr)
 
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
+	enum bug_trap_type bug_type = BUG_TRAP_TYPE_NONE;
 	struct bug_entry *bug;
 	const char *file;
 	unsigned line, warning, once, done;
 
 	if (!is_valid_bugaddr(bugaddr))
-		return BUG_TRAP_TYPE_NONE;
+		goto out;
 
 	bug = find_bug(bugaddr);
 	if (!bug)
-		return BUG_TRAP_TYPE_NONE;
+		goto out;
 
 	disable_trace_on_warning();
 
@@ -176,8 +177,10 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 	done = (bug->flags & BUGFLAG_DONE) != 0;
 
 	if (warning && once) {
-		if (done)
-			return BUG_TRAP_TYPE_WARN;
+		if (done) {
+			bug_type = BUG_TRAP_TYPE_WARN;
+			goto out;
+		}
 
 		/*
 		 * Since this is the only store, concurrency is not an issue.
@@ -198,7 +201,8 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		/* this is a WARN_ON rather than BUG/BUG_ON */
 		__warn(file, line, (void *)bugaddr, BUG_GET_TAINT(bug), regs,
 		       NULL);
-		return BUG_TRAP_TYPE_WARN;
+		bug_type = BUG_TRAP_TYPE_WARN;
+		goto out;
 	}
 
 	if (file)
@@ -207,7 +211,10 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		pr_crit("Kernel BUG at %pB [verbose debug info unavailable]\n",
 			(void *)bugaddr);
 
-	return BUG_TRAP_TYPE_BUG;
+	bug_type = BUG_TRAP_TYPE_BUG;
+
+out:
+	return bug_type;
 }
 
 static void clear_once_table(struct bug_entry *start, struct bug_entry *end)
-- 
2.31.1

