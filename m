Return-Path: <SRS0=zY64=YZ=lists.openwall.com=kernel-hardening-return-17239-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9052CA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F1DEB217D9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 22:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VqPASQjK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1DEB217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17239-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32344 invoked by uid 550); 1 Nov 2019 22:12:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32262 invoked from network); 1 Nov 2019 22:12:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lxookr95uMT9sOw8S1HRxQFBJ0wSUMPDNTYBScBbdzA=;
        b=VqPASQjKWMJdAAeJVcDeaVBQprxOwcKwHm7RWTEH9a4e15mPmrxMbW1NmgWy95nCCG
         gTOzFuhp1ly0goL38Kzph/3B6Z/grLfH43Q8d/pdkZ/OzdVRcdb/FYfbWEa2y3Z36z+b
         aTHaRyLhmFGkSCynkV7G0QI+cwcWnjK1qpx31PYhN1zT7bAET6McDo/Y5fThXHdO9Ek7
         zYHqR539+PQJrPPLRkOE7jflC+yHuXbTJUVLQrKHrysQdsbsiJzOBJ0HDbVrb0s28p6t
         kflfPrlWaRQdM1RMKSTS9mn+78aoixWKDx0joRXcRCUOTMxiomPR6k+4etm9NwgxSA31
         215g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lxookr95uMT9sOw8S1HRxQFBJ0wSUMPDNTYBScBbdzA=;
        b=qcaOLsp+95x9EoQWY+9K3fVzErDLKK9v9AI9j8JZW6bRb2WB7RIFvpDrFs5xxc5/RG
         CvW1n1DRmFLeeDQLYBEU+4JqibLDtPFxDiFsAJlPOYjPtk5LSg+D2P+dCgehakmI6yQT
         v3AN6N2ahGNulj/LWNe0/95J/703eLRRa+We+j4MPZIKYrGgvhRe1Yv5bH0kB8Qk3zys
         nZa4o1Tz7c7Hn36mSXfkKKWJqvri4Y1T6jwbcsyxi7ZsmrZERubF2IJdsjlragkDzVsv
         KRFzEjSWXIdq4CqZjJh5dmdTIm3BStTJf4hPo6/ygp2KfKJG2epE/9OXlz8S7p5t1OiA
         vvPA==
X-Gm-Message-State: APjAAAWy1EDC68E6emFJzN7/scrS9UaA7IQ+vDv/NWAgfSPJYA1LiR05
	uFhxCX+CxoiP5lkb1IpiRnE0KThJVxFPxhxiMFU=
X-Google-Smtp-Source: APXvYqy5WQVZIH4BmgA2vfXXE0nLc6aKF5v7DRRaYQ9YrQPB5qUQFSJiOmM2MmnfKMB9bJuYwXz6LVby2vjMPQ9mbfI=
X-Received: by 2002:a63:d306:: with SMTP id b6mr15679209pgg.338.1572646336234;
 Fri, 01 Nov 2019 15:12:16 -0700 (PDT)
Date: Fri,  1 Nov 2019 15:11:41 -0700
In-Reply-To: <20191101221150.116536-1-samitolvanen@google.com>
Message-Id: <20191101221150.116536-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191101221150.116536-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v4 08/17] kprobes: fix compilation without CONFIG_KRETPROBES
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
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
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.24.0.rc1.363.gb1bccd3e3d-goog

