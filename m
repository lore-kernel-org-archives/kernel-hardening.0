Return-Path: <SRS0=8g0k=I4=lists.openwall.com=kernel-hardening-return-21086-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B812C433E5
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2878A6199A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2878A6199A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21086-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5273 invoked by uid 550); 30 Mar 2021 20:58:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5154 invoked from network); 30 Mar 2021 20:58:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UG6lpZSAG8t+NfdJici9YkMGF34rxaYTMGPEmVDXXFs=;
        b=nAtL0yLEpjO2guyFAnk1UK8RCNVE817hSH2Q172t9upN0Y9DcHi4VPdazL0wXZjLfd
         xlHHSMBZWyFEw7jxyLinGl0JaLbvCqzWK4kVm5P+6y5xzoKJRTbfmuOnH8+1yQshwVQ8
         emm1ECwHM5YtpWRAoVYZwoNNTFLms6VvWOqLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UG6lpZSAG8t+NfdJici9YkMGF34rxaYTMGPEmVDXXFs=;
        b=CZ5b/Wuc391ZgPusxnKyuEL3mXTjqdCqHjyAqPncjdjO8pWnlSS0RuaxhOZMY3qTlg
         h3RK9TOH86XeFKZhj0++J+88B5WIQZwiD+HOnHjKP+OksuA7o/QaQhKPl2ceMcnApZ3u
         +xNeNefq8Y5Ycsu1S6HFiZnYU243W/PgoEjmq8RJyR3qJJv6pu0NdGdZAmh2TOWMjXib
         Frc+Ia2N0RdwgL6ijwjwX6QNoBJgnUM7pYDKsJ95N0+aBlavPWI8aWhuGJEN1oldXhfS
         6D5HN/2X5/iC4se0pQEwaCR7XsuaPMRhFqwFlaygkMnt56Gw38w2G6Zq8b0NoAqklZwC
         WMbA==
X-Gm-Message-State: AOAM531IIJfmXgPukcnCietGBzRypl7ECO9JYbD1Z7TkovDGduRhIzwQ
	wZDrON1Su//o/SYESBuuRpLzoQ==
X-Google-Smtp-Source: ABdhPJz3LXv4eDOhFhF6lIjzHku5IEzcEABiR69AQC5cXMNAv6qJ/s1o3KIyukaQCofHm60NmmHgeA==
X-Received: by 2002:a62:8fcd:0:b029:218:461:2279 with SMTP id n196-20020a628fcd0000b029021804612279mr31460592pfd.43.1617137873522;
        Tue, 30 Mar 2021 13:57:53 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
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
Subject: [PATCH v8 2/6] init_on_alloc: Optimize static branches
Date: Tue, 30 Mar 2021 13:57:46 -0700
Message-Id: <20210330205750.428816-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330205750.428816-1-keescook@chromium.org>
References: <20210330205750.428816-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=2f4b59272e09d0180c87e3d8378d95ea375990ec; i=7VrM8Pzr5MGi8vAaDOW4xeiDtVYbjHgJsdLlT/sxDXE=; m=OLLKLAHsfNT1d7+pflxMGJuAvSt8GZaetKIXzfk0ilc=; p=cKq4RSNZSRZ+ASTC07w37jURMQB1hxGsdgqU07adDH0=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBjkMwACgkQiXL039xtwCZc3RAAneZ W9nsrEVAJu/2EM9W3eP/wNa9JCKIEGXsfdWDWQPPeCbpGDVnJgSVyjiCWUFr4tej6kSR2JcjNkDtk RamMPpNcmIBTAEQZCMJvmrtcKW1IDd/OGeQba5IsPM2+nzcu7TIihfbnaOaO007hiw5q0lN0dy6Vz INq699xnV4EDdLtYeikcR+yHjgF9BrTpVkRdUUD05riIM5MKdp1bCEELMVGvRNofeTRfnTwGW+P08 L8DpSkB+4LmS285BqK0bLDrBFkIlT32vvQmNur8jFep9Yddh2uApO3GfmkatNKXr2pZhthk9ylXAt oLYfDTHsftsgfeBeeCgYWbz52VxjzKw2QlqYy98p2kmLbSWjhZs+mnMvjUfTsHk3tE8pULROEkkxQ EYBq2yGgZCxW/DplktGsnIw2+IuXr5ZVmszBhCU7fjdfnuUpGieeboPgZ3bsyFyLCg5COu0WaMU2k NqhLH42LJzP9w7bvvdccxuPX4DwZjsue4iDmmZgYnWCq20wHcbjVquMuhe5+Z4iMSYCe12rKUT8mh qYDodBX6u5xZgbfJp+x144gtPE89shG9i69yAXKWgC/kRl/en7wYjeg0utnlpYkc+Vg0Oe3I5Jkfs TmEtbMUzu1eA1785dXZn5CS1UZL6KK1W57w5r0f3u7y/IwvVYp1i1NAnZT/lq1BQ=
Content-Transfer-Encoding: 8bit

The state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and ...ON_FREE...) did not
change the assembly ordering of the static branches: they were always out
of line. Use the new jump_label macros to check the CONFIG settings to
default to the "expected" state, which slightly optimizes the resulting
assembly code.

Reviewed-by: Alexander Potapenko <glider@google.com>
Link: https://lore.kernel.org/lkml/CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com/
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/lkml/5d626b9b-5355-be94-e8e2-1be47f880f30@suse.cz
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/mm.h | 10 ++++++----
 mm/page_alloc.c    |  4 ++--
 mm/slab.h          |  6 ++++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77e64e3eac80..2ccd856ac0d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2871,18 +2871,20 @@ static inline void kernel_poison_pages(struct page *page, int numpages) { }
 static inline void kernel_unpoison_pages(struct page *page, int numpages) { }
 #endif
 
-DECLARE_STATIC_KEY_FALSE(init_on_alloc);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc))
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc))
 		return true;
 	return flags & __GFP_ZERO;
 }
 
-DECLARE_STATIC_KEY_FALSE(init_on_free);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free);
+	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				   &init_on_free);
 }
 
 extern bool _debug_pagealloc_enabled_early;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e4b29ee2b1e..267c04b8911d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -167,10 +167,10 @@ unsigned long totalcma_pages __read_mostly;
 
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
-DEFINE_STATIC_KEY_FALSE(init_on_alloc);
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 EXPORT_SYMBOL(init_on_alloc);
 
-DEFINE_STATIC_KEY_FALSE(init_on_free);
+DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 EXPORT_SYMBOL(init_on_free);
 
 static bool _init_on_alloc_enabled_early __read_mostly
diff --git a/mm/slab.h b/mm/slab.h
index 076582f58f68..774c7221efdc 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -601,7 +601,8 @@ static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
 
 static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
 {
-	if (static_branch_unlikely(&init_on_alloc)) {
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc)) {
 		if (c->ctor)
 			return false;
 		if (c->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON))
@@ -613,7 +614,8 @@ static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
 
 static inline bool slab_want_init_on_free(struct kmem_cache *c)
 {
-	if (static_branch_unlikely(&init_on_free))
+	if (static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				&init_on_free))
 		return !(c->ctor ||
 			 (c->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_POISON)));
 	return false;
-- 
2.25.1

