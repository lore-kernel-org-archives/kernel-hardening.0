Return-Path: <SRS0=Zx3/=YL=lists.openwall.com=kernel-hardening-return-17031-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AAACA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DFB6A222BD
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NSG0XzUq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFB6A222BD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17031-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20245 invoked by uid 550); 18 Oct 2019 16:14:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10062 invoked from network); 18 Oct 2019 16:11:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fICIDxFYsM9a9Ff5jMCA2HNdKL4X15DyG8HPfHVUdX4=;
        b=NSG0XzUqxk2+63gPHHlONBw5Q4nS2y744Eo1rGIDmimGan5ZvchrFconEmIXiVv79S
         0SiQYCOcKQncsgO+OjD18O6E+2SSMSAk43T8F4SPII5CwYW5Z2DpjcXEvu90lABe0T7d
         54pDxZVczkH9+W6UKw5BGz/1SAtjmaCTeJP9IigFW7/8iSrzVXwx+vaItOIgEL2NFpn8
         PCwsy3taMFVH2Is9tZDbWuOIcT/YBmZIupi5pgO/dSJwAnrHQ+9LRhx/mZ3aQl1rS+Hn
         PYSAfr/54k98LWSAkxuS0/kkDyQ70rjvHFcfVRO0CwmtYXN/ED4JgjMIrSHGnZhfeFY/
         nwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fICIDxFYsM9a9Ff5jMCA2HNdKL4X15DyG8HPfHVUdX4=;
        b=OgdurX8tHWlBZj+SZDlairvVWaofteGoQf5yowWe+mpChJIx2XsXzh5iLLeOf2t2p6
         VgnQHwa/jKmfZDbSUfCnRY6b9OYaZBBhzAwCbg7vYcuEC9BW3mDRnFpJkg446ykdXuIE
         sq8n47gAX4fNQj+dEMDTLetf5R2xa+w/nMF9edUkIroYYAKyPm7B83teKdI+eC3K6Kns
         aRDqcYAKreT5jBIc/GJIH9/xE6u61GbkVzB22zdH9rD9uP6DVM8VxEokSaWaoP//70va
         EL7UFvyWhZPZYO6KV4V39pNiWf/yBCRBUNjTyogBlCVo1wjpVKTsC2SFilwAfTspJgdS
         Ywng==
X-Gm-Message-State: APjAAAX8uF0kRvITK5dLujIrtMne890JOicWEYj0LSudG7odGtfc4EG3
	QrFD26PSGsjNauqlmTcn+6BLkdOrxnNhpfMDcBw=
X-Google-Smtp-Source: APXvYqy2IPmHgVzSQFLWH/l27Qtv31FYTpjwXUbB8shECHuqpnU1nIwwQdz+u4oVI6rxTnp6d2Le2ZcdmFuior/slJo=
X-Received: by 2002:a65:6092:: with SMTP id t18mr11012516pgu.418.1571415077997;
 Fri, 18 Oct 2019 09:11:17 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:26 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 11/18] kprobes: disable kretprobes with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With CONFIG_KRETPROBES, function return addresses are modified to
redirect control flow to kretprobe_trampoline. This is incompatible with
return address protection.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index a222adda8130..4646e3b34925 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -171,7 +171,7 @@ config ARCH_USE_BUILTIN_BSWAP
 
 config KRETPROBES
 	def_bool y
-	depends on KPROBES && HAVE_KRETPROBES
+	depends on KPROBES && HAVE_KRETPROBES && ROP_PROTECTION_NONE
 
 config USER_RETURN_NOTIFIER
 	bool
-- 
2.23.0.866.gb869b98d4c-goog

