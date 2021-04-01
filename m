Return-Path: <SRS0=US9k=I6=lists.openwall.com=kernel-hardening-return-21116-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E77C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 19:18:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77BE861001
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 19:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77BE861001
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21116-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20273 invoked by uid 550); 1 Apr 2021 19:18:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20250 invoked from network); 1 Apr 2021 19:18:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nlEty8FbrPXfEuiwzU9OVAHqfrb/3joIbwaJdu5fO44=;
        b=QSntTpECX8es2vOgpgsVQixFbafEesFafN4Bzaq4712xl6Lp68jJHZTkl1YI177619
         QEKerfpHXNaHIDUo4BJsh5aj285zB/9VcoH1lBKIIiJneIq2vX5upBnfgQa2X+IZK9bQ
         ut9PpEQaCNQgfDmNUQ3EygQyX0QErvgOBAFzNoPBbRSTXozlbZ0sWDOP9h7TMEPZP+MG
         3jehI4bc4N7gPWyM5smNvhfx0L6UfgJMoPMZY6Bo0dsmMTINhiqu/x3MTUinFMBJOqFH
         LfsNqz1HkMyLVX6nLomMGzSoWbqeTscnmuH0A6FqFsxK17PjTMojKJMZ4zdHseqE1krr
         6L8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nlEty8FbrPXfEuiwzU9OVAHqfrb/3joIbwaJdu5fO44=;
        b=OjSPRcqcPncV4Ay3VZ/oamgVjtvlZP2rUH5+kXTi6zS+UxN9GhngwVLrRBXStVUBBU
         dyz37/CxdHCMvIwJMvd7wtRaOnhZ1tQHB2vmhFhKM0VOmBYF0muSeqDLPT2dfCmYJ3yz
         w9yu7MSkPhlEE9RbFKJ5tObd2D32Xenw7THHpUzuFFrk6BAdyn2QNIEr7+I5KvQ4HBq2
         JrtfPDVqBM5b006In1pvqWUYbmbkv4RlJ82cypUqnEUcOo2NhzkLDFiQldN133MAjJdX
         DT3ZAmxHB4HaQKT0km2rssUKNdOhaEpTdgztlW0GgQQ1aA6WJYWCatLmkuPyGPDRrR3+
         M2Dg==
X-Gm-Message-State: AOAM532+Iyr6135n2tcZEDN2k7Nshd7j8rQrf00d0xyTo315EFXhuOrg
	MgDY4czJ/41P0DJcBRQ1ZpVMnz2F4Spi
X-Google-Smtp-Source: ABdhPJz+iVbbW+Al8L02mPKFb3osxiJwm1KiVsG7416KcEaTmWJ3FCuEaDnnEeHvkJrncERy0gmFN5EuygRJ
X-Received: from royyang.svl.corp.google.com ([2620:15c:2cd:202:a838:37b3:5242:e2c3])
 (user=royyang job=sendgmr) by 2002:a62:7c17:0:b029:1f1:9ef7:163a with SMTP id
 x23-20020a627c170000b02901f19ef7163amr8859557pfc.51.1617304669075; Thu, 01
 Apr 2021 12:17:49 -0700 (PDT)
Date: Thu,  1 Apr 2021 12:17:44 -0700
In-Reply-To: <20210330205750.428816-1-keescook@chromium.org>
Message-Id: <20210401191744.1685896-1-royyang@google.com>
Mime-Version: 1.0
References: <20210330205750.428816-1-keescook@chromium.org>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH] Where we are for this patch?
From: Roy Yang <royyang@google.com>
To: keescook@chromium.org
Cc: akpm@linux-foundation.org, alex.popov@linux.com, ard.biesheuvel@linaro.org, 
	catalin.marinas@arm.com, corbet@lwn.net, david@redhat.com, 
	elena.reshetova@intel.com, glider@google.com, jannh@google.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com, 
	peterz@infradead.org, rdunlap@infradead.org, rppt@linux.ibm.com, 
	tglx@linutronix.de, vbabka@suse.cz, will@kernel.org, x86@kernel.org, 
	Roy Yang <royyang@google.com>
Content-Type: text/plain; charset="UTF-8"

Both Android and Chrome OS really want this feature; For Container-Optimized OS, we have customers
interested in the defense too.

Thank you very much.

Change-Id: I1eb1b726007aa8f9c374b934cc1c690fb4924aa3
-- 
2.31.0.208.g409f899ff0-goog

