Return-Path: <SRS0=ujZ2=ZO=lists.openwall.com=kernel-hardening-return-17423-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D464C432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3B1C2206CB
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c62IQrA7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B1C2206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17423-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19675 invoked by uid 550); 22 Nov 2019 01:03:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19512 invoked from network); 22 Nov 2019 01:03:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ogInRXGt+sPw2HEZ3/J86GV8yEDJ13ZF9JZ3hZT/kGM=;
        b=c62IQrA7WMubIKMG7YRJfYNOmH5PP3OT90j5iiPtbjViBXxNeoyI+rV6BqUpCESkc3
         0Z6S2kc1Ccjd6okULsJZlYzzpEAwEx8F/2cRVCPCVqWdvIarQggraQ6MQJ93WsAdkTYK
         QnmRcZuTUPTjhbIA8tmlOW7wJi47t97BFMcK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ogInRXGt+sPw2HEZ3/J86GV8yEDJ13ZF9JZ3hZT/kGM=;
        b=Hq1qq4+xh2bi5FxAbTdLpM40OTDPF7sw1zr3Vl4uC2KPD4jFaA8gO9kCYUMhSVs1Pn
         j8SlHAYg4MT4sUZHxOQU7zkyiTn/+0N+eJmXbQU+BNnK8nZKfm4Tq0LIfT9jNRXm+LTL
         cLEh4vNqCkBFdEcBiG3MMF6eyHH9s2TQmCR42BVXPIzbG+h1ai2WVjiRIo9AlQ4Xy75k
         7vEhvuiFCTABMS1G28gNYOxVWS7++orJTEZoLyBW5vLR5xoId6Sqs4mwJ2+ume7d2cdz
         Dc6iCejfmdq3jVqGDtfY0zzpGHltyyzjpIiczgxWCvfyG/WG52xXUtUmXSJRo6pcybQ2
         L70A==
X-Gm-Message-State: APjAAAXw5GNokydgHl6kfuBnCUfgYcy1L2oRrj+5Stp8khMg9OfwqBYM
	OylX6tfKobVE/nfQb1lh0i/FaDzQp24=
X-Google-Smtp-Source: APXvYqwkm/Hnnfz9l9HjiwV4ZZkTNJsjp7ESPfZDQZlb++3cENihjkIQMXfvttuJWXLyWpE9Hd+A3A==
X-Received: by 2002:a63:5f04:: with SMTP id t4mr12527616pgb.73.1574384621641;
        Thu, 21 Nov 2019 17:03:41 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 1/8] crypto: x86/glue_helper: Regularize function prototypes
Date: Thu, 21 Nov 2019 17:03:27 -0800
Message-Id: <20191122010334.12081-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
References: <20191122010334.12081-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The crypto glue performed function prototype casting to make indirect
calls to assembly routines. Instead of performing casts at the call
sites (which trips Control Flow Integrity prototype checking), switch
each prototype to a common standard set of arguments which allows the
incremental removal of the existing macros. In order to keep pointer
math unchanged, internal casting between u128 pointers and u8 pointers
is added.

Co-developed-by: João Moreira <joao.moreira@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/glue_helper.c             | 23 ++++++++++++++---------
 arch/x86/include/asm/crypto/glue_helper.h | 13 +++++++------
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index d15b99397480..d3d91a0abf88 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -134,7 +134,8 @@ int glue_cbc_decrypt_req_128bit(const struct common_glue_ctx *gctx,
 				src -= num_blocks - 1;
 				dst -= num_blocks - 1;
 
-				gctx->funcs[i].fn_u.cbc(ctx, dst, src);
+				gctx->funcs[i].fn_u.cbc(ctx, (u8 *)dst,
+							(const u8 *)src);
 
 				nbytes -= func_bytes;
 				if (nbytes < bsize)
@@ -188,7 +189,9 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 
 			/* Process multi-block batch */
 			do {
-				gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);
+				gctx->funcs[i].fn_u.ctr(ctx, (u8 *)dst,
+							(const u8 *)src,
+							&ctrblk);
 				src += num_blocks;
 				dst += num_blocks;
 				nbytes -= func_bytes;
@@ -210,7 +213,8 @@ int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
 
 		be128_to_le128(&ctrblk, (be128 *)walk.iv);
 		memcpy(&tmp, walk.src.virt.addr, nbytes);
-		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, &tmp, &tmp,
+		gctx->funcs[gctx->num_funcs - 1].fn_u.ctr(ctx, (u8 *)&tmp,
+							  (const u8 *)&tmp,
 							  &ctrblk);
 		memcpy(walk.dst.virt.addr, &tmp, nbytes);
 		le128_to_be128((be128 *)walk.iv, &ctrblk);
@@ -240,7 +244,8 @@ static unsigned int __glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 
 		if (nbytes >= func_bytes) {
 			do {
-				gctx->funcs[i].fn_u.xts(ctx, dst, src,
+				gctx->funcs[i].fn_u.xts(ctx, (u8 *)dst,
+							(const u8 *)src,
 							walk->iv);
 
 				src += num_blocks;
@@ -354,8 +359,8 @@ int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 }
 EXPORT_SYMBOL_GPL(glue_xts_req_128bit);
 
-void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
-			       common_glue_func_t fn)
+void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst, const u8 *src,
+			       le128 *iv, common_glue_func_t fn)
 {
 	le128 ivblk = *iv;
 
@@ -363,13 +368,13 @@ void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src, le128 *iv,
 	gf128mul_x_ble(iv, &ivblk);
 
 	/* CC <- T xor C */
-	u128_xor(dst, src, (u128 *)&ivblk);
+	u128_xor((u128 *)dst, (const u128 *)src, (u128 *)&ivblk);
 
 	/* PP <- D(Key2,CC) */
-	fn(ctx, (u8 *)dst, (u8 *)dst);
+	fn(ctx, dst, dst);
 
 	/* P <- T xor PP */
-	u128_xor(dst, dst, (u128 *)&ivblk);
+	u128_xor((u128 *)dst, (u128 *)dst, (u128 *)&ivblk);
 }
 EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit_one);
 
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..ba48d5af4f16 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -11,11 +11,11 @@
 #include <asm/fpu/api.h>
 #include <crypto/b128ops.h>
 
-typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
-typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
-typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_cbc_func_t)(const void *ctx, u8 *dst, const u8 *src);
+typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
-typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
+typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
 #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
@@ -116,7 +116,8 @@ extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
 			       void *crypt_ctx, bool decrypt);
 
-extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
-				      le128 *iv, common_glue_func_t fn);
+extern void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst,
+				      const u8 *src, le128 *iv,
+				      common_glue_func_t fn);
 
 #endif /* _CRYPTO_GLUE_HELPER_H */
-- 
2.17.1

