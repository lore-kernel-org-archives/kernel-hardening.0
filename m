Return-Path: <SRS0=tQG0=I4=lists.openwall.com=kernel-hardening-return-21085-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F136C433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9BE17619C5
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 20:58:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BE17619C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21085-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5228 invoked by uid 550); 30 Mar 2021 20:58:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5156 invoked from network); 30 Mar 2021 20:58:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=FE7kn9uccaNwZUZ65DKIqMMeCF4L8T5uHj+6rAX1M16+hIAiROMPCoW0ANbpyvkauA
         zNm2OopXkQ6LAOsRPbIK640iKsOLSDOOggNsbZdq6eYIsT34pwdagUeVUvG7xjxhyCBj
         zo84r5YxnuOMKbimr0OM8w19pz/qkGBGzGeOI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=R2NSFVj/gz/Isd6Z353hIdYBdiYTx9KrY76INs8wuj5bem0TdzlM/NVR9x0/geW6oF
         KK7Hg610v/bs1ZOIxsan3NT1aLkG8FACa1fkV2u1DBHoeGm4xOiGlwZUXlY3lnQWYVN7
         JEnszosurfkaJYwhkugSb5j3NJoZkHKtCJtKnepSzv+CZSqzu80ostrF+94zE+1jD32m
         zBfMAIfmsYfy/gC7BQAGTfuxIL72YvxAXVFoiombxnEt4E3Y3gTU9ZuA565vtEimU+2H
         Qq7WBMzQiKgZhJ8XOpJ4mjD6muWPDNfYAHEw6sE2zJweenu/Y+gLYIZ/dNeTm7CjGzr6
         qTHQ==
X-Gm-Message-State: AOAM531AAOSMD6SYqacwGV9eGhGO8GFkGzu6e74do8cxjlZxUouuJR97
	EZCkCWKa8m1UrAurwuHF+Cuydg==
X-Google-Smtp-Source: ABdhPJxKiSYrHQGcEilxb2Xm7psWt7RDOXuAoFkC/UflndAY9YjgBstIUNwwje4/jGjMrGhbk14LkA==
X-Received: by 2002:a17:90b:38f:: with SMTP id ga15mr170436pjb.149.1617137874107;
        Tue, 30 Mar 2021 13:57:54 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
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
Subject: [PATCH v8 1/6] jump_label: Provide CONFIG-driven build state defaults
Date: Tue, 30 Mar 2021 13:57:45 -0700
Message-Id: <20210330205750.428816-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330205750.428816-1-keescook@chromium.org>
References: <20210330205750.428816-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=aa54c44d1d71b9550d6015efc734f667917094a1; i=Vishx6UyAXwYzcnoSyP+eBB3iQyx+/i5smsbQfc0cnA=; m=vc4sSYlf+uaSlLSFP5TpbQv56VaSRpBLpRuMltXaB4Q=; p=mNH2Bo/K9vrGz9sBtTDV8UFO0eJ8yv8BbR/DeIaO1es=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBjkMwACgkQiXL039xtwCaWexAAp34 ok/GqKys22n/+Xt+9QrE/sBFj+uvgYjI14mqH/xkZoouYd5+myYJn0h/B8R83n48nwB7KdYtukzVv nSela//6I+ohCNhjgEt1TmUc81qTISl5q5mxbq/+IAPNVqlXEYCpTcSFkBbr5tbXOoOrbkI87vrja az8w6YyJGWbCBm/PpNK/FqvgxnWKMmJbomwDiBeWSgEfJUSD/M/r6PV1RhbK2mt7AniDqOPJ/oRG0 VB6GcbfW106hXfwKjmeqoce8yTv7YrC4mYL5sKA0yV/H62mmU9vkUtd+/0x07Cg1iXFAbg3bkDu/i hQkdH1ZBkjnjcWQJ6pvYBfHR+5Fblp8ibFwpPJc/hJmGkzxTde5pAlM3s4FMdtv++qD7bvL2tdXIS kzkw4HJRrjKMET9L3sAWvlSZgUTAip8wslmfIZUVea7HUy5ypoFIvSxHL5BNOGiTBp0zWwvXAzNt1 PTrOAP9fZKIsGI0Nj6laG2wpUdzjTpYcjfNxIPtygIIqheWGFwHwPYpWV0g8700cR/heR7qoBa0zt nrQX1WU7AUkaYROLg1QVWr13bMVlZZuDsSPfvsu3yo8alzHhY8xaryuKCwuTzY8ResHzU6XIqkmJb J1b8qCZ973eAn1T3KbVOk18YcqsShZ8C4SwIbyGOuesFrhes7bPZf/GqTx2MNcoU=
Content-Transfer-Encoding: 8bit

As shown in jump_label.h[1], choosing the initial state of static
branches changes the assembly layout. If the condition is expected to
be likely it's inline, and if unlikely it is out of line via a jump. A
few places in the kernel use (or could be using) a CONFIG to choose the
default state, which would give a small performance benefit to their
compile-time declared default. Provide the infrastructure to do this.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/jump_label.h?h=v5.11#n398

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/20200324220641.GT2452@worktop.programming.kicks-ass.net/
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/jump_label.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index d92691262f51..05f5554d860f 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -382,6 +382,21 @@ struct static_key_false {
 		[0 ... (count) - 1] = STATIC_KEY_FALSE_INIT,	\
 	}
 
+#define _DEFINE_STATIC_KEY_1(name)	DEFINE_STATIC_KEY_TRUE(name)
+#define _DEFINE_STATIC_KEY_0(name)	DEFINE_STATIC_KEY_FALSE(name)
+#define DEFINE_STATIC_KEY_MAYBE(cfg, name)			\
+	__PASTE(_DEFINE_STATIC_KEY_, IS_ENABLED(cfg))(name)
+
+#define _DEFINE_STATIC_KEY_RO_1(name)	DEFINE_STATIC_KEY_TRUE_RO(name)
+#define _DEFINE_STATIC_KEY_RO_0(name)	DEFINE_STATIC_KEY_FALSE_RO(name)
+#define DEFINE_STATIC_KEY_MAYBE_RO(cfg, name)			\
+	__PASTE(_DEFINE_STATIC_KEY_RO_, IS_ENABLED(cfg))(name)
+
+#define _DECLARE_STATIC_KEY_1(name)	DECLARE_STATIC_KEY_TRUE(name)
+#define _DECLARE_STATIC_KEY_0(name)	DECLARE_STATIC_KEY_FALSE(name)
+#define DECLARE_STATIC_KEY_MAYBE(cfg, name)			\
+	__PASTE(_DECLARE_STATIC_KEY_, IS_ENABLED(cfg))(name)
+
 extern bool ____wrong_branch_error(void);
 
 #define static_key_enabled(x)							\
@@ -482,6 +497,10 @@ extern bool ____wrong_branch_error(void);
 
 #endif /* CONFIG_JUMP_LABEL */
 
+#define static_branch_maybe(config, x)					\
+	(IS_ENABLED(config) ? static_branch_likely(x)			\
+			    : static_branch_unlikely(x))
+
 /*
  * Advanced usage; refcount, branch is enabled when: count != 0
  */
-- 
2.25.1

