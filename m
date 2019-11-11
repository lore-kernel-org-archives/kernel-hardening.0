Return-Path: <SRS0=jr1D=ZD=lists.openwall.com=kernel-hardening-return-17334-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41179C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:47:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 893CC206BB
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 Nov 2019 21:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ihuN695K"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 893CC206BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17334-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32590 invoked by uid 550); 11 Nov 2019 21:46:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32353 invoked from network); 11 Nov 2019 21:46:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=scnPY7Vttw3RyzZhL4W5SpA/avMnImyUTQ0YId03ujs=;
        b=ihuN695KvOIYvShEFrPb/mLsRgCB+jsW+Zf4zcpsRLeZ6gUH29xLpLoEaSZENcxesD
         aRXnINDZpo+dHBayJhowwxsHQmmjO8KhdQEmxw/osNEkLnDYkkGzE3mUznjodnxBXuKd
         g40VBnd7TXFKmXIgxwQAsBGGRxfPHa+cNQYBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=scnPY7Vttw3RyzZhL4W5SpA/avMnImyUTQ0YId03ujs=;
        b=WCB1l486g+OInt4etrPrNr6luZQQDvxVIdwPLeTvDQTWWjKxuPA7mnoz20/VsyiGbO
         Xo+UV6Ggr7BuQ5YQD+zulcK7sbejLYIkqUeu5yQajCwqmb7hiO9ZHbPc2u3+awnoBaZb
         U6dOrLJ+pavQG9s6pUaYVHPW9b6u8duzmu5tTf3hc1Zr+QIsEc4YW5fD+pBBbIz5hFMa
         GIqBknS15pTQZwQx0xTDKRlHJjgkFvCc1JJvHhR6DdqwJ4T3ECMSiIXJCB3ncpVfHg0h
         ag0WjPcbyiGFY7zQgCFcUxJo3pwHGUydLsUO1dpW5o0N7/B1l5gtwzGKPWoOjsssGRRs
         SQwQ==
X-Gm-Message-State: APjAAAUy/NPj9G+bhtixTGq1Va+/5qzCw5l9u/RxP31RAJrhlzjQKfI0
	p2N667iiEBMU/Q8cZk2vw4Du02+p6lM=
X-Google-Smtp-Source: APXvYqzVIxtt5GEKdaDXPQ+xj7Wjby90TrRdmpa51OGLsU2O2Qj1q3F+9zcZ2rKrY4+kA2/QVptBBg==
X-Received: by 2002:a17:902:7c8f:: with SMTP id y15mr27046980pll.341.1573508764932;
        Mon, 11 Nov 2019 13:46:04 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@lsc.ic.unicamp.br>,
	Eric Biggers <ebiggers@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v4 1/8] crypto: x86/glue_helper: Add function glue macros
Date: Mon, 11 Nov 2019 13:45:45 -0800
Message-Id: <20191111214552.36717-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The crypto glue performed function prototype casting to make indirect
calls to assembly routines. Instead of performing casts at the call
sites (which trips Control Flow Integrity prototype checking), create a
set of macros to either declare the prototypes to avoid the need for
casts, or build inline helpers to allow for various aliased functions.

Co-developed-by: João Moreira <joao.moreira@lsc.ic.unicamp.br>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..2fa4968ab8e2 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -23,6 +23,30 @@ typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 #define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
 #define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
 
+#define CRYPTO_FUNC(func)						\
+asmlinkage void func(void *ctx, u8 *dst, const u8 *src)
+
+#define CRYPTO_FUNC_CBC(func)						\
+asmlinkage void func(void *ctx, u128 *dst, const u128 *src)
+
+#define CRYPTO_FUNC_WRAP_CBC(func)					\
+static inline void func ## _cbc(void *ctx, u128 *dst, const u128 *src)	\
+{ func(ctx, (u8 *)dst, (u8 *)src); }
+
+#define CRYPTO_FUNC_CTR(func)						\
+asmlinkage void func(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+
+#define CRYPTO_FUNC_XTS(func)	CRYPTO_FUNC_CTR(func)
+
+#define CRYPTO_FUNC_XOR(func)						\
+asmlinkage void __ ## func(void *ctx, u8 *dst, const u8 *src, bool y);	\
+asmlinkage static inline						\
+void func(void *ctx, u8 *dst, const u8 *src)				\
+{ __ ## func(ctx, dst, src, false); }					\
+asmlinkage static inline						\
+void func ## _xor(void *ctx, u8 *dst, const u8 *src)			\
+{ __ ## func(ctx, dst, src, true); }
+
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
-- 
2.17.1

