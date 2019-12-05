Return-Path: <SRS0=CH8W=Z3=lists.openwall.com=kernel-hardening-return-17458-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2755C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4D08E20674
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FDTctH2C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D08E20674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17458-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27935 invoked by uid 550); 5 Dec 2019 00:10:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27821 invoked from network); 5 Dec 2019 00:10:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AI0Sbf2qfvdip7zDaIMGaj7cN/UAI4vRqAvCejejut0=;
        b=FDTctH2CeJShcdMHsHl2Oi7MHODy229XFf1dMS36U2X/QdXpsbAtsCUC75G8Tt4iZ/
         wFsIWH/tIi6YoU802WLaDkHZFr84ABsj1X/04mTK+cDldigsFFAdsf9RjxmBi1w9DMRf
         Y3eRIoUILPqZg0xNze2z+SLJZaY99XtfVjbec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AI0Sbf2qfvdip7zDaIMGaj7cN/UAI4vRqAvCejejut0=;
        b=L7BBay87hWNu7BpVDN7k4AzLyacZaAcM1AA6dPTVPUzN4UVvQimUjUeGJ3BxHQGdfh
         EyEkjjUw5oYnQbuYlFQ0rovKbp935DxuZjMzq9qkHOBqR1M7ubwRdcv3eMmUPrX19qEU
         mEeIZ0L8yLk0Q95DALvprV/yXgPJUQBGg1TxGL+makrktrScF/li+GqAMBjkNz8SXsum
         f7myLFMWNbHCMoAqV7GFPS2MDuK7LEU1xrANdPmmfna2c9hvfgdy55lPWp5H/KNuHvX0
         j1orNlZU6WavbafOt8aA21cxCI55pau6ARim/xJTywsjEfV1Yn7DFcQP+4Wyj29+QNFH
         2DGQ==
X-Gm-Message-State: APjAAAWtm1pTkN6exSOh15/qerN9ERagVQlzuNwTOfrHU/dX0fTfty9/
	GPlwPT+BItaGufB4/YZdfKbg2q3QaCw=
X-Google-Smtp-Source: APXvYqyoUG5RvODwUDikHFr0GME5meRLVDUYTKsj6+bCgJ3vbygvGSX80K/1+YC5RDXowxCFuo8yEw==
X-Received: by 2002:a17:90a:a612:: with SMTP id c18mr6163516pjq.49.1575504614402;
        Wed, 04 Dec 2019 16:10:14 -0800 (PST)
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Allison Randal <allison@lohutok.net>,
	Alexios Zavras <alexios.zavras@intel.com>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 03/11] x86: relocate_kernel - Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:40 -0800
Message-Id: <20191205000957.112719-4-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only absolute references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

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
2.24.0.393.g34dc348eaf-goog

