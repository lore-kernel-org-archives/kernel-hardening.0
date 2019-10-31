Return-Path: <SRS0=9Uld=YY=lists.openwall.com=kernel-hardening-return-17198-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0E1CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E41A4208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M2bQgEs0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E41A4208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17198-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1488 invoked by uid 550); 31 Oct 2019 16:59:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15938 invoked from network); 31 Oct 2019 16:47:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3L2fKWe0mnTKbOXtDJWS5MdWfgbISjm7SM0mf8jhMMs=;
        b=M2bQgEs0bbsNq8MNMFthK/YaXaNa7lsVfAcQUrIhxB6WHow3p7zT6DMI2hPzQ12JyE
         dBDu7tLmmK0EEcTfQyug+zjuDgAcD7mKPl6tI6HWHtIIlglIWBDrRvtighs9FmRdTeuA
         Utjfp/h/JCLg0sI4eJJnpaaKwajzXzqbouGFFnbQW8bF3vHks01IkHDwLbusJqIJbbtz
         HjJPj0I7fONVzT+V+kvjMVqj2r1bUa9I2Mu1YNcXlrszcM7cVDBp5tO3PZ8B+1C1keZf
         wVg7wmq11bbXPEPFRcmQQMxy7vNpqsJV3Tc3WBhABGzYCzx8tPiXjJJoVrXeY98hn2vr
         fLvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3L2fKWe0mnTKbOXtDJWS5MdWfgbISjm7SM0mf8jhMMs=;
        b=aW92NdETH6OsOGpInqNt013PWjD2HRaEjT3QGxrQazQ8Br/inWcVmMJdU39UR4huxt
         eQ248RwZ9lz5myRpfZA/LMw9/E7F2Pmn90IgXzEHujUV9UPGb1Eocqcx1doFAUhRZ0Nf
         9oRiPdzSVQZFAmWWfAkEegPIvqR7vJKPlfnRe+G2lGjWvRuTkP+NTdJqHbBTpbEI8bJR
         XIehsmA9Yv/svopGKfPNMW3WtPMhisdM2wI5BS2tzM0ZvRnXjrFo/1ymue1MtBw9rRo7
         936r2m3f9w6MKy40fXSbijG79uDe0MJb5YIDaAo7SpYlQU5UDhTacqCqNN5UHEART291
         FqJw==
X-Gm-Message-State: APjAAAXkt2/+EauWQ628BFoUkgxM81g+YscGRk7Gb2IIPdAsMjjYfhIs
	T0Sw+jIWXMlC286T1McgzolV4iYyUgz1312QMQI=
X-Google-Smtp-Source: APXvYqydEhVHkKqut2+3OaRd8Srg3EG2C5xvERxBciOyTLScaCHzKIIF3dA+VkAqRL7gbd3nEjDN/XqnvRbx9STn/rY=
X-Received: by 2002:a63:d0d:: with SMTP id c13mr7797535pgl.138.1572540438115;
 Thu, 31 Oct 2019 09:47:18 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:33 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't lose the current task's shadow stack when the CPU is suspended.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index 8939c87c4dce..0cde2f473971 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 12
+#define NR_CTX_REGS 13
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index fdabf40a83c8..0e7c353c9dfd 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -49,6 +49,8 @@
  * cpu_do_suspend - save CPU registers context
  *
  * x0: virtual address of context pointer
+ *
+ * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
  */
 ENTRY(cpu_do_suspend)
 	mrs	x2, tpidr_el0
@@ -73,6 +75,9 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	str	x18, [x0, #96]
+#endif
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -89,6 +94,10 @@ ENTRY(cpu_do_resume)
 	ldp	x9, x10, [x0, #48]
 	ldp	x11, x12, [x0, #64]
 	ldp	x13, x14, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	ldr	x18, [x0, #96]
+	str	xzr, [x0, #96]
+#endif
 	msr	tpidr_el0, x2
 	msr	tpidrro_el0, x3
 	msr	contextidr_el1, x4
-- 
2.24.0.rc0.303.g954a862665-goog

