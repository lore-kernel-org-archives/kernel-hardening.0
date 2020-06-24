Return-Path: <SRS0=Oajl=AF=lists.openwall.com=kernel-hardening-return-19116-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BEAC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3802220885
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:34:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EWRzLy7u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3802220885
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19116-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32072 invoked by uid 550); 24 Jun 2020 20:33:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31991 invoked from network); 24 Jun 2020 20:33:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RZTReFFMdjgTHNlONDHd9zt1v7eMyKbgxXLu5A5pzj0=;
        b=EWRzLy7ubn55a8LmKy3CDH4ngbdy7XK7KBx2ndgKQ/3d1qkgK3E2e2e0LoML9LtpAP
         te8DFa082g+gVIfEAqVPkw42n2K5N8oZDQPqI2EE+tN42iDW7P8u4zkwFKaeUaEIL3oq
         RsZa2tBkB8ErLDOh0+LYJEGFNduXUPYCZZp6PS5HSeXJMWIblGduZ6jmagNoIsWizsER
         wasijgerBJQ81R7rPMfgWDc43sju3PnN23fU0SKh+4T9fa3wRlwROOUy5biDfDpraPBM
         LfcrqPMgzOl+e9NbqEnHTOdpcfO4/PQ3tkVTmfAbrRs5+l+SSnKRsruNnEenHpqLqPiQ
         nuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RZTReFFMdjgTHNlONDHd9zt1v7eMyKbgxXLu5A5pzj0=;
        b=i6xGhO+ZBfG4/Og/wOFJ4Jfnw7gR6KgSuMSPcl+GxDFoVZDu9+p0ljt9B/NEA7P6+L
         Y3Hv+5pPoasIPamX8fI9+c7mXURO7bbf29lG87Rh+Jbk1MG7q6Z8xKJfAjmb8MTvt5h3
         j62BKM/rCyYVfImxXMBIl9zFOmQ3x9IKeURxWw0txv//YLZTprmrhjg+qAeDWYdXBbMl
         YwV4ThExJyt8X6uTM6kBIOvktgADj0EvFUFKlW24ZV2A4USLytxVan8oJy91wHZvasQ5
         AmX47IxxU3KPdJa6GUhRR5Yg3nbmrrolDHONrvYUHy+QFgLgsXpCXMCN3JgLw8I+SbMT
         nJdQ==
X-Gm-Message-State: AOAM532lCi42E+/YdO0pG6RtL2q6oOcNlFggfQatyNkyavqCj2qr/0p2
	ZVyuuWnWcnYl6e64OwSnBxHsIiRIkiogbJlJS6g=
X-Google-Smtp-Source: ABdhPJyU2t1AXfcgSNz/10D8PjugKl8rMw6I/kYhEGKclSW1I55A11LPtvbV37/K4/NXZ5XrSzlUdSrpZ+Ia6K6teRs=
X-Received: by 2002:a25:4e0a:: with SMTP id c10mr44794280ybb.346.1593030792698;
 Wed, 24 Jun 2020 13:33:12 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:46 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 08/22] kbuild: lto: remove duplicate dependencies from .mod files
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, llvm-nm prints out symbols for each archive member
separately, which results in a lot of duplicate dependencies in the
.mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
consists of several compilation units, the output can exceed the
default xargs command size limit and split the dependency list to
multiple lines, which results in used symbols getting trimmed.

This change removes duplicate dependencies, which will reduce the
probability of this happening and makes .mod files smaller and
easier to read.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 82977350f5a6..82b465ce3ca0 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -291,7 +291,7 @@ endef
 
 # List module undefined symbols (or empty line if not enabled)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
+cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
 else
 cmd_undef_syms = echo
 endif
-- 
2.27.0.212.ge8ba1cc988-goog

