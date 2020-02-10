Return-Path: <SRS0=cPIe=36=lists.openwall.com=kernel-hardening-return-17764-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CD1C35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14E4B20661
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 19:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mqEHj3cJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14E4B20661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17764-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12088 invoked by uid 550); 10 Feb 2020 19:31:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11983 invoked from network); 10 Feb 2020 19:31:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hedv3uQpLYtG/8d40iSwsTwWwbRFJKr8vrN4ZiDg04Q=;
        b=mqEHj3cJctfFXlmy16cRdbd3ZRwBg+PBoqBPYVmqQH/qHbN5NUcjIYDQxGJmRKQ7wa
         Gh/oTcwv3s+WJTQGeN5oXvRGmYE52sD2Oy62uw9zNjtHK9oLi+CKMUz2V13jB1bNCceN
         HKebkK1prPWHrTSh29Rcs3l4gWJQcq2tOzhxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hedv3uQpLYtG/8d40iSwsTwWwbRFJKr8vrN4ZiDg04Q=;
        b=NuBv9/hkGLTThOtpp2KdeY1Moh/4UrQL++mhW1QepEIKN7q00aVW+0NkCUWLRIRzEw
         a++Kp2MCFUtjmQjm3ZN8yzu7ehnz8V0qTgWB194nB5R/5Fg23pOSiLXRNcJSZWhstOI9
         KUAZonIzNxQqMnK2PAJv6gk5ufp561WIHjP14a89eD88eOC9Gbd+LCLny5Nk5/wRLarw
         12dG2vprX5U8vs++FrG+dyBfS7wax6EIDX29WpiV76AKvQsLvbOMH6PjIgnM9kiH3iW6
         +ikDZlP5F/v5B6WR7a4wotWsvxiq8cBAqqwMsWo02BykMUhQ9ZDWNAhsapq2cxNAtUJD
         Oe5w==
X-Gm-Message-State: APjAAAVmUh9O3kJ+HFHjsfUhnnZ4bV422LD/SNGfYuwK09+3Xl0goj4A
	7L4GZNcxwR2P/0DcuS2N7hPrgQ==
X-Google-Smtp-Source: APXvYqxzrrMjKkyUG9U1mzxeIF/mXf4CdliJjd23xPg8Q25YEpKS/E/iAhQV5XTWVKedZ6gqCTRpxg==
X-Received: by 2002:aca:be57:: with SMTP id o84mr419172oif.138.1581363061318;
        Mon, 10 Feb 2020 11:31:01 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>,
	x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 3/7] x86/elf: Disable automatic READ_IMPLIES_EXEC for 64-bit address spaces
Date: Mon, 10 Feb 2020 11:30:45 -0800
Message-Id: <20200210193049.64362-4-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200210193049.64362-1-keescook@chromium.org>
References: <20200210193049.64362-1-keescook@chromium.org>
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
---
 arch/x86/include/asm/elf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index a7035065377c..c9b7be0bcad3 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -287,7 +287,7 @@ extern u32 elf_hwcap2;
  *              CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  * ELF:              |            |                  |                |
  * -------------------------------|------------------|----------------|
- * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
+ * missing GNU_STACK | exec-all   | exec-all         | exec-none      |
  * GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
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

