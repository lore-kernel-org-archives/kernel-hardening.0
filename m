Return-Path: <SRS0=6/WW=4Q=lists.openwall.com=kernel-hardening-return-17994-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2ABC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3ACE52087F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JB82RZGV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ACE52087F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17994-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21670 invoked by uid 550); 28 Feb 2020 00:01:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21536 invoked from network); 28 Feb 2020 00:01:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t9NQOt5/Iwvu5cqFSUEIZpoioa79suNFyUPWf7TcFVs=;
        b=JB82RZGVMkxb7ufWndNbPMc9DLJBVuoLI8gqPesLGOqASB0Yq2fjodsUYxz9QdgrWT
         zM1/pGv08yc4l0mSk65GWRzDC7WMudixLLIWroLROrroJVCpBzp47d8Sil2XIYZfnkfS
         /bWmEwI9PFbsdfvUzibFyKLw6T0o6x8B66oMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t9NQOt5/Iwvu5cqFSUEIZpoioa79suNFyUPWf7TcFVs=;
        b=Ztqnxg24qil0PtpKnjE+wkhjEmz+m5VRMT3pEb3LwjUDWBO2CE6q3CoFBnsiERE6+i
         6K1Fz7KYmZbx5F3cDwdbwoDxX7nkyV3FHWl2Q/n/SKBR3sdBlCuZdEZGX25raWrFo1dd
         TDUKwoQiI5vG6OLAgtYip1A4LGRjXgcI89Dnluoi9oAO45GG8xS+ZnIb2VJfBUvGEWLB
         22En7g/HDysMp8PrtOCvaIBZlM9vRuTO/7sEHbV5I7XYKwAFMVDKB9W/gEUhxwXKka+K
         Q83n9J2bL/Ntwofx89qVCn4b4x9R31iNbyVQhKQA6xzdfSaRh71o3jiagwqqAHNjRWCS
         TPIg==
X-Gm-Message-State: APjAAAV/WkuOXhG2qedlHlLKBzaiZLyStAb8QByWYjCW/zAYTG5i6FMz
	WfYY6bokRGnLbxW4jNCii8TCxc4JRrM=
X-Google-Smtp-Source: APXvYqzNoR8mlRXvViWtEmB8PnTtW0UYVCLnvzxcFZTeurjSH9rB3lHogTj2OBxirQo1QrneXJkX9w==
X-Received: by 2002:a63:cf06:: with SMTP id j6mr1730502pgg.379.1582848075655;
        Thu, 27 Feb 2020 16:01:15 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Allison Randal <allison@lohutok.net>,
	Enrico Weigelt <info@metux.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 03/11] x86: relocate_kernel - Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:48 -0800
Message-Id: <20200228000105.165012-4-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only absolute references of symbols for the
kernel to be PIE compatible.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/relocate_kernel_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index ef3ba99068d3..c294339df5ef 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -206,7 +206,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movq	%rax, %cr3
 	lea	PAGE_SIZE(%r8), %rsp
 	call	swap_pages
-	movq	$virtual_mapped, %rax
+	movabsq	$virtual_mapped, %rax
 	pushq	%rax
 	ret
 SYM_CODE_END(identity_mapped)
-- 
2.25.1.481.gfbce0eb801-goog

