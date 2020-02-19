Return-Path: <SRS0=AaaK=4H=lists.openwall.com=kernel-hardening-return-17838-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E366CC34031
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:10:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3EE3F22B48
	for <kernel-hardening@archiver.kernel.org>; Wed, 19 Feb 2020 00:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ExdFaXJL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EE3F22B48
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17838-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1965 invoked by uid 550); 19 Feb 2020 00:09:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1882 invoked from network); 19 Feb 2020 00:09:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ou3AmoAB4pAV4E8hHdrZJU8tYRoLaJy68OnSkjNriPk=;
        b=ExdFaXJLQUrLqD1cXdvV6V+f2pvG4gneydCqd14okgp/Waqa0Qii99gHccZPxv5u7T
         ful3UrQEJD0mlccXRaOv9ncjUpURLfgt1M2GftTdPAksHrqi4oP/mH8JmpSYvfwHIm7J
         e3+kj63xZtRB4dCYxQwR6HNmc35LUxGimjg5k2n2O8xxH439zv2/XtncK8lwRfMu5R+O
         u4llohrY6SlfXI9mRKQ2oYKubkIkauF/gn83zq1xPCFdbiaSThaYvjtA6Lb7Zay9qZ6q
         H8vw2D8eYgjNx+t+KvfMrj5S0vZf+h5Qmzl6mlBhwILCDL8Jf2+qBwxQma4EGN9GtIZX
         bJrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ou3AmoAB4pAV4E8hHdrZJU8tYRoLaJy68OnSkjNriPk=;
        b=pw1niWOaFBUWcoZuLdtcZeY2HEUbzDbRFRgHQqgUyAialWDLhe3dyGmNT8puFpvtw0
         bQRs6cUC5UTlTn94NCvI6IPn9hZvfljAj6947tK9+J/Kj0h09TuMCe2Q3eND6Iy1SRhw
         BhHcD54Ok4b+VZPvk6WBSIyygrWnTm9nqDUbzB8s9B1KP50M9GgeEAjcGpQnzxmCXBHY
         G/TPZfcYe9NmYE9/wFB9Ug2Vl8pOhwD7l4IBNLtqDXKJ6wpHavxbHPZwlkhV20QxeMw/
         r7gFHt5xEkAm7YpJxyljG4K3xi2p4mDk0V3aRZE28x5p+e0098e5POjHcUZv/dfRPCl+
         +Cyg==
X-Gm-Message-State: APjAAAUdiw6EcCn426sOPXi8hn8qiLl8eL2pWgkMxYyeGhPNpDTOo/B3
	VyfBr36tlPpUQiFOnVYCsBGulNwQ4kq2/7ic30s=
X-Google-Smtp-Source: APXvYqwONz8h4AimAH0TTKyO3Bm5Hq6D70pRhoeCO2SJP39ItHHxl//O2KOBNiMiAvvC4x9LMa3MQfSB9GUboiWhKfY=
X-Received: by 2002:a63:30c2:: with SMTP id w185mr26462644pgw.307.1582070943849;
 Tue, 18 Feb 2020 16:09:03 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:17 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 12/12] efi/libstub: disable SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable SCS for the EFI stub and allow x18 to be used.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 98a81576213d..dff9fa5a3f1c 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -30,6 +30,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-stack-protector) \
 				   -D__DISABLE_EXPORTS
 
+#  remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out -ffixed-x18 $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.25.0.265.gbab2e86ba0-goog

