Return-Path: <SRS0=1JwB=C3=lists.openwall.com=kernel-hardening-return-19938-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222ACC43465
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FE5320684
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UfHLbm8n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FE5320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19938-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23557 invoked by uid 550); 18 Sep 2020 20:15:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22414 invoked from network); 18 Sep 2020 20:15:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=X2rJBbb/dAb+yfnrEjkjEFh1Qlc3T9c6r5OVY+2F28Q=;
        b=UfHLbm8nbc7nF4Jo2yUgHO34FEnYwaE+D6WpRyYM9fua/f1c+fZ8kF6HsVdGT3ZStz
         DIioQeeYjH1vQBjYBq6RWn1tj8Ze0d8QdJv/5ZoCfD/OJopHg281EA0NzxBu0bnxaWZh
         gx+JUnvc4+vXR4wjKioKlFelZxpe0ui4Lh1MT956XxN4Ky84dI7eVbp7usD/4ORebyXi
         CldVhYDtXNAYA4NGIwtBdJpXhE9cy2RjWHBM1Uc8TjKab8xO1nXAuOuk6CkQAwAWw4AW
         +5M/W/XGQlX5ApQtgCjOdjNKX53WnhGd309U+vDRlJPdbYtPQkUcz7FocAivoRqNyi4G
         Nh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X2rJBbb/dAb+yfnrEjkjEFh1Qlc3T9c6r5OVY+2F28Q=;
        b=A6akzRPDx1PdBGvNd2v7JECwS+BPAPVaIajfNpCDA1WE/cqOGwiWGSQAQlEv7KOKkL
         daK52nFZGDzmcr84HqnIejjKR6zbgUtBLSOwL4HZaA0g1i27sj2svflOqlb8XhFURZjV
         SH80qIZ1ZokXv3v217WEdFCoVLHduKrTyG9ynRKRSrGHPhXpAj1NyPRyATA5EmkEF1w4
         ENfTz8eVonGGCHQOoxx/0KJ/EmseFJ/V17K6QlWTMWREVMWocTJ2y7FfMi93MGOJ8UTU
         /b1gbTLR3TzrWTeyFcmtdi/R+B9n/myR825v4JXMZk0y2ogqA1t3eEZbvjrWppb0PT/c
         xyVg==
X-Gm-Message-State: AOAM530bh5MvTCKgISn5LNArSDya8cCv5/4ensY5zzHx9ueD+X9PMtSs
	e0hnMQP6BLeajIsZ/86Nr/hpH37JLyZkq0oANMQ=
X-Google-Smtp-Source: ABdhPJzo4LTM6y/+DCzOvBKNO4aVvzGwT/r1d/eIrsPqlXmeiMn37vjIcaP3n6Xyzc5vYh3xJFK8sACdwTT13Li7Iew=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:5a0e:: with SMTP id
 ei14mr20725499qvb.15.1600460131755; Fri, 18 Sep 2020 13:15:31 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:28 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-23-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 22/30] efi/libstub: disable LTO
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

With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
files. Since LTO is not really needed here and the Makefile assumes we
produce an object file, disable LTO for libstub.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 296b18fbd7a2..0ea5aa52c7fa 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -35,6 +35,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+# disable LTO
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 
 GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
-- 
2.28.0.681.g6f77f65b4e-goog

