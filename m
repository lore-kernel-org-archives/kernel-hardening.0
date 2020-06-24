Return-Path: <SRS0=aacZ=AF=lists.openwall.com=kernel-hardening-return-19094-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973F7C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:35:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CBE1A20857
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 12:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBE1A20857
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19094-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11369 invoked by uid 550); 24 Jun 2020 12:35:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11338 invoked from network); 24 Jun 2020 12:35:00 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U/neUUCsqT0PlemfvVIM6cUhi6vcMD7QDpY9m0/55MY=;
        b=PISITKpu4jPCDRUbdQlL/rllzaJuNlA8IoFDl03qFLllsTloIlbHjNCIHkfORPmY1a
         dsQbhcTtdCWhtnRra1KIX9Wm9uG309LJR0Hapc4xS2JS791YUJ9c+mrEIDFdxZy34Aqv
         g/0Jqj29dwT66poxkzGjpr1WxiQjS/5GA6h4w00ixIr2sQvcbdB6qRhRXuLjO53Uyf7F
         8wnwezPAWtaVbnCTuxQxkCkHxJjvh234EEh31jWVVWSIUzKP+2HAYCHqyy5M7asjodv1
         0CHi6nLao0IJaMgFDEnX2+TW1CcgKjBscnVy6kZdpR1dTH5DJYYwgcE922xksMRUNa+l
         IEGw==
X-Gm-Message-State: AOAM531+e4eBFZMszEojekrVDyhLwP87V9aZuA+U/f3rHDBVAZQ4kpD+
	OEA2rd654x/uFO0rog16V8E=
X-Google-Smtp-Source: ABdhPJz9JvvyfA9b1/190kREHa6PK+V5IrA3vD+WvU3Zfs4N16fAWbTWXRT7gUAU+aWUjakQ5UQxCQ==
X-Received: by 2002:a05:620a:10a4:: with SMTP id h4mr24496106qkk.320.1593002088433;
        Wed, 24 Jun 2020 05:34:48 -0700 (PDT)
From: Alexander Popov <alex.popov@linux.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>,
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
Subject: [PATCH v2 5/5] gcc-plugins/stackleak: Add 'verbose' plugin parameter
Date: Wed, 24 Jun 2020 15:33:30 +0300
Message-Id: <20200624123330.83226-6-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200624123330.83226-1-alex.popov@linux.com>
References: <20200624123330.83226-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add 'verbose' plugin parameter for stackleak gcc plugin.
It can be used for printing additional info about the kernel code
instrumentation.

For using it add the following to scripts/Makefile.gcc-plugins:
  gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK) \
    += -fplugin-arg-stackleak_plugin-verbose

Signed-off-by: Alexander Popov <alex.popov@linux.com>
---
 scripts/gcc-plugins/stackleak_plugin.c | 47 +++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index a18b0d4af456..48e141e07956 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -34,6 +34,8 @@ __visible int plugin_is_GPL_compatible;
 static int track_frame_size = -1;
 static bool build_for_x86 = false;
 static const char track_function[] = "stackleak_track_stack";
+static bool disable = false;
+static bool verbose = false;
 
 /*
  * Mark these global variables (roots) for gcc garbage collector since
@@ -46,6 +48,7 @@ static struct plugin_info stackleak_plugin_info = {
 	.help = "track-min-size=nn\ttrack stack for functions with a stack frame size >= nn bytes\n"
 		"arch=target_arch\tspecify target build arch\n"
 		"disable\t\tdo not activate the plugin\n"
+		"verbose\t\tprint info about the instrumentation\n"
 };
 
 static void add_stack_tracking_gcall(gimple_stmt_iterator *gsi, bool after)
@@ -102,6 +105,10 @@ static tree get_current_stack_pointer_decl(void)
 		return var;
 	}
 
+	if (verbose) {
+		fprintf(stderr, "stackleak: missing current_stack_pointer in %s()\n",
+			DECL_NAME_POINTER(current_function_decl));
+	}
 	return NULL_TREE;
 }
 
@@ -195,6 +202,11 @@ static unsigned int stackleak_instrument_execute(void)
 			if (!is_alloca(stmt))
 				continue;
 
+			if (verbose) {
+				fprintf(stderr, "stackleak: be careful, alloca() in %s()\n",
+					DECL_NAME_POINTER(current_function_decl));
+			}
+
 			/* Insert stackleak_track_stack() call after alloca() */
 			add_stack_tracking(&gsi, true);
 			if (bb == entry_bb)
@@ -384,13 +396,31 @@ static bool remove_stack_tracking_gasm(void)
  */
 static unsigned int stackleak_cleanup_execute(void)
 {
+	const char *fn = DECL_NAME_POINTER(current_function_decl);
 	bool removed = false;
 
-	if (cfun->calls_alloca)
+	/*
+	 * Leave stack tracking in functions that call alloca().
+	 * Additional case:
+	 *   gcc before version 7 called allocate_dynamic_stack_space() from
+	 *   expand_stack_vars() for runtime alignment of constant-sized stack
+	 *   variables. That caused cfun->calls_alloca to be set for functions
+	 *   that in fact don't use alloca().
+	 *   For more info see gcc commit 7072df0aae0c59ae437e.
+	 *   Let's leave such functions instrumented as well.
+	 */
+	if (cfun->calls_alloca) {
+		if (verbose)
+			fprintf(stderr, "stackleak: instrument %s(): calls_alloca\n", fn);
 		return 0;
+	}
 
-	if (large_stack_frame())
+	/* Leave stack tracking in functions with large stack frame */
+	if (large_stack_frame()) {
+		if (verbose)
+			fprintf(stderr, "stackleak: instrument %s()\n", fn);
 		return 0;
+	}
 
 	if (lookup_attribute_spec(get_identifier("no_caller_saved_registers")))
 		removed = remove_stack_tracking_gasm();
@@ -516,9 +546,6 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 
 	/* Parse the plugin arguments */
 	for (i = 0; i < argc; i++) {
-		if (!strcmp(argv[i].key, "disable"))
-			return 0;
-
 		if (!strcmp(argv[i].key, "track-min-size")) {
 			if (!argv[i].value) {
 				error(G_("no value supplied for option '-fplugin-arg-%s-%s'"),
@@ -541,6 +568,10 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 
 			if (!strcmp(argv[i].value, "x86"))
 				build_for_x86 = true;
+		} else if (!strcmp(argv[i].key, "disable")) {
+			disable = true;
+		} else if (!strcmp(argv[i].key, "verbose")) {
+			verbose = true;
 		} else {
 			error(G_("unknown option '-fplugin-arg-%s-%s'"),
 					plugin_name, argv[i].key);
@@ -548,6 +579,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 		}
 	}
 
+	if (disable) {
+		if (verbose)
+			fprintf(stderr, "stackleak: disabled for this translation unit\n");
+		return 0;
+	}
+
 	/* Give the information about the plugin */
 	register_callback(plugin_name, PLUGIN_INFO, NULL,
 						&stackleak_plugin_info);
-- 
2.25.4

