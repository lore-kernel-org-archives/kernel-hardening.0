Return-Path: <SRS0=XHNm=5W=lists.openwall.com=kernel-hardening-return-18439-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B6AC2BA1E
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:43:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE37824990
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 16:43:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sFTilaim"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE37824990
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18439-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27844 invoked by uid 550); 6 Apr 2020 16:42:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27771 invoked from network); 6 Apr 2020 16:42:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=og4BfgkxEdyP0L7K3K2SXksO/AChbKUXMouXqYPSA00=;
        b=sFTilaimS0olRUWr52P6NjZp8iOs10uO0Z0JxM5Uuc4SjrkX4akRPhGMMko6yn6Vjl
         ws3NQWWVJtJ3ueU7u0ytNYHOplXfphbPsUfJrc6hmnfKIl9LG70ErBmGNeEAaScsBIsa
         8pzQNL6ueTZCTceiNxzsBsZ4KCIrIv1gusx7ObuDw8OyHYxmtcP4Mhcku3xGZumdZOoc
         822uP7JCGsr7Bd/cARY+mTanl8Xs4pkuavmztPyJ4QiMT2w19+ROUOHp2IOOfM+O1hNX
         7nYMkWpEpPknWEovRK6lAkDgfAOYFuYN4lNw2My6u1IqRuL++rFvl2FIx6OjAvMIwUcN
         E4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=og4BfgkxEdyP0L7K3K2SXksO/AChbKUXMouXqYPSA00=;
        b=aiXo+7hqAgEBhkuQrvUNzPFyMcjVBAY1RMnLACJsgR7nf901wsMCLBOjRyMjW7jAae
         5A77IpM90HxF2tjdIg6bpTBxxuTPPxTh1OgEOalJNztPQgmzQtq6/sVYfHeNMkQcWgL8
         uVfDjJSBmkuc5q/w2Jyu0v5wFInhkSscMAX7wN9Af79dLftz6Ui3pTitnP8cAVxDQfjr
         ARsRVA3g2aZwgOi4s3vPnjkPAzQM+IQ0bPGvkTZhmiKBStnATSPSh8wgpj4YHVzHj1vX
         +OS6xmPDGJU4VONpeup2PTSDaEcgh2d24RqvuE87ognYq6haTeLmPa/8/bgCfZ8UDLxH
         7cuQ==
X-Gm-Message-State: AGi0PuZOD6kcBi6ECByExWgrc5sPPyIsM/nDRJHW6Vbpwccb6ITBJ4/q
	TG9Drff9WvCjzj7Hf4Hqh+XQOLNu8moD21xoOkA=
X-Google-Smtp-Source: APiQypJDVItbvdsaAcfKFSSNsMelQNBO6U0MvHJemAJCSTnqHm4EIsriO2lzZR7x/iXYclFFASObx3hqbCBuu2Gzn3g=
X-Received: by 2002:a63:c504:: with SMTP id f4mr1623499pgd.292.1586191321112;
 Mon, 06 Apr 2020 09:42:01 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:18 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 09/12] arm64: disable SCS for hypervisor code
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable SCS for code that runs at a different exception level by
adding __noscs to __hyp_text.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a8..875b106c5d98 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -13,7 +13,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
-#define __hyp_text __section(.hyp.text) notrace
+#define __hyp_text __section(.hyp.text) notrace __noscs
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
-- 
2.26.0.292.g33ef6b2f38-goog

