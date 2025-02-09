Return-Path: <kernel-hardening-return-21934-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8EBEBC0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 19:11:05 +0000 (UTC)
Received: (qmail 7765 invoked by uid 550); 9 Feb 2025 19:10:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7741 invoked from network); 9 Feb 2025 19:10:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739128245; x=1739733045; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+PIfDrYoTT3Z0KtMYk3b2jja3w+ILiNOJ+8sCw8lZMI=;
        b=bM2FOJE0qK0J1yKr4WgYPep3qBwaKPK6QvYkip2ueOwYLZkRRaFgTKFtk6chuDOTsa
         loh/2gInDA9aYNzvAJmnEOFniTOJ5C4fBSkaRVE9gBAun7KslCxOBNtAuLHiXSF96Zfn
         2mYJEfb6MzCqkM71SMMlgZQvhdzxWgWmpn73fFyl2fktmm7QkcoBx6flceHoTKlbRvmr
         fmtw8zke2yKDc8xTHjUEUv04mITCpuF7utLkc0FI1ozoWzP8H1YvNyAv1II+UTIPVzBI
         0/Dc+igTn43aPwcThsUKy4ioUQ61ViNwOTtDCIj/1XXW9Ogt+1h0kwDdtx1f7pHGhBN6
         sjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739128245; x=1739733045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+PIfDrYoTT3Z0KtMYk3b2jja3w+ILiNOJ+8sCw8lZMI=;
        b=Pz+w4mWLGOS9LYjfg1hpaBkHZ+kQXEyDR0mUG4ooQtHetruf84Nzl2tNip562RPxoV
         iYVdTLGLDv9oVhXJGj22ITda94MS8gulCkjJahSAF1W5Q8dS3/c6VShOS6lhw8CIf6du
         FACzie8wlVReHXlaaig+4F52LmnCgBCBajsCc3iyzsdVo8PlKxwMwAiG+z5GEJONUlgI
         EjHGAY7fcIqlP3LTX2xNVbxrE72YAsnv7ylFkqWdL8ztKpZv+oq8cpdkdrL0ZvyC8f1f
         GVHQBSq8FdTG9XjgB81KTSF9ksx6cMPLMWBRs5gb1hMiRzKOL4QjN1dbKdSDTTd1xMId
         ZsCw==
X-Forwarded-Encrypted: i=1; AJvYcCVv5vqdCTMfbRQLlr5e12CNoq1YCCLjMKurH2NlD7kDBWuznPHprDzl3C4bUOfRYD4zj07Tc5m7AqCJhDD1DzSR@lists.openwall.com
X-Gm-Message-State: AOJu0YzgZRZ6bjMjTATJe6rnWiHPhXmnIsA+O9c6R+Jr6mMzNL/firFm
	+hjEpRkTsbAnwZdNq6Ph7JKBpDfXDDqtvY6asPYPjHLT8CqLNeac
X-Gm-Gg: ASbGncvrxj3E4xUruDfU+JNto84CJF629/34rWO/CxVRjLJqEpnDKFlQsRZx/b5GzK9
	qB8PYJ9U5rss17NM+n1NiK2A6cqtqS4M1wYDFFGfxU8PvVb7ppsRlBhCc4HSrQbH1BWvv76DA+s
	+kTIQBwTUtTQE1JGSAmqu5KWo5TgSu/qVbfYrDvCjcwoVPI6z981696VRBc39W8zoqtDFbnOl6J
	FqVX9unhRLt+f8jKLektxdn3F2pplrU/9M0UNE79dC/rROraYXPLG6Y2hnKPb1EdJk0WUFYl/RU
	0AGtsWO27S/t83pL2vQyE9XS1bRCEbWYtA8yddhkA63EX1iJfSGdZKqm2SA+1aKZyoFMRucO
X-Google-Smtp-Source: AGHT+IEqBrgVZ4srRjI2KDjmFb2+XeA2Lt+fPqJ9+a+4DCSdHTgh8qGul9BTPBUwumfDKQtVWy4saA==
X-Received: by 2002:a5d:5885:0:b0:38d:b926:958e with SMTP id ffacd0b85a97d-38dc9101a71mr7868032f8f.16.1739128245412;
        Sun, 09 Feb 2025 11:10:45 -0800 (PST)
From: David Laight <david.laight.linux@gmail.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Andi Kleen <ak@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-arch@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 1/1] x86: In x86-64 barrier_nospec can always be lfence
Date: Sun,  9 Feb 2025 19:10:08 +0000
Message-Id: <20250209191008.142153-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When barrier_nospec() was added the defintion was copied from the
one used to synchronise rdtsc.

On very old cpu rdtsc was a synchronising instruction.
When this change X86_FEATURE_LFENCE_RDTSC (and a MFENCE copy) were
(probably) added so lflence/mfence could be added to synchronise rdtsc.
For old cpu (I think the code checks XMM2) no barrier was added.

I'm not sure why that code was used for barrier_nospec().
I'm sure it should actually be rmb() with the fallback to a
locked memory access on old cpu.

In any case all x86-64 cpu support XMM2 and lfence so there is
to point using alternative().
Separate the 32bit and 64bit definitions but leave the barrier
missing on old 32bit cpu.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 arch/x86/include/asm/barrier.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 7b44b3c4cce1..7eecce9bf4fe 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -45,7 +45,11 @@
 	__mask; })
 
 /* Prevent speculative execution past this barrier. */
-#define barrier_nospec() alternative("", "lfence", X86_FEATURE_LFENCE_RDTSC)
+#ifdef CONFIG_X86_32
+#define barrier_nospec() alternative("", "lfence", X86_FEATURE_XMM2)
+#else
+#define barrier_nospec() __rmb()
+#endif
 
 #define __dma_rmb()	barrier()
 #define __dma_wmb()	barrier()
-- 
2.39.5

