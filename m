Return-Path: <SRS0=Y8Sh=5M=lists.openwall.com=kernel-hardening-return-18248-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41884C43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:48:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 934DF20716
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 06:48:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QNhpPzdq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 934DF20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18248-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26189 invoked by uid 550); 27 Mar 2020 06:48:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26155 invoked from network); 27 Mar 2020 06:48:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpYBuJfY08WhjaxaukJkaddMj0LXmdHxotG0jM4ptqg=;
        b=QNhpPzdqJpCei279jTF+h/ObhmvlR6FTP7G9SeLHFQQYYYl/hOo7K7A4ahYZW9rBTi
         CxTyqKu7s/VDnh0YhGgfs7LNY7Bn+lOco0Y3SE1ZH7MyzXiWqcevIJXEgNfXB9RcIubp
         WtzpdKV9R1aShxwRNBzHJ6OLnP2DSIhS0HLyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpYBuJfY08WhjaxaukJkaddMj0LXmdHxotG0jM4ptqg=;
        b=EMXDQ6tzt9/t8/Zun3CARSYjZmkQ30AhYFVov1bzxCkyc006f1i5VjxCXIVKWv69mE
         DR2nV9MopXCQcG8x2jqbXtT4eX75cyJVIG4v3BRdlDNWTNSFxQxn7Ty9C24EVGnFzqTv
         D4ALQc/lWWFwV350Z1kLB+HXcXv1o5jtajO+QPV1i3Ea4UgemAy6RYdL3Nb3y8uNi4jo
         +yoxAi7I2eIuXu22/xCOi9DXoERd/QJoTB/mo5emTExP121Orb17iSnJiytBtglbSAGs
         pFx0bylUhP3e2MDg+KRfkQZfGvYZecBmx3oQOGXGlRFRSpK7jnRLtOWUdl3SEcgzbbIk
         /hyA==
X-Gm-Message-State: ANhLgQ3NYqgU2ZSRSZfI4Zvv2xL3bMnKjQtIok11MlL9SIH4K5QaIWXb
	8fjIl5raA1NoOIfp0IpzEp1dxw==
X-Google-Smtp-Source: ADFU+vsCyDBR9n7viFoDu0Ekx+5WslhiT7XTciFmLxv2z4EAe6/t7zwz9Rj+ofshsa0IFDSE5S7sOw==
X-Received: by 2002:a62:75d0:: with SMTP id q199mr13127618pfc.72.1585291704670;
        Thu, 26 Mar 2020 23:48:24 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/6] x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
Date: Thu, 26 Mar 2020 23:48:17 -0700
Message-Id: <20200327064820.12602-4-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327064820.12602-1-keescook@chromium.org>
References: <20200327064820.12602-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With modern x86 64-bit environments, there should never be a need for
automatic READ_IMPLIES_EXEC, as the architecture is intended to always
be execute-bit aware (as in, the default memory protection should be NX
unless a region explicitly requests to be executable).

There were very old x86_64 systems that lacked the NX bit, but for those,
the NX bit is, obviously, unenforceable, so these changes should have
no impact on them.

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 arch/x86/include/asm/elf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 397a1c74433e..452beed7892b 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -287,7 +287,7 @@ extern u32 elf_hwcap2;
  *                 CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  * ELF:                 |            |                  |                |
  * ---------------------|------------|------------------|----------------|
- * missing PT_GNU_STACK | exec-all   | exec-all         | exec-all       |
+ * missing PT_GNU_STACK | exec-all   | exec-all         | exec-none      |
  * PT_GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  * PT_GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
  *
@@ -303,7 +303,7 @@ extern u32 elf_hwcap2;
  *
  */
 #define elf_read_implies_exec(ex, executable_stack)	\
-	(executable_stack == EXSTACK_DEFAULT)
+	(mmap_is_ia32() && executable_stack == EXSTACK_DEFAULT)
 
 struct task_struct;
 
-- 
2.20.1

