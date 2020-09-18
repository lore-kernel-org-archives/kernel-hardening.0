Return-Path: <SRS0=nQN8=C3=lists.openwall.com=kernel-hardening-return-19943-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777F5C43463
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 95F5320684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:19:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qivt17C4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95F5320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19943-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25746 invoked by uid 550); 18 Sep 2020 20:15:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25669 invoked from network); 18 Sep 2020 20:15:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vY4wvL91lX+XoPJtjETBJ0Jod2fr7hSe9gEwviH1PQg=;
        b=qivt17C4c3k3DwY8yxkDax/XSYLbBnJNnBYPw2ZM9Gn/ZE0fIpcsHSVm+mQlhKjakH
         ACLHPBDSrN9QhIs+2oMundPSpouSZPRbj9HW414qGcxUL8RP/Qw81qBg3hFyQmOJVd70
         36vk+fW3SMvGQBxWNMXr5dCR/MCgbY301VpVmDNnr0VCgN2sZLUw+BrVWaduLhzw5SZv
         rv8S8puJ+RnceNDh0B4fMoiQfngBeVpOdbwRVQ/hhKlaWSqX5BsgHyNznIZZ8LnydZBh
         YrVXnwczP2gFi6vqoYxTjLvwOSb3+MWNcxlFSbiyja8iKC/0zZ8liDgrrBt8Hk4cr/64
         UQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vY4wvL91lX+XoPJtjETBJ0Jod2fr7hSe9gEwviH1PQg=;
        b=goLaVP/IQIkyiQ8KE5QzC6c+d0NpXw6SOCQ8FE5Gw703C1OFSdG/JOZ7agSK3XIET/
         7/R69SGM5dEicxNZBdlqkznlMdIboZTtOM9XYKU+u5PsUfLuqGxVg26kBVbURewVp7f9
         oKVgGvLYJAKw+Wjnz9hAchy2XokoTvoOhPGQXkPPhNMltEEYEY/FormMLDYQhKNayRZB
         A+AMFnNJgZMeqvgraGOFFlKt0+Yy70mjujRuJAnz/qlENL8gpZQwMN8EZJCyr2bh6U1K
         qa3yKqK6Tre/1KftHmN6QlblEndXsTTNb95bKVj/z9Er8Lk4UwKPvNLKKIqAH2flVIVI
         pcRg==
X-Gm-Message-State: AOAM530Uym7pl4PN5AjzobTGRfqQpqJeiK/CE4FrNv4ZeqHwk3w0eExx
	P+2tcWh9tFSb9O1YGQ15nBLtfzVqmlQ5b6dOgK8=
X-Google-Smtp-Source: ABdhPJxx/ZB+iAIYYGWthfZ5MCRw4ljJiAxyhQbM9fSoZJcW8J3//Xuvzi/v3xFDYUKOn6kD1n3mDEB16b4Qbpmiyyg=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:55ec:: with SMTP id
 bu12mr35584454qvb.0.1600460143930; Fri, 18 Sep 2020 13:15:43 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:33 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-28-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 27/30] arm64: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6d232837cbee..2699fc5d332e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -72,6 +72,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_THINLTO
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.28.0.681.g6f77f65b4e-goog

