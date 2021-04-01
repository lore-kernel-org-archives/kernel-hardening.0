Return-Path: <SRS0=G4X0=I6=lists.openwall.com=kernel-hardening-return-21141-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A7DC433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:25:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B75A261105
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 23:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B75A261105
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21141-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11841 invoked by uid 550); 1 Apr 2021 23:24:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11688 invoked from network); 1 Apr 2021 23:24:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LvZQ1bPDTn+jfy4ZjpxxRS3b5GxvPPmzyAjth6NaQ44=;
        b=F42wJOLiSpeN/4fzwW/N9mYN1ryaPRGoZdaLqlVuodcAvGQ/ABIjgVX+b+at7lWvdh
         jETxFZAabFX4f9lDzotk6Kj0Lg2Y/9s9xOtR4bTEFmgSRaHosFkbLoH8wmrTPZ0KycU5
         e2szNTHZWHmNtWCzVWeIu3x9aVYmZd9gsKNMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LvZQ1bPDTn+jfy4ZjpxxRS3b5GxvPPmzyAjth6NaQ44=;
        b=nCQENeeyEQVYQRewR4za3rEXxtormwp3sj0nXlgXuiKMTSnpc2HPV/uVtB/fJBP3jr
         jTL7Ax5XcqSDHiCXUFLE/qUUQ6fPmHqFCRrT8NWmp+6hP23m2gJAZKNMTz4YqJng4d1s
         ZWGFTfRRP5U0RTAxWLs5NawFXcw4PfhmiP41X/0Ap5fc1Cc8/Ha9KCLRwGnpZ9HQOa6A
         qpD1IeISIs/ASAdy+awTiW7JSpqKmykabpdjUEHJ0avLohWh8r6Kl6hJeHkYJMTRhHFx
         Lzy2pg8l8FtmCEirlhRWByfQfc9NidrgCaWTxbzCQ7WSRKxxs1x0iaJD1Lg3k4NAk7fN
         vhZg==
X-Gm-Message-State: AOAM531ociVj/L4EY4+mt1tV63o/lmUNuOw2ttLMQE40zkMpoDzWgMSW
	V49nbIBdV9nYfLjQMmm3kb3JoA==
X-Google-Smtp-Source: ABdhPJyJvuTUIP8/7JclWdgrMtrP8e/Mxf3nuL8lBiVp7B+1ZeXl9ez94SqDJnG3QluQM6UrJWyP4Q==
X-Received: by 2002:a17:90b:100e:: with SMTP id gm14mr11159194pjb.217.1617319435264;
        Thu, 01 Apr 2021 16:23:55 -0700 (PDT)
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
Subject: [PATCH v10 6/6] lkdtm: Add REPORT_STACK for checking stack offsets
Date: Thu,  1 Apr 2021 16:23:47 -0700
Message-Id: <20210401232347.2791257-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401232347.2791257-1-keescook@chromium.org>
References: <20210401232347.2791257-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=04ba1fd2cf94c15b6c425d21eadf26c7b5b595c9; i=b69wRsxT78r/3tM1mGa7N6ME6+rlXyFg15giRWRwPAQ=; m=XEkb9gtEVwIXoR3CRFWDIQGhFt30zOfIashAyp1d4uo=; p=d33GDHyvnRxlVkBNxjBj+O38zle2N7FWLUDCSfaX1O0=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBmVgMACgkQiXL039xtwCaFWBAAnoV bf3FCj1tsOpxawVbSq+bVH2eLNWxW93P/OuD2SZViYnIltHwsMQb5O5JgjncW8xaOmaxRSKlAHAun c8QcJmj4OtK9gw6w9RGgvv/IFpIerKQ9rmBX1g3E9pYYL9w3c9VPWCCEy/n7JmUxYQRdueDWTFxbM DJcbI5C+2IcnzFrLA9H+wols1KqBnYq+b4dXGbk5komriRvkgReB+BDYk0Xk+CETCOSiHLluDFQBB o4m/PZXGsdWMD8Te1U+mf9I5VkhN/tQx3X4hchBhH1+Nmia+fhRki75vFi4V+nSg9uUwxBrnbvy0e wb+gePWPXj9YaEOUMwEy+OS6/ZvEFF4iXdsIokIGW7FylzIQnFltv1/iqj88+OPI+ptCESfD+jqyo h4VlZj/uVKKzJVktDMm8BrXCZTYeRD8ZvvxcTZRpdpSwPPH/p04bvjvs95CmBvn49r+7IpnVrUsH6 Q5EEB2mMj3/08pFtDtKkLRJi0b103YakkJghevfP1cQS6TlRL/XsKiM3v5UVjaH+OToPHUDfUCxSt ZzVucB9RlDb5QHXAW/55qYH2YKkEVAZt0B72UH+tH1XCxNucHUz84/Da5+eVTToByC7in/7nXdNU0 QHf1hWPssVLB1w4iS8kzT09u4F86a4AlFf/lxJmVXI1e4coBbEsRlccoJFqqRc7s=
Content-Transfer-Encoding: 8bit

For validating the stack offset behavior, report the offset from a given
process's first seen stack address. Add script to calculate the results
to the LKDTM kselftests.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c                     | 17 +++++++++
 drivers/misc/lkdtm/core.c                     |  1 +
 drivers/misc/lkdtm/lkdtm.h                    |  1 +
 tools/testing/selftests/lkdtm/.gitignore      |  1 +
 tools/testing/selftests/lkdtm/Makefile        |  1 +
 .../testing/selftests/lkdtm/stack-entropy.sh  | 36 +++++++++++++++++++
 6 files changed, 57 insertions(+)
 create mode 100755 tools/testing/selftests/lkdtm/stack-entropy.sh

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
diff --git a/tools/testing/selftests/lkdtm/.gitignore b/tools/testing/selftests/lkdtm/.gitignore
index f26212605b6b..d4b0be857deb 100644
--- a/tools/testing/selftests/lkdtm/.gitignore
+++ b/tools/testing/selftests/lkdtm/.gitignore
@@ -1,2 +1,3 @@
 *.sh
 !run.sh
+!stack-entropy.sh
diff --git a/tools/testing/selftests/lkdtm/Makefile b/tools/testing/selftests/lkdtm/Makefile
index 1bcc9ee990eb..c71109ceeb2d 100644
--- a/tools/testing/selftests/lkdtm/Makefile
+++ b/tools/testing/selftests/lkdtm/Makefile
@@ -5,6 +5,7 @@ include ../lib.mk
 
 # NOTE: $(OUTPUT) won't get default value if used before lib.mk
 TEST_FILES := tests.txt
+TEST_PROGS := stack-entropy.sh
 TEST_GEN_PROGS = $(patsubst %,$(OUTPUT)/%.sh,$(shell awk '{print $$1}' tests.txt | sed -e 's/\#//'))
 all: $(TEST_GEN_PROGS)
 
diff --git a/tools/testing/selftests/lkdtm/stack-entropy.sh b/tools/testing/selftests/lkdtm/stack-entropy.sh
new file mode 100755
index 000000000000..b1b8a5097cbb
--- /dev/null
+++ b/tools/testing/selftests/lkdtm/stack-entropy.sh
@@ -0,0 +1,36 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Measure kernel stack entropy by sampling via LKDTM's REPORT_STACK test.
+set -e
+samples="${1:-1000}"
+
+# Capture dmesg continuously since it may fill up depending on sample size.
+log=$(mktemp -t stack-entropy-XXXXXX)
+dmesg --follow >"$log" & pid=$!
+report=-1
+for i in $(seq 1 $samples); do
+        echo "REPORT_STACK" >/sys/kernel/debug/provoke-crash/DIRECT
+	if [ -t 1 ]; then
+		percent=$(( 100 * $i / $samples ))
+		if [ "$percent" -ne "$report" ]; then
+			/bin/echo -en "$percent%\r"
+			report="$percent"
+		fi
+	fi
+done
+kill "$pid"
+
+# Count unique offsets since last run.
+seen=$(tac "$log" | grep -m1 -B"$samples"0 'Starting stack offset' | \
+	grep 'Stack offset' | awk '{print $NF}' | sort | uniq -c | wc -l)
+bits=$(echo "obase=2; $seen" | bc | wc -L)
+echo "Bits of stack entropy: $bits"
+rm -f "$log"
+
+# We would expect any functional stack randomization to be at least 5 bits.
+if [ "$bits" -lt 5 ]; then
+	exit 1
+else
+	exit 0
+fi
-- 
2.25.1

