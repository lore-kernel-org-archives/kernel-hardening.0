Return-Path: <SRS0=nbm/=IR=lists.openwall.com=kernel-hardening-return-21010-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB02C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:30:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5554760232
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:30:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5554760232
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21010-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16358 invoked by uid 550); 19 Mar 2021 21:28:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16222 invoked from network); 19 Mar 2021 21:28:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=ejy6cWiCTJfmWKQMk10p5UZeWDqZFvT4CND7HoHywBT5DNVyVD3UOAa8Hrycw/ps6+
         05vKXy4nxWv8bg0fVn+U3gkIt4cS3ofZ2TNfd6JbdV1F91DCWJ71jwYLEQtMn9HAXozO
         Mmrjz0kenbtMJXw5cpxlGpbaVeCZwXEnCNpMU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=t2/lzZEysCOoYljaAvQIc3fgtHxnQp/vjIhGp4x8WmJIhjB0jGEBh1mzJB167GDqyZ
         oCI14GUg+SSUrWd2VqS/HPvETQ1Jxz54YzND52HUVtzild3xlgud36pUUp5BBVUQxV6y
         vEdp/JviuQIvzxEwMbutGSl1HaMX3nfAw7+0HXjpRER7cFkAH3htCR5SBz2aPsvBm3oc
         xnJ0BJGlH1FcW8n3CrFc/mRqT6z9i9chTE8L019fLz+pi3AMMq9JgYHSSpYHWDmTPSg4
         zFjpNzlUS+nrBS2UZAit/dCAlpS7oprSHXzgUXaILqD42eBW0wsN2zEo0NLK0wq8HIZL
         o3pg==
X-Gm-Message-State: AOAM531BfFH7vy1HP42OagZ8377R74L69fZd2DZGNVCDFFw4JGpp9y/8
	m1R0bB8jl9xYLVjsfmxjc3R6vw==
X-Google-Smtp-Source: ABdhPJzFbnTfmwXyUjVzk+FU45Te/V6SoFc0L6xXU2lvrEGD0zL0nHl9H9x2B3ZLK0nvFsxdZyfnYA==
X-Received: by 2002:a17:90b:681:: with SMTP id m1mr476466pjz.168.1616189322441;
        Fri, 19 Mar 2021 14:28:42 -0700 (PDT)
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
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 6/6] lkdtm: Add REPORT_STACK for checking stack offsets
Date: Fri, 19 Mar 2021 14:28:35 -0700
Message-Id: <20210319212835.3928492-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319212835.3928492-1-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=fb815901a1ccc1d9c4ca5c3e3cd3729b7f382fe2; i=b69wRsxT78r/3tM1mGa7N6ME6+rlXyFg15giRWRwPAQ=; m=aFqgiEE+nAZdug79A1F+fVTg9ZceUb0WPE8cbHqssVg=; p=ZQ32/kILkW5AD3nBZHO0VMTp4prIPkm7+DdhCHX8KdA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBVF4IACgkQiXL039xtwCY3XA/9Hc7 uCdnb6IBdks8FZIXBvGn8iqxkiI9jjjTCKozGcJ39SUBhTi98eLk12QE8/L8iuMzlY7nSS93HTrGV T+BS6LWgoYdWZ1vzeRqKj2ovp8AESLtcLZoWFhX/oM7kbXFpWiChKtvW8u8occfMmeCPD0fjX9OXc 9VwR2F51qP9IA+X7ihTmMfEwT7YurTNg/POD9NMFjhkktXwKJVnxKq7yqnpI9eouW3EMIU26EH2pm b6tihBnsotHNjZJ89gD8aM1o5mg2JgcpQ/lJY3jX3YuNKdjsG2Vg8DUB+04NrbdLysjqZQ0DIHamy UVXKM0B6ZPLPz5nOimx/D5TYpWDY7Yj5lTS7gYnjJzt0UFCECHHocfss+/eC5EnJwETz/JpUcRpuS CsswP/CZZ9Hf1HqvEy3F+aIuT5uP8PgGSNRztkK76YJ6Xrj9Mln6u7bPBCn0+EYsmlsL2/oCGVc4M /nfQmQ9sjPsm1hGhs4Xdoh4HX2OpPln6fqCYaV/yWfgQysuaGi083LU3OVDKvw6HWc8ZzqF48EU42 sisXTwgZJadagLzYDaJurWB+bqV52QnkLr6/Hb0Mp0Yu1tW+0pp5IMVxP3Fo575mLgTyeWbmv/kCs TDzCPCOMxiG4lsvlDqgluKkVTdZ1PD/AylEtmoS2tOihVR0k2loLyrEXi//t+jKk=
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

