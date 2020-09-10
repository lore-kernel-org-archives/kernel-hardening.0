Return-Path: <SRS0=bM64=CT=lists.openwall.com=kernel-hardening-return-19839-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBF1C43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 13:48:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7D10821D81
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 13:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WgG0SFGn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D10821D81
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19839-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1776 invoked by uid 550); 10 Sep 2020 13:48:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1744 invoked from network); 10 Sep 2020 13:48:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=CKC4riJvJK5v9Z9Ok50HMBgYPff3aChRh0QJLVpJjvg=;
        b=WgG0SFGnDfGbjr63kBibCRJ2m30nMFyLODKO7uNWW8B11XC1UwmPIs+QtSGJ9LWSsg
         9u74K8ShTi8lfKM8fOFrrE3iPMvEPHrLBNqAtSHRKL8hTEwoyHZSZV837a92ZZexxqyR
         DGBHW1zi/gx6uKdESbNPxmI3gIK+PrbZU483OVXEelYoY+UBrFa3gypGemNz1jC+7L4B
         osZ1fQVDztT3Z7ZbUlUHHmdprHw3yV3cWhSiSDcDwhf9wy4UHlPpMa0t0Y4SDteGyM8M
         Wsw1dGDSsoexSvilfwqdewaJXBRgiDyytB2ffdovKX7/xDlDk1RcSslRxR332JpOwrDs
         wLdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=CKC4riJvJK5v9Z9Ok50HMBgYPff3aChRh0QJLVpJjvg=;
        b=YIOGjP76A8uCRMsMSmOhH2O+OEeUD34UIEd9ubBvjmlPvGuIpjqDG7tm9BqqMGJnnm
         Sv3F5LRBhO0CDmVPwP9iTH3Q5dtx5P8LVL43kj2X+z4/mqOuD3yJ3GSFUrqXdFKDqHI+
         YxGU0YcSv0SzIxu41ipMPHgg/WL54qdkRdtFOEtqWSa/aTlhpS68MroRPL7qmEjaWktW
         6AT/YaLrFDhNu4Fclxs6Y7Y2H3p50ftmRiu2tarABMvXLuqOZrjjYJ0wixTuwwd0s/iz
         iBqsP1TnSojHH6ThS/iMHWLv7Z7ICEPuutaoKfE1Pyda+kOCC6OlLgQPSBAt8xmIZq1a
         jBKg==
X-Gm-Message-State: AOAM530cq0cbGB2/QNJuidgZJHuoGczDDyQGDR1kIKKCu/+BuMNfsjoi
	RvxxJOx5N8VAkThyxvAD+HOFMS5tLcP0ZkD5h+FQFOpBDM/i2/tjiO0q5aJZx1DwiMtIH+NSdz4
	UPMZBNVxd9hGEPuyj/z2Fu5K9t0S43Yef8QN0O3CqwtZkE2RpGZ5BcO5KIu7pj+jlQJikv7xkcK
	F5tZsDqQ==
X-Google-Smtp-Source: ABdhPJzXGzHqMjZogwlFUVQYV32E/MmMQjyUoqvNm+QW2oFEVjVBfHVxiQC+Yt6DXR0L9wrVPmfbdeimv9tD
Sender: "lenaptr via sendgmr" <lenaptr@lenaptr.lon.corp.google.com>
X-Received: from lenaptr.lon.corp.google.com ([2a00:79e0:d:210:f693:9fff:fef4:29c9])
 (user=lenaptr job=sendgmr) by 2002:a5d:44cc:: with SMTP id
 z12mr9413494wrr.189.1599745699562; Thu, 10 Sep 2020 06:48:19 -0700 (PDT)
Date: Thu, 10 Sep 2020 14:48:02 +0100
Message-Id: <20200910134802.3160311-1-lenaptr@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH] sched.h: drop in_ubsan field when UBSAN is in trap mode
From: Elena Petrova <lenaptr@google.com>
To: kernel-hardening@lists.openwall.com
Cc: Elena Petrova <lenaptr@google.com>, linux-kernel@vger.kernel.org, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

in_ubsan field of task_struct is only used in lib/ubsan.c, which in its
turn is used only `ifneq ($(CONFIG_UBSAN_TRAP),y)`.

Removing unnecessary field from a task_struct will help preserve the
ABI between vanilla and CONFIG_UBSAN_TRAP'ed kernels. In particular,
this will help enabling bounds sanitizer transparently for Android's
GKI.

Signed-off-by: Elena Petrova <lenaptr@google.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index afe01e232935..5c7b8dec236e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1008,7 +1008,7 @@ struct task_struct {
 	struct held_lock		held_locks[MAX_LOCK_DEPTH];
 #endif
 
-#ifdef CONFIG_UBSAN
+#if defined(CONFIG_UBSAN) && !defined(CONFIG_UBSAN_TRAP)
 	unsigned int			in_ubsan;
 #endif
 
-- 
2.28.0.526.ge36021eeef-goog

