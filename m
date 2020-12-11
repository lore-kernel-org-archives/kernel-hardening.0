Return-Path: <SRS0=h+FL=FP=lists.openwall.com=kernel-hardening-return-20598-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28687C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5A39D23F5C
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 18:49:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A39D23F5C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20598-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11360 invoked by uid 550); 11 Dec 2020 18:47:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11275 invoked from network); 11 Dec 2020 18:47:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=aVrOLfHwyYehNryqhGtvwSuHF6d3RoXEKFD3yMxv9WQ=;
        b=crCjjtbF0LFHKaU166OM2hJGeHx2ZHgEPciM6YDUtvwCc0Wk4S0mHDEftwdDa0NcAd
         jVAeZYS/m2qVwB/wLayUO/zJ7OQ9GjKp3zIKQxrh85/izPBL52cGu+wOe5xhEuDbMihD
         jtqoSCSPAiWs1YHR/KQXLgIREQJzaCse6S5YKqzfvzE3xM9PHb8XFuHpON0Lx2wF5dvI
         jdDA/FurnwgxMiNVD8vMMoJgmDP/60Ko/cbUmNw+NN3ZiXIXUK+gSk6MdZLTk5pwRNWm
         GbcOKP0kdz3TCy88sneI6VUHEzRwj4dCnx7ptdr9FonuwDoHCGtCu9MNXQ48V8VaX9gP
         pMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aVrOLfHwyYehNryqhGtvwSuHF6d3RoXEKFD3yMxv9WQ=;
        b=W6DyYvXPq7fas1v4fEVTu/tyz+hSc9PJArislVGHMiy7KvLzmzHx2WT/sAFyQSn1Dn
         dp2YkaDBRAUjC1syKL5x7OKJOMIcL1u2T3MmRYlFXKtyz7s0wRNvRT9kXiwPuK47N4bX
         BrPXxBi6khtMjDdvMAAlZtROqNkTDqIFYKDhuZOZwQQr9HsMrtcLI3+ObghcsdjWXTfq
         zo94agi1PIHoYDCx/c0K3DLmDclReD6lB5NhMgBv3uFvp+MpE4OssT+z4+TEpXOADF//
         czDzZhFPZf/uvqZMxtcYllOXj28zvP1LfAiz0XvzrdT6p2jb2NazSSniioijvYfDrpMv
         JrOQ==
X-Gm-Message-State: AOAM533H2EZwccGw8/Vcrt3UeDlgjcE8d8U8nFcy5ydNI+7lU+2YsqUZ
	/6oPD70H8gD2FjoJwxcBa+oUxThliSYDHA0uhiQ=
X-Google-Smtp-Source: ABdhPJwNZuID1jcIf8cIxU0Ww5TlvyKdStjDCRvIBB9uhldEdK3D2TeNkVuM9PMADcBOExwezp45jHxla8E+Sk+8d04=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:9a48:: with SMTP id
 r8mr18569721ybo.294.1607712427760; Fri, 11 Dec 2020 10:47:07 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:33 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 16/16] arm64: allow LTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow CONFIG_LTO_CLANG to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cf7eaaa0fb2f..59abe44845f3 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -73,6 +73,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG if CPU_LITTLE_ENDIAN
+	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.29.2.576.ga3fc446d84-goog

