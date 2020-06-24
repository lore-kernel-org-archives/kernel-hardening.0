Return-Path: <SRS0=3BT4=AF=lists.openwall.com=kernel-hardening-return-19124-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46544C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9F40820578
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MpnW9sRj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F40820578
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19124-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1794 invoked by uid 550); 24 Jun 2020 20:33:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1716 invoked from network); 24 Jun 2020 20:33:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y5ofKWtW7b37fMwYLfPdHt3IGKVdbeQxX7e2DATRt0o=;
        b=MpnW9sRj+tNBN3TDOB0E4bCD73iqcMpQvhC/oM2fJsIoYTK0vvtDvbgVlrqJ4oIK0n
         hUkrO/tMTdR+N69BPrGONWoZVqr/PGTcGNGx7KoFKTb76Da/RvpOWxtl8VBxl/EZOrgt
         5F9d69yFBuUFcdmnwtkp0D0VXoRY0s2h1Yr7OuAvRe5TUtgm7VwUMLCUarJXBYi3YH1w
         ecgv9j79/kdCnb16j6h9hpiIIbrE81Rw7ot9VeyVU18a4/rQr8YcJy/lwnjNPlRdogMZ
         F7b/c1lcoIWNDz5L2rbw2gGQuBQXJi1K+B1Nnm4G09LoPyPmFpMaZH6DTHw/IetIWtiC
         Gcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y5ofKWtW7b37fMwYLfPdHt3IGKVdbeQxX7e2DATRt0o=;
        b=oPMsd3ZHL90KsTTpjkXeEmZlxsoYkToJgbfk1eID2xSo8JoMZXCfx/9qnZbRqZOhSk
         khKjnlabvAl0sz3uYS3WB0LmYOFjvi1Pxkce1EGVdSIInh3KmI3CQGCI4IGAa0/CLOT7
         srZRoJTMBBcnnclNX8Lvw8vNTb6SbWsHeHpFNmomZXVRDALXxnJTNnyRqxkpn+I6AF2O
         nxAFXZH8fEkpiwqKZRsvnX7H8dXgiXD8fxOxw8TheIKawD3qCqfWu+WZXT7r4NpWuK49
         XjvdFmhHk4VBNs0wqNk3fwHEsWghD8pT4GKh9tW5vcCjph1VsdsGbXHykv2a86FWsUFH
         +igQ==
X-Gm-Message-State: AOAM532wcSuhsNFpAS45SBT5ftSmc3f5GH9x/cArrq8y5bys7elXW/82
	XZdfAcqkqoFEqI9muuLmOwRBMAi5HRjTsJIBhGI=
X-Google-Smtp-Source: ABdhPJyJOTQdckiniPybTRC01pO0CmjbQctgmf229uGzKfKGpm1EtRROJM8c/GsGd5lxXSpfxv2hqLta+vkNePH8WAU=
X-Received: by 2002:ad4:4ae1:: with SMTP id cp1mr752045qvb.91.1593030807024;
 Wed, 24 Jun 2020 13:33:27 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:54 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 16/22] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
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

Since arm64 does not use -pg in CC_FLAGS_FTRACE with
DYNAMIC_FTRACE_WITH_REGS, skip running recordmcount by
exporting CC_USING_PATCHABLE_FUNCTION_ENTRY.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index a0d94d063fa8..fc6c20a10291 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -115,6 +115,7 @@ endif
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)
   KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
   CC_FLAGS_FTRACE := -fpatchable-function-entry=2
+  export CC_USING_PATCHABLE_FUNCTION_ENTRY := 1
 endif
 
 # Default value
-- 
2.27.0.212.ge8ba1cc988-goog

