Return-Path: <SRS0=7KVw=YY=lists.openwall.com=kernel-hardening-return-17193-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B60CA9ECB
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:00:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 01AF0208C0
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 17:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ghjlrkb1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01AF0208C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17193-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30623 invoked by uid 550); 31 Oct 2019 16:59:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15408 invoked from network); 31 Oct 2019 16:47:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ut7YUpLvWAiZLonPATqZ5OL9tOEZJcNF7+tDsNdHEWU=;
        b=Ghjlrkb1pnfNur1PCuCrGu3KmSL84JUhV/VRyXQlGUkgpAsmk5kMXvp57Mk7EYOtSq
         L/8VDDHfXZ3KUDC1xcym7naR9TXkHtFoyXvddQwvFISLnm28nEJXtrhVKjiDWc99o+wm
         bIXKaCoHuKC2xbc2hbdVG9x55NXltyby/oVTLxiYMqg5L3AXj+Jse9QRq7ocqCtz8Woo
         EwpS6ecvA2GO0JpKJUVbqL7jZeQw+99QXy+fwi9BAQMGs5rPs+dkXDB42GUWcoOq+vfR
         K9Q0cwMWNIBZXS43c69SS1vt9YQQD9Wr2zCStwQNshudap8C/A8PTXXPpqKAD3KVELa9
         kr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ut7YUpLvWAiZLonPATqZ5OL9tOEZJcNF7+tDsNdHEWU=;
        b=HQovgh4CxhNOyiiJgWQ35klfCD4geZ0aCyUa3GyHyMth0INaJOR8w3f2g/ea81aPA7
         f3FWyMQoh+oO/UD3qMloE4qkZ2qk8l8fjGs+QqVCsV4gEdMiKJg8NAMLwAgFiiaCa93M
         CZ2u3nKuHeC+Df1sCQYK9YYlZ22fiUuNCO183BGKF004BW/3UjVh1AUluq6wcxI1SfeL
         zUxt7F7FbSzjKRJA0TTtfZ+ZaDwjfSL2n8KzySRVJLv0EQLghnMIWKOySJcpeF7DoGbj
         fl3mpXJZ/aDPB0NdaRLKpeIiPuNBn3fVrPaJ69QCgRukgTd60PDRaoEQxJVkYKY0xc3K
         LOHw==
X-Gm-Message-State: APjAAAWDS1e86kR3N03zwNqq7ahBDG/Q20NzisVyDSK7Zr3HUWriuXQn
	1vH+MjHEBkn4vQPjRHDumnaOkDqLV/7iuM93JB8=
X-Google-Smtp-Source: APXvYqymaacyz4eRHwtAvxRw6d3+sUW8PqKg+fCQUsJPaPuhQFDN545Kov10eZWMR0T+MDCojgj91Rt4gt/RgGRC9ik=
X-Received: by 2002:a63:151:: with SMTP id 78mr7160557pgb.95.1572540425150;
 Thu, 31 Oct 2019 09:47:05 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:28 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 08/17] kprobes: fix compilation without CONFIG_KRETPROBES
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

kprobe_on_func_entry and arch_kprobe_on_func_entry need to be available
even if CONFIG_KRETPROBES is not selected.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/kprobes.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 53534aa258a6..b5e20a4669b8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1829,6 +1829,25 @@ unsigned long __weak arch_deref_entry_point(void *entry)
 	return (unsigned long)entry;
 }
 
+bool __weak arch_kprobe_on_func_entry(unsigned long offset)
+{
+	return !offset;
+}
+
+bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
+{
+	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
+
+	if (IS_ERR(kp_addr))
+		return false;
+
+	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
+						!arch_kprobe_on_func_entry(offset))
+		return false;
+
+	return true;
+}
+
 #ifdef CONFIG_KRETPROBES
 /*
  * This kprobe pre_handler is registered with every kretprobe. When probe
@@ -1885,25 +1904,6 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(pre_handler_kretprobe);
 
-bool __weak arch_kprobe_on_func_entry(unsigned long offset)
-{
-	return !offset;
-}
-
-bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
-{
-	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
-
-	if (IS_ERR(kp_addr))
-		return false;
-
-	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
-						!arch_kprobe_on_func_entry(offset))
-		return false;
-
-	return true;
-}
-
 int register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
-- 
2.24.0.rc0.303.g954a862665-goog

