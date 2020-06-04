Return-Path: <SRS0=me/M=7R=lists.openwall.com=kernel-hardening-return-18922-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E967C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67C5F20772
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 13:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C5F20772
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18922-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9497 invoked by uid 550); 4 Jun 2020 13:51:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9440 invoked from network); 4 Jun 2020 13:51:11 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKAdfvJmk5cJtK5g50ZHk8hu9sp158iPwKZPpTWkeYg=;
        b=UsOyl0hhAxV2O+vPGpZXS8K+qqt4BWh3U4xzCyoW5mTmpXk/E7cFCzt4KB1WDPaGJ0
         CiPLNH3MJBdatLZIMlDlaiprSXNS9DDKL6WmI1BCGX6ecR3YpjSBwRZMiQm55c3qG3mn
         QGzrJMCDzNVoMIGGRsSwvFDS5L3xIB+RNfsuzmOpeLotrELcN11aWcXNGHhB7P5DIzky
         EfQ2BV5qsh5g8o/G4CpC5co1hE7806nFtI2dECJAvwZcXevgqwou0Nk0x9NhjXvgMdln
         ePz26UVexCsdRXK3kohwYlNR1+rhMg2UNAtiQifgLC38USx0gnO0Sse+o/Kx5HiWWh3g
         UiJA==
X-Gm-Message-State: AOAM531Z4YACCBh6SO3njR8+d184JHfk+QjZRr96d8ewUuYLCfgpZfqp
	eA99WM7Y38K+RIrOvvSHpoo=
X-Google-Smtp-Source: ABdhPJyaEJiFG1nukoZekZitzyjRXSvRiSbJSp8S8jS/4CPjpOJZ15oCqdnMtSvYh0QGwlrPyIn8nA==
X-Received: by 2002:a2e:9917:: with SMTP id v23mr2338833lji.225.1591278660052;
        Thu, 04 Jun 2020 06:51:00 -0700 (PDT)
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
Subject: [PATCH 3/5] gcc-plugins/stackleak: Add 'verbose' plugin parameter
Date: Thu,  4 Jun 2020 16:49:55 +0300
Message-Id: <20200604134957.505389-4-alex.popov@linux.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200604134957.505389-1-alex.popov@linux.com>
References: <20200604134957.505389-1-alex.popov@linux.com>
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
 scripts/gcc-plugins/stackleak_plugin.c | 31 +++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index 0769c5b9156d..19358712d4ed 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -33,6 +33,8 @@ __visible int plugin_is_GPL_compatible;
 static int track_frame_size = -1;
 static bool build_for_x86 = false;
 static const char track_function[] = "stackleak_track_stack";
+static bool disable = false;
+static bool verbose = false;
 
 /*
  * Mark these global variables (roots) for gcc garbage collector since
@@ -45,6 +47,7 @@ static struct plugin_info stackleak_plugin_info = {
 	.help = "track-min-size=nn\ttrack stack for functions with a stack frame size >= nn bytes\n"
 		"arch=target_arch\tspecify target build arch\n"
 		"disable\t\tdo not activate the plugin\n"
+		"verbose\t\tprint info about the instrumentation\n"
 };
 
 static void add_stack_tracking_gcall(gimple_stmt_iterator *gsi)
@@ -98,6 +101,10 @@ static tree get_current_stack_pointer_decl(void)
 		return var;
 	}
 
+	if (verbose) {
+		fprintf(stderr, "stackleak: missing current_stack_pointer in %s()\n",
+			DECL_NAME_POINTER(current_function_decl));
+	}
 	return NULL_TREE;
 }
 
@@ -366,6 +373,7 @@ static bool remove_stack_tracking_gasm(void)
  */
 static unsigned int stackleak_cleanup_execute(void)
 {
+	const char *fn = DECL_NAME_POINTER(current_function_decl);
 	bool removed = false;
 
 	/*
@@ -376,11 +384,17 @@ static unsigned int stackleak_cleanup_execute(void)
 	 * For more info see gcc commit 7072df0aae0c59ae437e.
 	 * Let's leave such functions instrumented.
 	 */
-	if (cfun->calls_alloca)
+	if (cfun->calls_alloca) {
+		if (verbose)
+			fprintf(stderr, "stackleak: instrument %s() old\n", fn);
 		return 0;
+	}
 
-	if (large_stack_frame())
+	if (large_stack_frame()) {
+		if (verbose)
+			fprintf(stderr, "stackleak: instrument %s()\n", fn);
 		return 0;
+	}
 
 	if (lookup_attribute_spec(get_identifier("no_caller_saved_registers")))
 		removed = remove_stack_tracking_gasm();
@@ -506,9 +520,6 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 
 	/* Parse the plugin arguments */
 	for (i = 0; i < argc; i++) {
-		if (!strcmp(argv[i].key, "disable"))
-			return 0;
-
 		if (!strcmp(argv[i].key, "track-min-size")) {
 			if (!argv[i].value) {
 				error(G_("no value supplied for option '-fplugin-arg-%s-%s'"),
@@ -531,6 +542,10 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
 
 			if (!strcmp(argv[i].value, "x86"))
 				build_for_x86 = true;
+		} else if (!strcmp(argv[i].key, "disable")) {
+			disable = true;
+		} else if (!strcmp(argv[i].key, "verbose")) {
+			verbose = true;
 		} else {
 			error(G_("unknown option '-fplugin-arg-%s-%s'"),
 					plugin_name, argv[i].key);
@@ -538,6 +553,12 @@ __visible int plugin_init(struct plugin_name_args *plugin_info,
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
2.25.2

