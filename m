Return-Path: <SRS0=c6IK=4H=lists.openwall.com=kernel-hardening-return-17830-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894B6C3404C
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8F1E22B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MxFF3Jv/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8F1E22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17830-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30368 invoked by uid 550); 19 Feb 2020 00:08:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30286 invoked from network); 19 Feb 2020 00:08:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=l6scMayGLTv8i90n5kl1qjpFIVxp1ij4wxIMmOxT7WY=;
        b=MxFF3Jv/EWuhcxvZl8W5ImYcIiftihQ17JrQuHbGUe20LeBqGWlX0Vs6EqB8LFvumk
         b4ZoyiHXFOiODzyJoXD5yx1cna013lW8Pi2WUil5kfKJ4aedq1jjXZg4P8fML2UAyTyQ
         /uNIUrr21WgVaMdydYT05C0JnLFxVqjKAJsDDyn+vQuSScdem6mYvmOJiF6hb0qLTEw0
         Smd2xgO77Gu1gxaZmS0EyOZN3oetuc1I+tCOXl2LodF41Ek5dZApBYffEvCiAu/ywSMJ
         +XuBMpKej6buzdbjJGHsVoEc5I0LNkBH4XpX2SCaya8u2R9u8a9PAO1CbeaL1bxUo0gF
         FQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=l6scMayGLTv8i90n5kl1qjpFIVxp1ij4wxIMmOxT7WY=;
        b=tijk1Hb7y47dQSzYF3Ibz5ruwQhs/adx2x5a1cRyDNKm4Y8BwEkTTdfyMZw6e8o7kZ
         ebkMZnNFczkoYPvhUzcyULIUvSNr4ExZlPAPQP4qpXxDBb3ByztYSm/j1cbHaMjoql0H
         po1yIyTffBdFrvr9Cclg2R5Gr9TepLZXMHLjiFhFGFDZj2SypR9vf0SUiKwNozZc1c1p
         PWRUTeCxljMwVAlthMBZO29OZ2ev+ddcNw1QCFK3gbsme/TH5YBJjQzHXmAukiJkReBB
         M2IUYnEaEdwoSfzhf+xlFwjScYKyle0zqtGPglkOUm6m5dapXQ28fQT8TF643zyDIOKs
         I4KQ==
X-Gm-Message-State: APjAAAWgyn+ZCeDuXiDMdXQwY0GZT/RWUd6EiJepkNq/XGof5nLl/Zr6
	KsWulfqPsOcAqFt+ILAz173hlDFn3AK2fYHNve8=
X-Google-Smtp-Source: APXvYqy3zHVo0z8Du/q8/Or94E/PkF5YNEjibMIbCyb79vcUFl2W+utvk9qo3cjFU6si1C3cTLmny5LfSy/puV4ifSs=
X-Received: by 2002:a67:f144:: with SMTP id t4mr12321250vsm.36.1582070919665;
 Tue, 18 Feb 2020 16:08:39 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:09 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 04/12] scs: disable when function graph tracing is enabled
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

The graph tracer hooks returns by modifying frame records on the
(regular) stack, but with SCS the return address is taken from the
shadow stack, and the value in the frame record has no effect. As we
don't currently have a mechanism to determine the corresponding slot
on the shadow stack (and to pass this through the ftrace
infrastructure), for now let's disable SCS when the graph tracer is
enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 66b34fd0df54..4102b8e0eea9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -535,6 +535,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
 
 config SHADOW_CALL_STACK
 	bool "Clang Shadow Call Stack"
+	depends on !FUNCTION_GRAPH_TRACER
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	help
 	  This option enables Clang's Shadow Call Stack, which uses a
-- 
2.25.0.265.gbab2e86ba0-goog

