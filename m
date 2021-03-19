Return-Path: <SRS0=zzNd=IR=lists.openwall.com=kernel-hardening-return-21007-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-24.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A0BC433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:29:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0A48660232
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 21:29:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A48660232
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21007-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16207 invoked by uid 550); 19 Mar 2021 21:28:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16041 invoked from network); 19 Mar 2021 21:28:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=hNLL/iR5ciHz3nypbWaLIbBPySyhArn0Jn6KwOSnKW7StS7IyHeAh9dHsnn+rBVZuM
         SZXdTNSxwVKq50x5Xf1v8bhM7QBb3pZu9DXAAd2wnWgI9CSi2PqravtbBDaRX8BVIsHo
         Z26cDQYXGeG5i2SkY21uKSrrQC+cMtJEhj+u8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ijlYcKqhmRnIjh3GfaZu6VzSGgGwccaBk76YZfh88U=;
        b=ub/aV9zYjZMXtujzMnum/RdSUhjexAfrw1dmY1uKE7Xm8GtADK6hKqYyt+p3g7C/FI
         ai96WDwHJSFTYWVqe+YvaJEWhboAfUeTDryvcewzB8u+NPpR6KByGbLU9IV1/bl05SPu
         qIAbnJFAqRvsTOd8NfZzFGTitNHRMKe9e0/hvuefHwEJGfJLIoFexCK8cL7nBHj6Yigh
         NutfZMA4+/FHI8A9RUbXTVZF0aN+7n8MAMnWyn4q+9gxWEPlksgty8Z0vFT5i2vERhkJ
         ImgUD5UMRK7hMR6yL7RS4giheTmI9od+pyj9Aunj/X1WiwU/YbSmfk/Sr5245o26Woyu
         aTMQ==
X-Gm-Message-State: AOAM532X/BGImzn7pVC6cPLd877a+xj066E411V0KFM0M7gLT33gMTpC
	b+ZDSPCA7An6olOmIdG/ngoFRQ==
X-Google-Smtp-Source: ABdhPJyfUXAHNwViuz7nekDjbNriZkEy04Ykr/kaTbKMfCJtsvgOEgLVUNsmKw9hYWc1Hz7JsbqgUA==
X-Received: by 2002:a17:902:6b43:b029:e6:3d73:e9fb with SMTP id g3-20020a1709026b43b02900e63d73e9fbmr16208336plt.37.1616189318964;
        Fri, 19 Mar 2021 14:28:38 -0700 (PDT)
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
Subject: [PATCH v7 1/6] jump_label: Provide CONFIG-driven build state defaults
Date: Fri, 19 Mar 2021 14:28:30 -0700
Message-Id: <20210319212835.3928492-2-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319212835.3928492-1-keescook@chromium.org>
References: <20210319212835.3928492-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=aa54c44d1d71b9550d6015efc734f667917094a1; i=Vishx6UyAXwYzcnoSyP+eBB3iQyx+/i5smsbQfc0cnA=; m=vc4sSYlf+uaSlLSFP5TpbQv56VaSRpBLpRuMltXaB4Q=; p=mNH2Bo/K9vrGz9sBtTDV8UFO0eJ8yv8BbR/DeIaO1es=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBVF4EACgkQiXL039xtwCYoKQ//WsO JhBKVKfDUIyIOwrMCU3Z/kRQjSwDXUlgTtwiYp36T0IJ3d76UirWkyQFSy0y5HMNMyGbGhto2ftzU 7iBhSN/U2EHLY80ksg28k/Xw8jFC36JeiIgqYDWJHbE6d5D5MDzR6+ubtytgB1aNhCuOpETM6HMkZ t5Ckc7Bk31LbOuKiVpG6nzLce4/BxOYq9vzWNPU8g7YB17QXuTDWgurYMwMXytg5uUR6vdCgOKeaH fNyC+StIV1Lj9LzoYgRQKXXYFXduWjWKZ3WcYpJfwgStKSe9uhM6MvfA3aW9W6f5+n/SQS7Yejt5E YYTBCKbMqEIHMuruza2MOMKuyIoK9bT1qvbzDJCEoCXh/DuiSUbdxpMMgtcwPdkxiHHkUPzhkIl7H DwQY5X+eVbPVxL8W9QoKeq+8d/Ve4ASwv4kzDFC65vq5+WI6sK0pQsT4u/3Rcu8sEf0GC25e4tELr 7R0tPXMOgYkGsKM9dVtfSLbQJjvHmaRWJmZrufU9nmYGQuavWsaVkQJTKMY2SkUevJNw+KxlrUCmz gsgT24T5dWCOZao0jTacVwTJ/WKm7vV7SnxTvandK270LFmG5gK/1USGGs8znRoMJPkDE4Ktfzruf pZUWQhHZoMIENQGhElqSlhCvcRS0QOcc9VmehZJGxju+EVvlYvvLM5JDtvaCjRnw=
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

