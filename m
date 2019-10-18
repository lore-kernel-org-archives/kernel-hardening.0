Return-Path: <SRS0=cD+h=YL=lists.openwall.com=kernel-hardening-return-17024-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B032CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:14:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C7DE721D7C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:14:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TZOVdcpB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7DE721D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17024-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15781 invoked by uid 550); 18 Oct 2019 16:14:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9814 invoked from network); 18 Oct 2019 16:11:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SzRVhVCQSEs4UpxvfljRvYSxQu5VFVx82TZExeQC7I8=;
        b=TZOVdcpBJiow5T4VOPKVfmYmovhUmd2ZBG9xflMRKW8S5BQ2L7yu5g6JY0/TCCHH+I
         XufZXerCCZfchS8x9jnvOoLMze/QWKGKm/0eGk215XJdEA1kME5jv8jnjb92Pb1eVWkw
         yiTgUjP8Rao1lkPZ3wsgn20YfPu5vdw09AcOGQOKuwSW35OqEXFlPzTQhP7pZvaCNMAW
         MWtaplAUSr+50SFN34KRGzFF9OlQtJcKYXSWZanQMwKs4H+DZ9A3MX4sVyK4cRYJFJ+w
         rlR21WxyyCXlD1Tc/Mn6bTnrGGsiH8nauEVx60lyfrl/C39gDgUhzHfYMSQ6uZ9ljLwO
         QH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SzRVhVCQSEs4UpxvfljRvYSxQu5VFVx82TZExeQC7I8=;
        b=rzKB3l7bnYK0ynOgWN9/BXyoFHOFoWreeS522Gm0bBbx7gTflx4pIzNcxQoLjIps1a
         Bc53Z9HJuyASaXTR+rDV+9tkc2FNUecpfgEirfvrbB1Vj9kEs0OZ/r6bJqY7GP7ZYPks
         ynjgykKdCYrNZfUWZZ7Xi7HjM9UZAhEUHIYz2lc0V85qR8dIFlwp06RTYfOEQkXf+5GI
         KxNZXtp2BgRvTryA6rawJazCpV6ZvcIvYSnBepqpqXVs7O6QExAgdP8bMFtPknBJrNKF
         z8Dw31aRzLqXE44p2PADAglvKcdaLvY8yMh9t0LgTuagH63IQ9/PxORaXEpLkm8N9QDl
         Pj5Q==
X-Gm-Message-State: APjAAAUAAmqBDKrCRhCG3ETnEgaQgSCrzWEF18H2Qd0cCEo1L8FAQuHJ
	E5APPtZTdAm5jNYwYr4AwAOlA7IVbvk5Q9ZtTeI=
X-Google-Smtp-Source: APXvYqymenYk+Nj4KHMBe+/txGcAk8emmf58ZAJAVtmISgexrXgZK+srN7qpXD3xJ732mL5rywUz419mv8CrbkTon24=
X-Received: by 2002:a65:68c2:: with SMTP id k2mr10843389pgt.241.1571415058696;
 Fri, 18 Oct 2019 09:10:58 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:19 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-5-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 04/18] arm64: kernel: avoid x18 as an arbitrary temp register
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The code in __cpu_soft_restart() uses x18 as an arbitrary temp register,
which will shortly be disallowed. So use x8 instead.

Link: https://patchwork.kernel.org/patch/9836877/
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/cpu-reset.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
index 6ea337d464c4..32c7bf858dd9 100644
--- a/arch/arm64/kernel/cpu-reset.S
+++ b/arch/arm64/kernel/cpu-reset.S
@@ -42,11 +42,11 @@ ENTRY(__cpu_soft_restart)
 	mov	x0, #HVC_SOFT_RESTART
 	hvc	#0				// no return
 
-1:	mov	x18, x1				// entry
+1:	mov	x8, x1				// entry
 	mov	x0, x2				// arg0
 	mov	x1, x3				// arg1
 	mov	x2, x4				// arg2
-	br	x18
+	br	x8
 ENDPROC(__cpu_soft_restart)
 
 .popsection
-- 
2.23.0.866.gb869b98d4c-goog

