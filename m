Return-Path: <kernel-hardening-return-21937-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1DDA1C0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 22:02:42 +0000 (UTC)
Received: (qmail 15664 invoked by uid 550); 9 Feb 2025 22:02:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15643 invoked from network); 9 Feb 2025 22:02:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739138545; x=1739743345; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrCBrsBGQ+tCvXOABWtiT76sFUcDv+I/VrUzIQbDTzU=;
        b=QUiGIUVueNOVL3ayuVigfpENIGjTZlEyjmlf//F7e6y4QkDZH1JA8LRXUasdavzxlx
         3LC+Up/JBJJ3tPc/iFDNovuB5tg54Q8q0b9e16DbrsU9NSGvnlWltTY6YvqJ2KgBZeAW
         qcQJKIUL+JnUd9fr1wOZapAeM3JcYw4646Jv90ud54AalnXbMSpZ0rT0OzjoeczyJqAD
         hs8u75I05ELVJfkpA2RjjEVE7Lljm4PnOvDQWFpg/Ci5xEerz71Erfzq5caYze5xD6v7
         MhjsX3DXVZc+6SDwqWFfso3GHfVfMluS8SpNZDVN2k8SsI54DlFVn92i9DjGdqeFTR8P
         JZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739138545; x=1739743345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZrCBrsBGQ+tCvXOABWtiT76sFUcDv+I/VrUzIQbDTzU=;
        b=UsQammuvWXf4h9wnt+TQLwImHo5X+ZHhTY7Mwl3jLrqx54BlJh/Mp6mXVsP6QIg5jb
         qSzGK0sMJkJwAnc1e54YMj+E7pNBppCTDdtjDpuZHLwayIUuoU2H62Oh3Pa1nMMdx5SR
         aI1UqBWIkLVVrPAmpUvHKvuNQrPlPesd3LEv6Sfugjp3n7DDTOT3Itm9+P+OSFlyKj6P
         jqYf9FdDtFezGXwWT4GwBEw+cNZlQX9tiaj1T7g7ZKZLpCRYBM0Tlt12zQpq11PzyHPQ
         y0bOuNJXsgJAXKOAApZYPZbQNWsiAY09llFInXHVCcQSrlI4L19mB3oF5lYegqH0Xrba
         rxsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBRmo8VzAMoqaabmCct/gPy62UX3kYHGchVWDc+zaW3CN6Rrbj5+IQ0H4mxR4UlLAb3Zpv8KXNm7x1XszZ2Kbt@lists.openwall.com
X-Gm-Message-State: AOJu0YzxOK9PgapRjbbEiMvSQqKGOFWmJ4EoyUQBE54rXT0F5xWc+T14
	2DSQRxV8OfW7gcgvwKXBIjnTFl08e++IR+xGr7m0ipYFj0l8Sv9j
X-Gm-Gg: ASbGncvOyB2YpVd2W7NlcmBlQeqF8MHYndorVdsXw4FJZqmPm4JaiL1pSEMfp2PQb/H
	yc106ShpwlPpL3hXprdsFmkanCogUQk4mBa/V4KnaazJLQwMmXTsOJtKSAS5fpZuLLZe5yUp1Y9
	+LDm3RgFYBS5y73dcrVv9GGbshDUHQTi+ufDTDSGOdkqAohpaU5klaWu5kmpiPebs/wAaRLwzhH
	iTkL9hgfm6QQ572xKFI306UyBHkfcADuup5CZm4QPL6alHWp+CXLHv9wYQOuAGnWUT4EulrjlbF
	dJB27AclZOpLdf5uHpUJUwG0ofnVEGhFYwcXmq++KheHYH6AD/DPlS5OIZouBJnRIteF+ltd
X-Google-Smtp-Source: AGHT+IGLh9i/kI8Ha8+Op3DoUswKsdryEtT21pr/+6nTQeWXoWEW/G6p3UUlYi/NxO5jEdod/Gguuw==
X-Received: by 2002:a05:6000:2ad:b0:38d:e02d:5f4c with SMTP id ffacd0b85a97d-38de02d60b1mr208725f8f.10.1739138545239;
        Sun, 09 Feb 2025 14:02:25 -0800 (PST)
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
Subject: [PATCH v2 1/1] x86: In x86-64 barrier_nospec can always be lfence
Date: Sun,  9 Feb 2025 22:02:22 +0000
Message-Id: <20250209220222.212835-1-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When barrier_nospec() was added the defintion was copied from the
one used to synchronise rdtsc.

On very old cpu rdtsc was a synchronising instruction.
When this change X86_FEATURE_LFENCE_RDTSC (and a MFENCE copy) were
(probably) added so lfence/mfence could be added to synchronise rdtsc.
For old cpu (I think the code checks XMM2) no barrier was added.

I'm not sure why that code was used for barrier_nospec().
Or why rdtsc ended up being synchronised by barrier_nospec().
lfence is the right instruction (well as good as you get).

In any case all x86-64 cpu support XMM2 and lfence so there is
to point using alternative().
Separate the 32bit and 64bit definitions but leave the barrier
missing on old 32bit cpu.

Signed-off-by: David Laight <david.laight.linux@gmail.com>

v2: use a explicit lfence rather than __rmb().
    Update commit message text w.r.t rdtsc.
Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 arch/x86/include/asm/barrier.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index 7b44b3c4cce1..b9af75624cf5 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -45,7 +45,11 @@
 	__mask; })
 
 /* Prevent speculative execution past this barrier. */
-#define barrier_nospec() alternative("", "lfence", X86_FEATURE_LFENCE_RDTSC)
+#ifdef CONFIG_X86_32
+#define barrier_nospec() alternative("", "lfence", X86_FEATURE_XMM2)
+#else
+#define barrier_nospec() asm volatile("lfence":::"memory")
+#endif
 
 #define __dma_rmb()	barrier()
 #define __dma_wmb()	barrier()
-- 
2.39.5

