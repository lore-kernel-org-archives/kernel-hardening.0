Return-Path: <SRS0=yPdh=IH=lists.openwall.com=kernel-hardening-return-20896-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B937C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6A34064FC6
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A34064FC6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20896-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15999 invoked by uid 550); 9 Mar 2021 21:43:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15862 invoked from network); 9 Mar 2021 21:43:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=fXCfvnU3D4wVS2gnx4R+6sEkANTA5C4Qx8s+R2Snvl4CfYrjd711MJmnMdXeC6GL/I
         PCoEcCoP0iSQ5ydymCVNPBPt0drSoZzLLX1BF0oLBizNtnX90NKPXVxlmNQlaA8fAIoj
         ryM7dBfe4KsBcn46bv7w6H7Idv2DnikOzytCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=RH+sbHSco+VYVbnecBFBJdfCd/G8rs9sxVX310gQNm2rTw4qHia+fTxbQ5xhV9Ykeu
         n0EjqQlFjuLM9qzbiJ0LYKbwAdyToCWYtKpqiwyz0DOI6OOHgTyiKbUpbnzASOy518hX
         Ip9epu0WinueXQqiWNXUkTqGCz/mzotE6IYs3MuTbRjMqO0oRIGK/8uqGzKbxe3azoVw
         MpCFLdTawLHx4ipXIaN0AIT0VghHSjZ9+DY/gzNJ206CeqOqOWxMNzM8pVhvxaZqGYHD
         gTbbG8PzSbNFCNZJVSNeIY0DeWKxo/zkYrRlTeaxk7VRrbqZN3qnJRFReN2qaBJE4QYP
         oWZw==
X-Gm-Message-State: AOAM530uDP6L1HvcbAtRnzo/WF+YfLWTnwxWlG2gLihwtuawQ9uQxuZS
	2XaB+2wA3TXS8bP4Vyz+rFoh+w==
X-Google-Smtp-Source: ABdhPJwMAeJop9UPtI3jZOkzjoT12RbrdsqpFgJGTkl99HdMDta1V57qg5ZxtpfVe+IAGkz4ensuyA==
X-Received: by 2002:a17:902:6ac1:b029:e3:dbc0:bc44 with SMTP id i1-20020a1709026ac1b02900e3dbc0bc44mr27861641plt.15.1615326193986;
        Tue, 09 Mar 2021 13:43:13 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 7/7] lkdtm: Add REPORT_STACK for checking stack offsets
Date: Tue,  9 Mar 2021 13:43:01 -0800
Message-Id: <20210309214301.678739-8-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309214301.678739-1-keescook@chromium.org>
References: <20210309214301.678739-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=fb815901a1ccc1d9c4ca5c3e3cd3729b7f382fe2; i=b69wRsxT78r/3tM1mGa7N6ME6+rlXyFg15giRWRwPAQ=; m=aFqgiEE+nAZdug79A1F+fVTg9ZceUb0WPE8cbHqssVg=; p=ZQ32/kILkW5AD3nBZHO0VMTp4prIPkm7+DdhCHX8KdA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBH6+QACgkQiXL039xtwCY9qhAAhOW Jji3ZCJ3RnoaGRrD0g0EhW5yFisz4YxnlNFMM7jo9oEkkaEIg5Cms4k2RvZrJ99lKsWQwbBhzNuM+ rCDNkeT8iaL2KUsW7Wo7+6szheXR5qMdUTHKKX/nOd1uPS8zHdnMNBkOts94EJQ/Zi4WoE4M380XF 47N+kZ8mPuzp9vyHEVUuPre4Dc7Tqmg2bzpBi8tjTrZBVBXul/7Plp2Wbry/KX3lrUl/vq3VaNypY MhHZhQnufm5Nkx93kwAL/aB7zoIZppUx8G4GrqzgT8InUwgfWD/KaX6atmi0FiMIzyFRKfANnk/rG gm0DClhml0R0e5xMPFHy/aDTZxyjkarc66p/PSUfKCRWOfQ9mOA6HxIcpO8phsZ176kf1Ge+nrt0D vT+mGYXOznFNK8yNioU8/h3F6A/IUtFoK0BN1KTG5azbjperev/mix3MNVLHWQn64+OmoknnIZKKf boW/jcOs+FV/7/e11Atvz5H2BQyEer7KZmWnyoc+WZi//J69k8JN11FgMyMttnfU8h5qT3YzzT4F0 sEpmlrNFTfMHnL42Lq2rKO2uVjXqqzti1VNVAPVtpBgNCWdzhlBvF4VC+Y28uivtgwCovRhH4lKaO EcmyX88q25Tn95RBx7Y7EcFqRvubjTsJTcq3Dw9W08iqQrjt+/8Lnfz7XVUtGeJQ=
Content-Transfer-Encoding: 8bit

For validating the stack offset behavior, report the offset from a given
process's first seen stack address. A quick way to measure the entropy:

for i in $(seq 1 1000); do
	echo "REPORT_STACK" >/sys/kernel/debug/provoke-crash/DIRECT
done
offsets=$(dmesg | grep 'Stack offset' | cut -d: -f3 | sort | uniq -c | sort -n | wc -l)
echo "$(uname -m) bits of stack entropy: $(echo "obase=2; $offsets" | bc | wc -L)"

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c  | 17 +++++++++++++++++
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 110f5a8538e9..0e8254d0cf0b 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -134,6 +134,23 @@ noinline void lkdtm_CORRUPT_STACK_STRONG(void)
 	__lkdtm_CORRUPT_STACK((void *)&data);
 }
 
+static pid_t stack_pid;
+static unsigned long stack_addr;
+
+void lkdtm_REPORT_STACK(void)
+{
+	volatile uintptr_t magic;
+	pid_t pid = task_pid_nr(current);
+
+	if (pid != stack_pid) {
+		pr_info("Starting stack offset tracking for pid %d\n", pid);
+		stack_pid = pid;
+		stack_addr = (uintptr_t)&magic;
+	}
+
+	pr_info("Stack offset: %d\n", (int)(stack_addr - (uintptr_t)&magic));
+}
+
 void lkdtm_UNALIGNED_LOAD_STORE_WRITE(void)
 {
 	static u8 data[5] __attribute__((aligned(4))) = {1, 2, 3, 4, 5};
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index b2aff4d87c01..8024b6a5cc7f 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -110,6 +110,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(EXHAUST_STACK),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(CORRUPT_STACK_STRONG),
+	CRASHTYPE(REPORT_STACK),
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 5ae48c64df24..99f90d3e5e9c 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -17,6 +17,7 @@ void lkdtm_LOOP(void);
 void lkdtm_EXHAUST_STACK(void);
 void lkdtm_CORRUPT_STACK(void);
 void lkdtm_CORRUPT_STACK_STRONG(void);
+void lkdtm_REPORT_STACK(void);
 void lkdtm_UNALIGNED_LOAD_STORE_WRITE(void);
 void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
-- 
2.25.1

