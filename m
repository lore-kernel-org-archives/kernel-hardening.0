Return-Path: <SRS0=4DIt=AF=lists.openwall.com=kernel-hardening-return-19120-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF8CC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 52D4B2080C
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="btHNoJ4L"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 52D4B2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19120-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1107 invoked by uid 550); 24 Jun 2020 20:33:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32720 invoked from network); 24 Jun 2020 20:33:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=79pxKTlkNWyJf2vmlsIGe03zgp7TGuVtfyoMyMkArK8=;
        b=btHNoJ4LCTKmKU6iX1nY/p97V+Ay3nMJGlrn7bXF/L/XPTDGtt58AsD3Mh0Aeg8xli
         i/d+HGMtV5Jn6jA8Cx1FqZSW6wKGv/sOjgspsd/CVSg+LkYGEeeEYLFxrYYGQ8I8QOWM
         Cf5JM3EZjmGV5qQFBgWfzxMp2Kdb9qPFRU+2kPmr0e4ZXejzdyDXKQQDGqzly1C9+syM
         lYUlij36WBcULQ7G2HzWI/6+G60YtbxUYFeFxnsxSan8nd8WAH4jUNFN9Tmd4BJJC3/J
         4MhqOa97DkCrf9Gdui9rH2qj5BT7xXSCfX6fHqyZfik5WekbjJGEyd8PzAGt7HITNkeO
         mMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=79pxKTlkNWyJf2vmlsIGe03zgp7TGuVtfyoMyMkArK8=;
        b=s7ao/Oy10YJLE6I4OcDmuLC/kbg71w8Bf460hif/63b3csgxqOnBrHBQwNePCV//hZ
         rw8ZXN0WQq3hg0QwKF9OymTDu35xx+H3EpsV2+qfkI2HDnZYl+F9rn7THB8C+KyJUmN6
         UAC892utmIwMrt4BhG30F5bxbOPmTgnGyQqxYjvPloNE95TW3vZIqOkYf1B9wjXG10PG
         0L6X8spExA5vpG7AZT3UR5DU08uk7oKNcWwSIHTfGVAAb0f97rNohcRvqx+3gSEMJxdR
         WLr7ClyK1Z1gL5LejhJh2IpBBMJTkUGEqDrsK3K3fyOWTeevai5beetQ+f5jNgnC5C5n
         qlQw==
X-Gm-Message-State: AOAM532hCqRgGmWbhP8lTLZkrxQHLCcdJlrgxooxDrcb7xudI0jZJ6RI
	DNQeStPhz7ODlXAECR4Q4A/k183cK98pqtXzVtg=
X-Google-Smtp-Source: ABdhPJy99/FHT6zeXiAeW8pt9PlVxSQustzITSBwdPIStntc1HUQSuUCUDUljn+nyEC3jv0BNwyMPNZxyCKzoS4QiwE=
X-Received: by 2002:a0c:f109:: with SMTP id i9mr18665621qvl.154.1593030799673;
 Wed, 24 Jun 2020 13:33:19 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:50 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 12/22] modpost: lto: strip .lto from module names
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, everything is compiled into LLVM bitcode, so we have to link
each module into native code before modpost. Kbuild uses the .lto.o
suffix for these files, which also ends up in module information. This
change strips the unnecessary .lto suffix from the module name.

Suggested-by: Bill Wendling <morbo@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/mod/modpost.c    | 16 +++++++---------
 scripts/mod/modpost.h    |  9 +++++++++
 scripts/mod/sumversion.c |  6 +++++-
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6aea65c65745..8352f8a1a138 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -17,7 +17,6 @@
 #include <ctype.h>
 #include <string.h>
 #include <limits.h>
-#include <stdbool.h>
 #include <errno.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
@@ -80,14 +79,6 @@ modpost_log(enum loglevel loglevel, const char *fmt, ...)
 		exit(1);
 }
 
-static inline bool strends(const char *str, const char *postfix)
-{
-	if (strlen(str) < strlen(postfix))
-		return false;
-
-	return strcmp(str + strlen(str) - strlen(postfix), postfix) == 0;
-}
-
 void *do_nofail(void *ptr, const char *expr)
 {
 	if (!ptr)
@@ -1975,6 +1966,10 @@ static char *remove_dot(char *s)
 		size_t m = strspn(s + n + 1, "0123456789");
 		if (m && (s[n + m] == '.' || s[n + m] == 0))
 			s[n] = 0;
+
+		/* strip trailing .lto */
+		if (strends(s, ".lto"))
+			s[strlen(s) - 4] = '\0';
 	}
 	return s;
 }
@@ -1998,6 +1993,9 @@ static void read_symbols(const char *modname)
 		/* strip trailing .o */
 		tmp = NOFAIL(strdup(modname));
 		tmp[strlen(tmp) - 2] = '\0';
+		/* strip trailing .lto */
+		if (strends(tmp, ".lto"))
+			tmp[strlen(tmp) - 4] = '\0';
 		mod = new_module(tmp);
 		free(tmp);
 	}
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 3aa052722233..fab30d201f9e 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -2,6 +2,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
+#include <stdbool.h>
 #include <string.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -180,6 +181,14 @@ static inline unsigned int get_secindex(const struct elf_info *info,
 	return info->symtab_shndx_start[sym - info->symtab_start];
 }
 
+static inline bool strends(const char *str, const char *postfix)
+{
+	if (strlen(str) < strlen(postfix))
+		return false;
+
+	return strcmp(str + strlen(str) - strlen(postfix), postfix) == 0;
+}
+
 /* file2alias.c */
 extern unsigned int cross_build;
 void handle_moddevtable(struct module *mod, struct elf_info *info,
diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index d587f40f1117..760e6baa7eda 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -391,10 +391,14 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 	struct md4_ctx md;
 	char *fname;
 	char filelist[PATH_MAX + 1];
+	int postfix_len = 1;
+
+	if (strends(modname, ".lto.o"))
+		postfix_len = 5;
 
 	/* objects for a module are listed in the first line of *.mod file. */
 	snprintf(filelist, sizeof(filelist), "%.*smod",
-		 (int)strlen(modname) - 1, modname);
+		 (int)strlen(modname) - postfix_len, modname);
 
 	buf = read_text_file(filelist);
 
-- 
2.27.0.212.ge8ba1cc988-goog

