Return-Path: <SRS0=hPlm=C3=lists.openwall.com=kernel-hardening-return-19919-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-25.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79525C43465
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F1822311C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 20:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kS9nJccC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F1822311C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19919-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13675 invoked by uid 550); 18 Sep 2020 20:14:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13575 invoked from network); 18 Sep 2020 20:14:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QG37uO1d4USzrK2i79mol19BZHF3voEs5YXCH0vFDXg=;
        b=kS9nJccCRITkbrAyCK9Hc7v1LETkgjrZzbCI78fOJk9GspwsE0lD6AsMWWG9e/Ya6w
         kQ7OAgO+NsJbiNEURN/xqwJc+nMm2JlmzicPoqTkbkTgYLChVmHJmFrbVcTMgiIM1LfM
         AMIn2fwD4sdTg9b5RFBa3v7hPzAOv72tQhHG2zedzbaGOgS5AllQnoGhiut1jy6gfUPb
         IHOl5kVpEYZmlx3J300NFEalCTngIq2wdGL7A0LMMidJtwteLyUB84t3JQdj/BGr11/r
         XP03Hd7VXorIrHoqHnVpAgFdqejQhRQlU/QiTZkkxeCP6z2bKBR11111wx5Cdsjef2hw
         h1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QG37uO1d4USzrK2i79mol19BZHF3voEs5YXCH0vFDXg=;
        b=IUrrE+G3kdvK94c4E+l2bKzDZqKDsSZOvMvxu0f8+0bpkmrnsHGULKfwM0TuUN+Y/G
         cJJaj7fCHB/pXx+yBx0wfAGYWHWD+L4hvnbhB+QDufnYw1vkdBqD4mVXXGG5M7npRROQ
         878bMNz14MRzeWjO7k+zYUinVfB1YK4pZp0BEqTtM5ZAQ0UWRb8uIgFMW2GibQgFfPow
         Hetckyy7ygCXYB5A2vmV7z1FRrUw3d93ZITxYZm/ZIz58H+BB95rpVx7yrk+8CmN0RCl
         XIS9uOdQhT61lMiAZK+WzfLK5Z0PrF4lv5vyJIm9uJBOWLdK9LvQ4R493f3Rs9n9huO+
         fv+g==
X-Gm-Message-State: AOAM532xVPHUmcW5igc3vWwKRQHMY6xLbWwsGVzt0P1pRCayrip2HEl0
	wh3cyY9SIXw0fs/XuNFjw1Qz7LisInwfT2BCJy4=
X-Google-Smtp-Source: ABdhPJxOIBe5IUGDSTHVDRZfdndNloI1irNa0De5LGLJBg+ujXNg2cTfcMKCeIjDmjymnjpy+o5CvxVSn10XK63j+fc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:3744:: with SMTP id
 e65mr19951166yba.275.1600460085079; Fri, 18 Sep 2020 13:14:45 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:09 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 03/30] x86/boot/compressed: Disable relocation relaxation
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Arvind Sankar <nivedita@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"

From: Arvind Sankar <nivedita@alum.mit.edu>

The x86-64 psABI [0] specifies special relocation types
(R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
can take advantage of for optimization (relaxation) at link time. This
is supported by LLD and binutils versions 2.26 onwards.

The compressed kernel is position-independent code, however, when using
LLD or binutils versions before 2.27, it must be linked without the -pie
option. In this case, the linker may optimize certain instructions into
a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.

This potential issue has been present with LLD and binutils-2.26 for a
long time, but it has never manifested itself before now:
- LLD and binutils-2.26 only relax
	movq	foo@GOTPCREL(%rip), %reg
  to
	leaq	foo(%rip), %reg
  which is still position-independent, rather than
	mov	$foo, %reg
  which is permitted by the psABI when -pie is not enabled.
- gcc happens to only generate GOTPCREL relocations on mov instructions.
- clang does generate GOTPCREL relocations on non-mov instructions, but
  when building the compressed kernel, it uses its integrated assembler
  (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
  which has so far defaulted to not generating the GOTPCRELX
  relocations.

Nick Desaulniers reports [1,2]:
  A recent change [3] to a default value of configuration variable
  (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
  integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
  relocations. LLD will relax instructions with these relocations based
  on whether the image is being linked as position independent or not.
  When not, then LLD will relax these instructions to use absolute
  addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
  Clang and linked with LLD to fail to boot.

Patch series [4] is a solution to allow the compressed kernel to be
linked with -pie unconditionally, but even if merged is unlikely to be
backported. As a simple solution that can be applied to stable as well,
prevent the assembler from generating the relaxed relocation types using
the -mrelax-relocations=no option. For ease of backporting, do this
unconditionally.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
[1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
[2] https://github.com/ClangBuiltLinux/linux/issues/1121
[3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
[4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/

Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
---
 arch/x86/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 3962f592633d..ff7894f39e0e 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
 KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS += -D__DISABLE_EXPORTS
+# Disable relocation relaxation in case the link is not PIE.
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
 GCOV_PROFILE := n
-- 
2.28.0.681.g6f77f65b4e-goog

