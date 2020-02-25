Return-Path: <SRS0=e5Yv=4N=lists.openwall.com=kernel-hardening-return-17914-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 789BDC35E01
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CA6FF2084E
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o7vwSCWz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA6FF2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17914-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3673 invoked by uid 550); 25 Feb 2020 17:40:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3587 invoked from network); 25 Feb 2020 17:40:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/9ynHIjebmTtgZE9DUTlwVjGdkmD9QfvZQiqhOExK9Y=;
        b=o7vwSCWzTZQYP7RYWcSjGD6CpDAB5oOvCiPmaDLzo25KnXRfX+NUrDok0q2y0mGfIa
         TDZrXM9faPShPRy4a6WiU0N5UIJawHlnPCJfHebtHrH5fvwpUKCDI+tLjTcvUoZXDeaB
         HCszEPkk37N+dLtmZiSu0APRUzakK7UtyMUDF5BWhTy6i22v7izEycfB2f+6f0SG52UX
         a6DuVXYMOkhGQurfoTI6OFw6fWv0lxkEhyIlwp/KPXUNbvGuN/nLmhBhm4IMlnyF0qei
         Qo7+V5ZpS5ueHVWgq55uxj/h3LF9pK5y+dwb8XA7OUhBm3/Bp2RIxaOxSVJIBZIb1iZV
         Wu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/9ynHIjebmTtgZE9DUTlwVjGdkmD9QfvZQiqhOExK9Y=;
        b=U/yrK/hD4/opGElqauLGqAHQcM7mulmnWwMEXEwArCtH4aSc7C40wI8LdfwbqiHGIX
         /7EbHKHJiCSkmXqaUqfT0VYfmY3xh6y//CbtEt2Zyuu4Jc9WYq60u9EXdWBcA1Iw2f6/
         1fOYBBy+cftWlPS/PW3EvXAP7RQPLQwzHDD/uTtQCQqdjCcNsESI+Bpbxgpk1Sb8BEVE
         9F5eZ2xc0IlM0EPTs+ztQf3HoWcYjklcZ01nwobedRDFY/d3UUDEwiU68LBL5NGKunW3
         YsbQY2f9HmpfxQ0x+7WPZ5Zo6t7K2ZGkQMwEBr2HKN01TobI6Ye4P57iBEZm6zMS3Te/
         FsGg==
X-Gm-Message-State: APjAAAVqJFESrhihVekzYsdhVitzq7Zz8/QVFoIP1aYbNPpiKBP293eJ
	pmzpkKYZoYPgdxc1X4/jRJc8X4zg6AIeWmPsS/0=
X-Google-Smtp-Source: APXvYqxvXT5YFgJDX3OV+onXaZib4AkO6FSAZUIUlR7kvR8/LVLBi4op9vXOxKw+pDWwfIzeWhkA7GqRpKGKFMrVwjA=
X-Received: by 2002:a63:5a65:: with SMTP id k37mr60903965pgm.264.1582652411820;
 Tue, 25 Feb 2020 09:40:11 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:30 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 09/12] arm64: disable SCS for hypervisor code
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
index a3a6a2ba9a63..0f0603f55ea0 100644
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
2.25.0.265.gbab2e86ba0-goog

