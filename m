Return-Path: <SRS0=Rsl9=7R=lists.openwall.com=kernel-hardening-return-18920-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58150C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8BFAA20772
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BFAA20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18920-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7335 invoked by uid 550); 4 Jun 2020 13:50:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7259 invoked from network); 4 Jun 2020 13:50:56 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HscaqQ3a9rlG7LMvxfetj9PZadqBQlxA9luDvY709kI=;
        b=VlAcWbxTO2bVAGAHOvP62xKoRJaUI4B/DdQURLhBS0w5W7ZedLOl8vECMg4zUpewD2
         /ygIEymXNE5jVhm+MdRTxgOqoChz6shgOHWh+uCSsYhgzOIEL+WRSkRBhOyvANu2cC+R
         ZdAPti3JInxFJbUEvnZQQjRpr6mnqFHvQdJTQQu0rjB1/nSgSfRVva8PC1woBp29wyNa
         hP5dH/AZqZgiwJ+QtzogDCvZ5aHR4RCstDpGsyHFT/+zhqShKmg9pBq9WVJCn6kuAMm3
         YvBsXUdHJBaCuKuzNJ/NX0+MD4Ba6CwO3EE2oXpk7+Eh7z/zH1Ug2zpThpj8jgcil0/j
         ow7Q==
X-Gm-Message-State: AOAM530dQDbZE6WQB/ag9weQCXqUci006yug0KNHf6ViJx6f3kwxcoJE
	StFpjnxXDEXD51XwHoSeGSQ=
X-Google-Smtp-Source: ABdhPJwFgNnX9eJFc5s+1RCeoml4wry3jADSZr+Uk82Gr4M4947yFLD4wkmGdf/0gl0X9+wHhybHLA==
X-Received: by 2002:a2e:8ec9:: with SMTP id e9mr2378478ljl.152.1591278644807;
        Thu, 04 Jun 2020 06:50:44 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	Alexander Popov <alex.popov@linux.com>,
	kernel-hardening@lists.openwall.com,
	linux-kbuild@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	gcc@gcc.gnu.org
Cc: notify@kernel.org
Subject: [PATCH 1/5] gcc-plugins/stackleak: Exclude alloca() from the instrumentation logic
Date: Thu,  4 Jun 2020 16:49:53 +0300
Message-Id: <20200604134957.505389-2-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>
References: <20200604134957.505389-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some time ago Variable Length Arrays (VLA) were removed from the kernel.
The kernel is built with '-Wvla'. Let's exclude alloca() from the
instrumentation logic and make it simpler. The build-time assertion
against alloca() is added instead.

Unfortunately, for that assertion we can't simply check cfun->calls_alloca
during RTL phase. It turned out that gcc before version 7 called
allocate_dynamic_stack_space() from expand_stack_vars() for runtime
alignment of constant-sized stack variables. That caused cfun->calls_alloca
to be set for functions that don't use alloca().

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 scripts/gcc-plugins/stackleak_plugin.c | 51 +++++++++++---------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index cc75eeba0be1..1ecfe50d0bf5 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -9,10 +9,9 @@
  * any of the gcc libraries
  *
  * This gcc plugin is needed for tracking the lowest border of the kernel stack.
- * It instruments the kernel code inserting stackleak_track_stack() calls:
- *  - after alloca();
- *  - for the functions with a stack frame size greater than or equal
- *     to the "track-min-size" plugin parameter.
+ * It instruments the kernel code inserting stackleak_track_stack() calls
+ * for the functions with a stack frame size greater than or equal to
+ * the "track-min-size" plugin parameter.
  *
  * This plugin is ported from grsecurity/PaX. For more information see:
  *   https://grsecurity.net/
@@ -46,7 +45,7 @@ static struct plugin_info stackleak_plugin_info = {
 		"disable\t\tdo not activate the plugin\n"
 };
 
-static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
+static void stackleak_add_track_stack(gimple_stmt_iterator *gsi)
 {
 	gimple stmt;
 	gcall *stackleak_track_stack;
@@ -56,12 +55,7 @@ static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
 	/* Insert call to void stackleak_track_stack(void) */
 	stmt = gimple_build_call(track_function_decl, 0);
 	stackleak_track_stack = as_a_gcall(stmt);
-	if (after) {
-		gsi_insert_after(gsi, stackleak_track_stack,
-						GSI_CONTINUE_LINKING);
-	} else {
-		gsi_insert_before(gsi, stackleak_track_stack, GSI_SAME_STMT);
-	}
+	gsi_insert_before(gsi, stackleak_track_stack, GSI_SAME_STMT);
 
 	/* Update the cgraph */
 	bb = gimple_bb(stackleak_track_stack);
@@ -87,14 +81,13 @@ static bool is_alloca(gimple stmt)
 
 /*
  * Work with the GIMPLE representation of the code. Insert the
- * stackleak_track_stack() call after alloca() and into the beginning
- * of the function if it is not instrumented.
+ * stackleak_track_stack() call into the beginning of the function.
  */
 static unsigned int stackleak_instrument_execute(void)
 {
 	basic_block bb, entry_bb;
-	bool prologue_instrumented = false, is_leaf = true;
-	gimple_stmt_iterator gsi;
+	bool is_leaf = true;
+	gimple_stmt_iterator gsi = { 0 };
 
 	/*
 	 * ENTRY_BLOCK_PTR is a basic block which represents possible entry
@@ -111,27 +104,17 @@ static unsigned int stackleak_instrument_execute(void)
 	 */
 	FOR_EACH_BB_FN(bb, cfun) {
 		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
-			gimple stmt;
-
-			stmt = gsi_stmt(gsi);
+			gimple stmt = gsi_stmt(gsi);
 
 			/* Leaf function is a function which makes no calls */
 			if (is_gimple_call(stmt))
 				is_leaf = false;
 
-			if (!is_alloca(stmt))
-				continue;
-
-			/* Insert stackleak_track_stack() call after alloca() */
-			stackleak_add_track_stack(&gsi, true);
-			if (bb == entry_bb)
-				prologue_instrumented = true;
+			/* Variable Length Arrays are forbidden in the kernel */
+			gcc_assert(!is_alloca(stmt));
 		}
 	}
 
-	if (prologue_instrumented)
-		return 0;
-
 	/*
 	 * Special cases to skip the instrumentation.
 	 *
@@ -168,7 +151,7 @@ static unsigned int stackleak_instrument_execute(void)
 		bb = single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun));
 	}
 	gsi = gsi_after_labels(bb);
-	stackleak_add_track_stack(&gsi, false);
+	stackleak_add_track_stack(&gsi);
 
 	return 0;
 }
@@ -185,12 +168,20 @@ static bool large_stack_frame(void)
 /*
  * Work with the RTL representation of the code.
  * Remove the unneeded stackleak_track_stack() calls from the functions
- * which don't call alloca() and don't have a large enough stack frame size.
+ * that don't have a large enough stack frame size.
  */
 static unsigned int stackleak_cleanup_execute(void)
 {
 	rtx_insn *insn, *next;
 
+	/*
+	 * gcc before version 7 called allocate_dynamic_stack_space() from
+	 * expand_stack_vars() for runtime alignment of constant-sized stack
+	 * variables. That caused cfun->calls_alloca to be set for functions
+	 * that don't use alloca().
+	 * For more info see gcc commit 7072df0aae0c59ae437e.
+	 * Let's leave such functions instrumented.
+	 */
 	if (cfun->calls_alloca)
 		return 0;
 
-- 
2.25.2

