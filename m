Return-Path: <SRS0=gPQ1=FP=lists.openwall.com=kernel-hardening-return-20588-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A236C4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 16D4C23F37
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:47:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16D4C23F37
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20588-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7441 invoked by uid 550); 11 Dec 2020 18:47:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7276 invoked from network); 11 Dec 2020 18:46:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=D6dzW9Nv9PxzQobvhFlQDWUjMujzTJKPO9b+q7PtBxA=;
        b=j80QiI4Ul6UgEkfC+jupmsvTxkEELd8wbgUjUZ6N8GZBz3X4UojppIFANKFCwEcr0b
         hjg7atDwt+r6dl376cixss8x61cmNs3p6kdE0NH0HxFb1RFB4vQfxhmnXPW46RXzb3jX
         w/C2Yv2wPOS6QjdjcS5NeKPbqbdp8shMph/o4hHfNZ5sJb5N3Ar0+qPkmusVLmg+5im/
         FXu/NZwu9TMocoPetDYE2QWKb90ZDlr4lbZ3N2VjoMkHvJaSPTfqO5DKNCfYjLKaMtOp
         PjFKT07Sh00XUoerVDLql1CWKexmWjEKEMlFf7a6DuR4Wtg99akEQhhQl7HctgCVr2eD
         quKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D6dzW9Nv9PxzQobvhFlQDWUjMujzTJKPO9b+q7PtBxA=;
        b=NCsJBxzbbvK2EhBiQ+lMPxqd/r3ggFoK8+IsBi8ckThJ43Dr2qMpi0WlCMCH7Slh2Q
         EEs+T/CffN1v/HKb89i0A9eTVYZ9CVH6MnPp9y6M1iZzf98HhZHgDc4350Cou7KwCeDI
         uaH9RNuJ5vB0Ikon0xaTiHt5pk8uv6X7NoG18lfFXE7+OMtmKVvIZMv9nJiJwGtkcz5W
         Dpy4cOZdrt7YCMCJqcAiq/OO2zzy+MSzQpgB4boJh080AwUd+6rt7HWNzxHU1ZwODIV2
         uWUkxiqPGNNN5qKgcCkIAeCfJIDehWoJxVBTgsP6MbkgU3MClC8aUVdoPFqh3upilUTB
         fvCg==
X-Gm-Message-State: AOAM532a3tfu36os/G7fpB/ZMmpm7Z0BrC3rxUfGyGdc7iXuFSw+TJij
	67d+7S0Av/5VMGut+/YRbVtS1tnYpH45vPitzxU=
X-Google-Smtp-Source: ABdhPJzTxDOAZu/cl6nSaAjpW3k/LNI+wnG91vRp8xhL+7QirY0I3Vi1skb6ONtaVKsVxERXnDfxMhqkc0oDgftg5yE=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a17:902:bb8c:b029:d9:261:5809 with
 SMTP id m12-20020a170902bb8cb02900d902615809mr3908181pls.29.1607712407508;
 Fri, 11 Dec 2020 10:46:47 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:23 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 06/16] kbuild: lto: add a default list of used symbols
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With CONFIG_LTO_CLANG, LLVM bitcode has not yet been compiled into a
binary when the .mod files are generated, which means they don't yet
contain references to certain symbols that will be present in the final
binaries. This includes intrinsic functions, such as memcpy, memmove,
and memset [1], and stack protector symbols [2]. This change adds a
default symbol list to use with CONFIG_TRIM_UNUSED_KSYMS when Clang's
LTO is used.

[1] https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
[2] https://llvm.org/docs/LangRef.html#llvm-stackprotector-intrinsic

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 init/Kconfig                | 1 +
 scripts/lto-used-symbollist | 5 +++++
 2 files changed, 6 insertions(+)
 create mode 100644 scripts/lto-used-symbollist

diff --git a/init/Kconfig b/init/Kconfig
index 0872a5a2e759..e88c919c1bf1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2297,6 +2297,7 @@ config TRIM_UNUSED_KSYMS
 config UNUSED_KSYMS_WHITELIST
 	string "Whitelist of symbols to keep in ksymtab"
 	depends on TRIM_UNUSED_KSYMS
+	default "scripts/lto-used-symbollist" if LTO_CLANG
 	help
 	  By default, all unused exported symbols will be un-exported from the
 	  build when TRIM_UNUSED_KSYMS is selected.
diff --git a/scripts/lto-used-symbollist b/scripts/lto-used-symbollist
new file mode 100644
index 000000000000..38e7bb9ebaae
--- /dev/null
+++ b/scripts/lto-used-symbollist
@@ -0,0 +1,5 @@
+memcpy
+memmove
+memset
+__stack_chk_fail
+__stack_chk_guard
-- 
2.29.2.576.ga3fc446d84-goog

