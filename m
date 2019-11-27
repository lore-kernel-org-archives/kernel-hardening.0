Return-Path: <SRS0=Dkhx=ZT=lists.openwall.com=kernel-hardening-return-17438-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513A1C432C0
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 06:08:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E64942080F
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2019 06:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hDhJm9eg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E64942080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17438-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19477 invoked by uid 550); 27 Nov 2019 06:08:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18416 invoked from network); 27 Nov 2019 06:08:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=dvNwX2gt8S8panv7RA7ankRMAM0mSDoXdafpw63frao=;
        b=hDhJm9egGeqWiKYygEh0zaJKhfQhakVA67p3asr26FvR656yHntQmRu8nZboo81ztf
         q+/72WX0+7QyakJmip6f96oXIB4l55M799wlrrhe9BMwCUOJVjePdaMAM2ocqUV6FH5W
         43s4f65TnawoBGbGHSc93mHOFzW9Z1m/QfUy4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=dvNwX2gt8S8panv7RA7ankRMAM0mSDoXdafpw63frao=;
        b=AvNCIDYRFvqY5hLdznPoH/vCk18Yw8Y65N8JcVMY5pRG+2u+hVI6YL2orhKTI+OqXL
         6EPyGAr5spezeDK008RFOTMU2xutaEB2xSBr9q/3XdwGKLBwXKb79xOKOvetb1ZYZkjK
         2bzsGwqcU4VUZimHHEsJJiRWdiYUPS1pjoum9QanL347eUvoBjdn9hr4cmPLjyo0HzVX
         1bsFQeEgqewRC/jxx/6uotXVH2sjfjkMFlT+bc5pGBaOMnwUZbhNU7mKJ9hbK798o1uO
         lKq5JGslXFns3QOrrJffhPmCsQuLA/pixdzd7SeyjqVmuGMQKjMOqTmfazvFFcgVXeCI
         oxug==
X-Gm-Message-State: APjAAAXymNYw+m7QCEyr6iohPVyqaBhPChKyYN48o0o22cgS/AQd3ct0
	Nd7A8rv7H5UfYF4VDrM3JXRReQ==
X-Google-Smtp-Source: APXvYqzl/5nTeRSPA8peCmChkZUDlO3IrVDTsS0UKDZAOofC77/Q/2cDAcSYKiQPDLhCgsRlcTVZsw==
X-Received: by 2002:a17:90a:9a9:: with SMTP id 38mr3962333pjo.45.1574834884643;
        Tue, 26 Nov 2019 22:08:04 -0800 (PST)
Date: Tue, 26 Nov 2019 22:08:02 -0800
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7] crypto: x86: Regularize glue function prototypes
Message-ID: <201911262205.FD985935F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The crypto glue performed function prototype casting via macros to make
indirect calls to assembly routines. Instead of performing casts at the
call sites (which trips Control Flow Integrity prototype checking), switch
each prototype to a common standard set of arguments which allows the
removal of the existing macros. In order to keep pointer math unchanged,
internal casting between u128 pointers and u8 pointers is added.

Co-developed-by: João Moreira <joao.moreira@intel.com>
Signed-off-by: João Moreira <joao.moreira@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v7:
- added João's SoB (ebiggers)
- corrected aesni .S prototype comments (ebiggers)
- collapsed glue series into a single patch (ebiggers)
v6: https://lore.kernel.org/lkml/20191122010334.12081-1-keescook@chromium.org
v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org
---
 arch/x86/crypto/aesni-intel_asm.S          |  8 +--
 arch/x86/crypto/aesni-intel_glue.c         | 45 ++++++-------
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 74 ++++++++++-----------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 72 +++++++++------------
 arch/x86/crypto/camellia_glue.c            | 45 +++++++------
 arch/x86/crypto/cast6_avx_glue.c           | 68 +++++++++-----------
 arch/x86/crypto/glue_helper.c              | 23 ++++---
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
 arch/x86/crypto/serpent_avx_glue.c         | 63 +++++++++---------
 arch/x86/crypto/serpent_sse2_glue.c        | 30 +++++----
 arch/x86/crypto/twofish_avx_glue.c         | 75 ++++++++++------------
 arch/x86/crypto/twofish_glue_3way.c        | 37 ++++++-----
 arch/x86/include/asm/crypto/camellia.h     | 63 +++++++++---------
 arch/x86/include/asm/crypto/glue_helper.h  | 18 ++----
 arch/x86/include/asm/crypto/serpent-avx.h  | 20 +++---
 arch/x86/include/asm/crypto/serpent-sse2.h | 28 ++++----
 arch/x86/include/asm/crypto/twofish.h      | 19 +++---
 crypto/cast6_generic.c                     | 18 +++---
 crypto/serpent_generic.c                   |  6 +-
 include/crypto/cast6.h                     |  4 +-
 include/crypto/serpent.h                   |  4 +-
 include/crypto/xts.h                       |  2 -
 22 files changed, 374 insertions(+), 413 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index e40bdf024ba7..3e1ffc9e92b8 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -1946,7 +1946,7 @@ ENTRY(aesni_set_key)
 ENDPROC(aesni_set_key)
 
 /*
- * void aesni_enc(struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ * void aesni_enc(const void *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_enc)
 	FRAME_BEGIN
@@ -2137,7 +2137,7 @@ _aesni_enc4:
 ENDPROC(_aesni_enc4)
 
 /*
- * void aesni_dec (struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src)
+ * void aesni_dec (const void *ctx, u8 *dst, const u8 *src)
  */
 ENTRY(aesni_dec)
 	FRAME_BEGIN
@@ -2726,8 +2726,8 @@ ENDPROC(aesni_ctr_enc)
 	pxor CTR, IV;
 
 /*
- * void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
- *			 bool enc, u8 *iv)
+ * void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *dst,
+ *			 const u8 *src, bool enc, le128 *iv)
  */
 ENTRY(aesni_xts_crypt8)
 	FRAME_BEGIN
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 3e707e81afdb..670f8fcf2544 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -83,10 +83,8 @@ struct gcm_context_data {
 
 asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 			     unsigned int key_len);
-asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
-asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
-			  const u8 *in);
+asmlinkage void aesni_enc(const void *ctx, u8 *out, const u8 *in);
+asmlinkage void aesni_dec(const void *ctx, u8 *out, const u8 *in);
 asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len);
 asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
@@ -106,8 +104,8 @@ static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
-				 const u8 *in, bool enc, u8 *iv);
+asmlinkage void aesni_xts_crypt8(const struct crypto_aes_ctx *ctx, u8 *out,
+				 const u8 *in, bool enc, le128 *iv);
 
 /* asmlinkage void aesni_gcm_enc()
  * void *ctx,  AES Key schedule. Starts on a 16 byte boundary.
@@ -550,29 +548,24 @@ static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 
-static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
+static void aesni_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_enc(ctx, out, in);
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_enc);
 }
 
-static void aesni_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_enc));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, aesni_dec);
 }
 
-static void aesni_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_enc8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv, GLUE_FUNC_CAST(aesni_dec));
+	aesni_xts_crypt8(ctx, dst, src, true, iv);
 }
 
-static void aesni_xts_enc8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void aesni_xts_dec8(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, true, (u8 *)iv);
-}
-
-static void aesni_xts_dec8(void *ctx, u128 *dst, const u128 *src, le128 *iv)
-{
-	aesni_xts_crypt8(ctx, (u8 *)dst, (const u8 *)src, false, (u8 *)iv);
+	aesni_xts_crypt8(ctx, dst, src, false, iv);
 }
 
 static const struct common_glue_ctx aesni_enc_xts = {
@@ -581,10 +574,10 @@ static const struct common_glue_ctx aesni_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc8) }
+		.fn_u = { .xts = aesni_xts_enc8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_enc) }
+		.fn_u = { .xts = aesni_xts_enc }
 	} }
 };
 
@@ -594,10 +587,10 @@ static const struct common_glue_ctx aesni_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec8) }
+		.fn_u = { .xts = aesni_xts_dec8 }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(aesni_xts_dec) }
+		.fn_u = { .xts = aesni_xts_dec }
 	} }
 };
 
@@ -606,8 +599,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&aesni_enc_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+	return glue_xts_req_128bit(&aesni_enc_xts, req, aesni_enc,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx),
 				   false);
@@ -618,8 +610,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&aesni_dec_xts, req,
-				   XTS_TWEAK_CAST(aesni_xts_tweak),
+	return glue_xts_req_128bit(&aesni_dec_xts, req, aesni_enc,
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx),
 				   true);
diff --git a/arch/x86/crypto/camellia_aesni_avx2_glue.c b/arch/x86/crypto/camellia_aesni_avx2_glue.c
index a4f00128ea55..a8cc2c83fe1b 100644
--- a/arch/x86/crypto/camellia_aesni_avx2_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx2_glue.c
@@ -19,20 +19,17 @@
 #define CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS 32
 
 /* 32-way AVX2/AES-NI parallel cipher functions */
-asmlinkage void camellia_ecb_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_enc_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_32way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void camellia_cbc_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_32way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void camellia_cbc_dec_32way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_32way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 
-asmlinkage void camellia_xts_enc_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_32way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_enc_32way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_32way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 
 static const struct common_glue_ctx camellia_enc = {
 	.num_funcs = 4,
@@ -40,16 +37,16 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_32way) }
+		.fn_u = { .ecb = camellia_ecb_enc_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -59,16 +56,16 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_32way) }
+		.fn_u = { .ctr = camellia_ctr_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -78,13 +75,13 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_32way) }
+		.fn_u = { .xts = camellia_xts_enc_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -94,16 +91,16 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_32way) }
+		.fn_u = { .ecb = camellia_ecb_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -113,16 +110,16 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_32way) }
+		.fn_u = { .cbc = camellia_cbc_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -132,13 +129,13 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_AVX2_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_32way) }
+		.fn_u = { .xts = camellia_xts_dec_32way }
 	}, {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -161,8 +158,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -180,8 +176,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -190,8 +185,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/arch/x86/crypto/camellia_aesni_avx_glue.c b/arch/x86/crypto/camellia_aesni_avx_glue.c
index f28d282779b8..31a82a79f4ac 100644
--- a/arch/x86/crypto/camellia_aesni_avx_glue.c
+++ b/arch/x86/crypto/camellia_aesni_avx_glue.c
@@ -18,41 +18,36 @@
 #define CAMELLIA_AESNI_PARALLEL_BLOCKS 16
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_enc_16way);
 
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_ecb_dec_16way);
 
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_cbc_dec_16way);
 
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_ctr_16way);
 
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_enc_16way);
 
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
 EXPORT_SYMBOL_GPL(camellia_xts_dec_16way);
 
-void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_enc_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_enc);
 
-void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(camellia_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, camellia_dec_blk);
 }
 EXPORT_SYMBOL_GPL(camellia_xts_dec);
 
@@ -62,13 +57,13 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_enc_16way) }
+		.fn_u = { .ecb = camellia_ecb_enc_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -78,13 +73,13 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_ctr_16way) }
+		.fn_u = { .ctr = camellia_ctr_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -94,10 +89,10 @@ static const struct common_glue_ctx camellia_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc_16way) }
+		.fn_u = { .xts = camellia_xts_enc_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_enc) }
+		.fn_u = { .xts = camellia_xts_enc }
 	} }
 };
 
@@ -107,13 +102,13 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_ecb_dec_16way) }
+		.fn_u = { .ecb = camellia_ecb_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -123,13 +118,13 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_cbc_dec_16way) }
+		.fn_u = { .cbc = camellia_cbc_dec_16way }
 	}, {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -139,10 +134,10 @@ static const struct common_glue_ctx camellia_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAMELLIA_AESNI_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec_16way) }
+		.fn_u = { .xts = camellia_xts_dec_16way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(camellia_xts_dec) }
+		.fn_u = { .xts = camellia_xts_dec }
 	} }
 };
 
@@ -165,8 +160,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -206,8 +200,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_enc_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_enc_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -216,8 +209,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct camellia_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&camellia_dec_xts, req,
-				   XTS_TWEAK_CAST(camellia_enc_blk),
+	return glue_xts_req_128bit(&camellia_dec_xts, req, camellia_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/arch/x86/crypto/camellia_glue.c b/arch/x86/crypto/camellia_glue.c
index 7c62db56ffe1..5f3ed5af68d7 100644
--- a/arch/x86/crypto/camellia_glue.c
+++ b/arch/x86/crypto/camellia_glue.c
@@ -18,19 +18,17 @@
 #include <asm/crypto/glue_helper.h>
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
+				   bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
+					bool xor);
 EXPORT_SYMBOL_GPL(__camellia_enc_blk_2way);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 EXPORT_SYMBOL_GPL(camellia_dec_blk_2way);
 
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
@@ -1267,8 +1265,10 @@ static int camellia_setkey_skcipher(struct crypto_skcipher *tfm, const u8 *key,
 	return camellia_setkey(&tfm->base, key, key_len);
 }
 
-void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
+void camellia_decrypt_cbc_2way(const void *ctx, u8 *d, const u8 *s)
 {
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	u128 iv = *src;
 
 	camellia_dec_blk_2way(ctx, (u8 *)dst, (u8 *)src);
@@ -1277,9 +1277,11 @@ void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(camellia_decrypt_cbc_2way);
 
-void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src)
 		*dst = *src;
@@ -1291,9 +1293,11 @@ void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(camellia_crypt_ctr);
 
-void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void camellia_crypt_ctr_2way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblks[2];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src) {
 		dst[0] = src[0];
@@ -1315,10 +1319,10 @@ static const struct common_glue_ctx camellia_enc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk_2way) }
+		.fn_u = { .ecb = camellia_enc_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_enc_blk) }
+		.fn_u = { .ecb = camellia_enc_blk }
 	} }
 };
 
@@ -1328,10 +1332,10 @@ static const struct common_glue_ctx camellia_ctr = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr_2way) }
+		.fn_u = { .ctr = camellia_crypt_ctr_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(camellia_crypt_ctr) }
+		.fn_u = { .ctr = camellia_crypt_ctr }
 	} }
 };
 
@@ -1341,10 +1345,10 @@ static const struct common_glue_ctx camellia_dec = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk_2way) }
+		.fn_u = { .ecb = camellia_dec_blk_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .ecb = camellia_dec_blk }
 	} }
 };
 
@@ -1354,10 +1358,10 @@ static const struct common_glue_ctx camellia_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 2,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_decrypt_cbc_2way) }
+		.fn_u = { .cbc = camellia_decrypt_cbc_2way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(camellia_dec_blk) }
+		.fn_u = { .cbc = camellia_dec_blk }
 	} }
 };
 
@@ -1373,8 +1377,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(camellia_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(camellia_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/crypto/cast6_avx_glue.c b/arch/x86/crypto/cast6_avx_glue.c
index a8a38fffb4a9..da5297475f9e 100644
--- a/arch/x86/crypto/cast6_avx_glue.c
+++ b/arch/x86/crypto/cast6_avx_glue.c
@@ -20,20 +20,17 @@
 
 #define CAST6_PARALLEL_BLOCKS 8
 
-asmlinkage void cast6_ecb_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ecb_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-
-asmlinkage void cast6_cbc_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src);
-asmlinkage void cast6_ctr_8way(struct cast6_ctx *ctx, u8 *dst, const u8 *src,
+asmlinkage void cast6_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void cast6_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void cast6_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
 
-asmlinkage void cast6_xts_enc_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-asmlinkage void cast6_xts_dec_8way(struct cast6_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
+asmlinkage void cast6_xts_enc_8way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+asmlinkage void cast6_xts_dec_8way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
 
 static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 				 const u8 *key, unsigned int keylen)
@@ -41,21 +38,21 @@ static int cast6_setkey_skcipher(struct crypto_skcipher *tfm,
 	return cast6_setkey(&tfm->base, key, keylen);
 }
 
-static void cast6_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_encrypt);
 }
 
-static void cast6_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__cast6_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __cast6_decrypt);
 }
 
-static void cast6_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void cast6_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -70,10 +67,10 @@ static const struct common_glue_ctx cast6_enc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_enc_8way) }
+		.fn_u = { .ecb = cast6_ecb_enc_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_encrypt) }
+		.fn_u = { .ecb = __cast6_encrypt }
 	} }
 };
 
@@ -83,10 +80,10 @@ static const struct common_glue_ctx cast6_ctr = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_ctr_8way) }
+		.fn_u = { .ctr = cast6_ctr_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(cast6_crypt_ctr) }
+		.fn_u = { .ctr = cast6_crypt_ctr }
 	} }
 };
 
@@ -96,10 +93,10 @@ static const struct common_glue_ctx cast6_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc_8way) }
+		.fn_u = { .xts = cast6_xts_enc_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_enc) }
+		.fn_u = { .xts = cast6_xts_enc }
 	} }
 };
 
@@ -109,10 +106,10 @@ static const struct common_glue_ctx cast6_dec = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(cast6_ecb_dec_8way) }
+		.fn_u = { .ecb = cast6_ecb_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .ecb = __cast6_decrypt }
 	} }
 };
 
@@ -122,10 +119,10 @@ static const struct common_glue_ctx cast6_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(cast6_cbc_dec_8way) }
+		.fn_u = { .cbc = cast6_cbc_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__cast6_decrypt) }
+		.fn_u = { .cbc = __cast6_decrypt }
 	} }
 };
 
@@ -135,10 +132,10 @@ static const struct common_glue_ctx cast6_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = CAST6_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec_8way) }
+		.fn_u = { .xts = cast6_xts_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(cast6_xts_dec) }
+		.fn_u = { .xts = cast6_xts_dec }
 	} }
 };
 
@@ -154,8 +151,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__cast6_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__cast6_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -199,8 +195,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&cast6_enc_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+	return glue_xts_req_128bit(&cast6_enc_xts, req, __cast6_encrypt,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -209,8 +204,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct cast6_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&cast6_dec_xts, req,
-				   XTS_TWEAK_CAST(__cast6_encrypt),
+	return glue_xts_req_128bit(&cast6_dec_xts, req, __cast6_encrypt,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
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
 
diff --git a/arch/x86/crypto/serpent_avx2_glue.c b/arch/x86/crypto/serpent_avx2_glue.c
index 13fd8d3d2da0..f973ace44ad3 100644
--- a/arch/x86/crypto/serpent_avx2_glue.c
+++ b/arch/x86/crypto/serpent_avx2_glue.c
@@ -19,18 +19,16 @@
 #define SERPENT_AVX2_PARALLEL_BLOCKS 16
 
 /* 16-way AVX2 parallel cipher functions */
-asmlinkage void serpent_ecb_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_ecb_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src);
-asmlinkage void serpent_cbc_dec_16way(void *ctx, u128 *dst, const u128 *src);
+asmlinkage void serpent_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void serpent_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void serpent_ctr_16way(void *ctx, u128 *dst, const u128 *src,
+asmlinkage void serpent_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
 				  le128 *iv);
-asmlinkage void serpent_xts_enc_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_16way(struct serpent_ctx *ctx, u8 *dst,
-				      const u8 *src, le128 *iv);
+asmlinkage void serpent_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				      le128 *iv);
+asmlinkage void serpent_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				      le128 *iv);
 
 static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -44,13 +42,13 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_16way) }
+		.fn_u = { .ecb = serpent_ecb_enc_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -60,13 +58,13 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_16way) }
+		.fn_u = { .ctr = serpent_ctr_16way }
 	},  {
 		.num_blocks = 8,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -76,13 +74,13 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_16way) }
+		.fn_u = { .xts = serpent_xts_enc_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -92,13 +90,13 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_16way) }
+		.fn_u = { .ecb = serpent_ecb_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -108,13 +106,13 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_16way) }
+		.fn_u = { .cbc = serpent_cbc_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt }
 	} }
 };
 
@@ -124,13 +122,13 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = 16,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_16way) }
+		.fn_u = { .xts = serpent_xts_dec_16way }
 	}, {
 		.num_blocks = 8,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -146,8 +144,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -166,8 +163,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -176,8 +173,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_avx_glue.c b/arch/x86/crypto/serpent_avx_glue.c
index 7d3dca38a5a2..7806d1cbe854 100644
--- a/arch/x86/crypto/serpent_avx_glue.c
+++ b/arch/x86/crypto/serpent_avx_glue.c
@@ -20,33 +20,35 @@
 #include <asm/crypto/serpent-avx.h>
 
 /* 8-way parallel cipher functions */
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_enc_8way_avx);
 
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_ecb_dec_8way_avx);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 EXPORT_SYMBOL_GPL(serpent_cbc_dec_8way_avx);
 
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_ctr_8way_avx);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_enc_8way_avx);
 
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 EXPORT_SYMBOL_GPL(serpent_xts_dec_8way_avx);
 
-void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void __serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -56,17 +58,15 @@ void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(__serpent_crypt_ctr);
 
-void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_encrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_encrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_enc);
 
-void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(__serpent_decrypt));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, __serpent_decrypt);
 }
 EXPORT_SYMBOL_GPL(serpent_xts_dec);
 
@@ -102,10 +102,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_enc_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -115,10 +115,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_ctr_8way_avx) }
+		.fn_u = { .ctr = serpent_ctr_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(__serpent_crypt_ctr) }
+		.fn_u = { .ctr = __serpent_crypt_ctr }
 	} }
 };
 
@@ -128,10 +128,10 @@ static const struct common_glue_ctx serpent_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc_8way_avx) }
+		.fn_u = { .xts = serpent_xts_enc_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_enc) }
+		.fn_u = { .xts = serpent_xts_enc }
 	} }
 };
 
@@ -141,10 +141,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_ecb_dec_8way_avx) }
+		.fn_u = { .ecb = serpent_ecb_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -154,10 +154,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_cbc_dec_8way_avx) }
+		.fn_u = { .cbc = serpent_cbc_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt }
 	} }
 };
 
@@ -167,10 +167,10 @@ static const struct common_glue_ctx serpent_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec_8way_avx) }
+		.fn_u = { .xts = serpent_xts_dec_8way_avx }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(serpent_xts_dec) }
+		.fn_u = { .xts = serpent_xts_dec }
 	} }
 };
 
@@ -186,8 +186,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
-					   req);
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -206,8 +205,8 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_enc_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, false);
 }
 
 static int xts_decrypt(struct skcipher_request *req)
@@ -216,8 +215,8 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct serpent_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&serpent_dec_xts, req,
-				   XTS_TWEAK_CAST(__serpent_encrypt),
-				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
+				   __serpent_encrypt, &ctx->tweak_ctx,
+				   &ctx->crypt_ctx, true);
 }
 
 static struct skcipher_alg serpent_algs[] = {
diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 5fdf1931d069..4fed8d26b91a 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -31,9 +31,11 @@ static int serpent_setkey_skcipher(struct crypto_skcipher *tfm,
 	return __serpent_setkey(crypto_skcipher_ctx(tfm), key, keylen);
 }
 
-static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
+static void serpent_decrypt_cbc_xway(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[SERPENT_PARALLEL_BLOCKS - 1];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	unsigned int j;
 
 	for (j = 0; j < SERPENT_PARALLEL_BLOCKS - 1; j++)
@@ -45,9 +47,11 @@ static void serpent_decrypt_cbc_xway(void *ctx, u128 *dst, const u128 *src)
 		u128_xor(dst + (j + 1), dst + (j + 1), ivs + j);
 }
 
-static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void serpent_crypt_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	le128_to_be128(&ctrblk, iv);
 	le128_inc(iv);
@@ -56,10 +60,12 @@ static void serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 	u128_xor(dst, src, (u128 *)&ctrblk);
 }
 
-static void serpent_crypt_ctr_xway(void *ctx, u128 *dst, const u128 *src,
+static void serpent_crypt_ctr_xway(const void *ctx, u8 *d, const u8 *s,
 				   le128 *iv)
 {
 	be128 ctrblks[SERPENT_PARALLEL_BLOCKS];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 	unsigned int i;
 
 	for (i = 0; i < SERPENT_PARALLEL_BLOCKS; i++) {
@@ -79,10 +85,10 @@ static const struct common_glue_ctx serpent_enc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_enc_blk_xway) }
+		.fn_u = { .ecb = serpent_enc_blk_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_encrypt) }
+		.fn_u = { .ecb = __serpent_encrypt }
 	} }
 };
 
@@ -92,10 +98,10 @@ static const struct common_glue_ctx serpent_ctr = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr_xway) }
+		.fn_u = { .ctr = serpent_crypt_ctr_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(serpent_crypt_ctr) }
+		.fn_u = { .ctr = serpent_crypt_ctr }
 	} }
 };
 
@@ -105,10 +111,10 @@ static const struct common_glue_ctx serpent_dec = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(serpent_dec_blk_xway) }
+		.fn_u = { .ecb = serpent_dec_blk_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .ecb = __serpent_decrypt }
 	} }
 };
 
@@ -118,10 +124,10 @@ static const struct common_glue_ctx serpent_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = SERPENT_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(serpent_decrypt_cbc_xway) }
+		.fn_u = { .cbc = serpent_decrypt_cbc_xway }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(__serpent_decrypt) }
+		.fn_u = { .cbc = __serpent_decrypt }
 	} }
 };
 
@@ -137,7 +143,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(__serpent_encrypt),
+	return glue_cbc_encrypt_req_128bit(__serpent_encrypt,
 					   req);
 }
 
diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index d561c821788b..3b36e97ec7ab 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -22,20 +22,17 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
+asmlinkage void twofish_ecb_enc_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ecb_dec_8way(const void *ctx, u8 *dst, const u8 *src);
 
-asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
-				 const u8 *src, le128 *iv);
+asmlinkage void twofish_cbc_dec_8way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_ctr_8way(const void *ctx, u8 *dst, const u8 *src,
+				 le128 *iv);
 
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void twofish_xts_enc_8way(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
+asmlinkage void twofish_xts_dec_8way(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -43,22 +40,19 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void twofish_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_enc_blk);
 }
 
-static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+static void twofish_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_dec_blk);
 }
 
 struct twofish_xts_ctx {
@@ -93,13 +87,13 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
+		.fn_u = { .ecb = twofish_ecb_enc_8way }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk }
 	} }
 };
 
@@ -109,13 +103,13 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
+		.fn_u = { .ctr = twofish_ctr_8way }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr }
 	} }
 };
 
@@ -125,10 +119,10 @@ static const struct common_glue_ctx twofish_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
+		.fn_u = { .xts = twofish_xts_enc_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
+		.fn_u = { .xts = twofish_xts_enc }
 	} }
 };
 
@@ -138,13 +132,13 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
+		.fn_u = { .ecb = twofish_ecb_dec_8way }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk }
 	} }
 };
 
@@ -154,13 +148,13 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
+		.fn_u = { .cbc = twofish_cbc_dec_8way }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk }
 	} }
 };
 
@@ -170,10 +164,10 @@ static const struct common_glue_ctx twofish_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
+		.fn_u = { .xts = twofish_xts_dec_8way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
+		.fn_u = { .xts = twofish_xts_dec }
 	} }
 };
 
@@ -189,8 +183,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -208,8 +201,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct twofish_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&twofish_enc_xts, req,
-				   XTS_TWEAK_CAST(twofish_enc_blk),
+	return glue_xts_req_128bit(&twofish_enc_xts, req, twofish_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, false);
 }
 
@@ -218,8 +210,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct twofish_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	return glue_xts_req_128bit(&twofish_dec_xts, req,
-				   XTS_TWEAK_CAST(twofish_enc_blk),
+	return glue_xts_req_128bit(&twofish_dec_xts, req, twofish_enc_blk,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx, true);
 }
 
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 1dc9e29f221e..768af6075479 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -25,21 +25,22 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, false);
 }
 
-static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
+static inline void twofish_enc_blk_xor_3way(const void *ctx, u8 *dst,
 					    const u8 *src)
 {
 	__twofish_enc_blk_3way(ctx, dst, src, true);
 }
 
-void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
+void twofish_dec_blk_cbc_3way(const void *ctx, u8 *d, const u8 *s)
 {
 	u128 ivs[2];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	ivs[0] = src[0];
 	ivs[1] = src[1];
@@ -51,9 +52,11 @@ void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void twofish_enc_blk_ctr(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblk;
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src)
 		*dst = *src;
@@ -66,10 +69,11 @@ void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 }
 EXPORT_SYMBOL_GPL(twofish_enc_blk_ctr);
 
-void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
-			      le128 *iv)
+void twofish_enc_blk_ctr_3way(const void *ctx, u8 *d, const u8 *s, le128 *iv)
 {
 	be128 ctrblks[3];
+	u128 *dst = (u128 *)d;
+	const u128 *src = (const u128 *)s;
 
 	if (dst != src) {
 		dst[0] = src[0];
@@ -94,10 +98,10 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk }
 	} }
 };
 
@@ -107,10 +111,10 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr }
 	} }
 };
 
@@ -120,10 +124,10 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk }
 	} }
 };
 
@@ -133,10 +137,10 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk }
 	} }
 };
 
@@ -152,8 +156,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index a5d86fc0593f..f1592619dd65 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -32,65 +32,60 @@ extern int xts_camellia_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			       unsigned int keylen);
 
 /* regular block cipher functions */
-asmlinkage void __camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk(struct camellia_ctx *ctx, u8 *dst,
-				 const u8 *src);
+asmlinkage void __camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src,
+				   bool xor);
+asmlinkage void camellia_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 2-way parallel cipher functions */
-asmlinkage void __camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src, bool xor);
-asmlinkage void camellia_dec_blk_2way(struct camellia_ctx *ctx, u8 *dst,
-				      const u8 *src);
+asmlinkage void __camellia_enc_blk_2way(const void *ctx, u8 *dst, const u8 *src,
+					bool xor);
+asmlinkage void camellia_dec_blk_2way(const void *ctx, u8 *dst, const u8 *src);
 
 /* 16-way parallel cipher functions (avx/aes-ni) */
-asmlinkage void camellia_ecb_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ecb_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-
-asmlinkage void camellia_cbc_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src);
-asmlinkage void camellia_ctr_16way(struct camellia_ctx *ctx, u8 *dst,
-				   const u8 *src, le128 *iv);
-
-asmlinkage void camellia_xts_enc_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-asmlinkage void camellia_xts_dec_16way(struct camellia_ctx *ctx, u8 *dst,
-				       const u8 *src, le128 *iv);
-
-static inline void camellia_enc_blk(struct camellia_ctx *ctx, u8 *dst,
-				    const u8 *src)
+asmlinkage void camellia_ecb_enc_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ecb_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+
+asmlinkage void camellia_cbc_dec_16way(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void camellia_ctr_16way(const void *ctx, u8 *dst, const u8 *src,
+				   le128 *iv);
+
+asmlinkage void camellia_xts_enc_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+asmlinkage void camellia_xts_dec_16way(const void *ctx, u8 *dst, const u8 *src,
+				       le128 *iv);
+
+static inline void camellia_enc_blk(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor(struct camellia_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void camellia_enc_blk_xor(const void *ctx, u8 *dst, const u8 *src)
 {
 	__camellia_enc_blk(ctx, dst, src, true);
 }
 
-static inline void camellia_enc_blk_2way(struct camellia_ctx *ctx, u8 *dst,
+static inline void camellia_enc_blk_2way(const void *ctx, u8 *dst,
 					 const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, false);
 }
 
-static inline void camellia_enc_blk_xor_2way(struct camellia_ctx *ctx, u8 *dst,
+static inline void camellia_enc_blk_xor_2way(const void *ctx, u8 *dst,
 					     const u8 *src)
 {
 	__camellia_enc_blk_2way(ctx, dst, src, true);
 }
 
 /* glue helpers */
-extern void camellia_decrypt_cbc_2way(void *ctx, u128 *dst, const u128 *src);
-extern void camellia_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+extern void camellia_decrypt_cbc_2way(const void *ctx, u8 *dst, const u8 *src);
+extern void camellia_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
 			       le128 *iv);
-extern void camellia_crypt_ctr_2way(void *ctx, u128 *dst, const u128 *src,
+extern void camellia_crypt_ctr_2way(const void *ctx, u8 *dst, const u8 *src,
 				    le128 *iv);
 
-extern void camellia_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
-extern void camellia_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void camellia_xts_enc(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
+extern void camellia_xts_dec(const void *ctx, u8 *dst, const u8 *src,
+			     le128 *iv);
 
 #endif /* ASM_X86_CAMELLIA_H */
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 8d4a8e1226ee..777c0f63418c 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -11,18 +11,13 @@
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
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
@@ -116,7 +111,8 @@ extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
 			       void *crypt_ctx, bool decrypt);
 
-extern void glue_xts_crypt_128bit_one(void *ctx, u128 *dst, const u128 *src,
-				      le128 *iv, common_glue_func_t fn);
+extern void glue_xts_crypt_128bit_one(const void *ctx, u8 *dst,
+				      const u8 *src, le128 *iv,
+				      common_glue_func_t fn);
 
 #endif /* _CRYPTO_GLUE_HELPER_H */
diff --git a/arch/x86/include/asm/crypto/serpent-avx.h b/arch/x86/include/asm/crypto/serpent-avx.h
index db7c9cc32234..251c2c89d7cf 100644
--- a/arch/x86/include/asm/crypto/serpent-avx.h
+++ b/arch/x86/include/asm/crypto/serpent-avx.h
@@ -15,26 +15,26 @@ struct serpent_xts_ctx {
 	struct serpent_ctx crypt_ctx;
 };
 
-asmlinkage void serpent_ecb_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ecb_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_ecb_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
 
-asmlinkage void serpent_cbc_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_cbc_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src);
-asmlinkage void serpent_ctr_8way_avx(struct serpent_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+asmlinkage void serpent_ctr_8way_avx(const void *ctx, u8 *dst, const u8 *src,
+				     le128 *iv);
 
-asmlinkage void serpent_xts_enc_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_enc_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
-asmlinkage void serpent_xts_dec_8way_avx(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_xts_dec_8way_avx(const void *ctx, u8 *dst,
 					 const u8 *src, le128 *iv);
 
-extern void __serpent_crypt_ctr(void *ctx, u128 *dst, const u128 *src,
+extern void __serpent_crypt_ctr(const void *ctx, u8 *dst, const u8 *src,
 				le128 *iv);
 
-extern void serpent_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv);
-extern void serpent_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv);
+extern void serpent_xts_enc(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
+extern void serpent_xts_dec(const void *ctx, u8 *dst, const u8 *src, le128 *iv);
 
 extern int xts_serpent_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			      unsigned int keylen);
diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
index 1a345e8a7496..860ca248914b 100644
--- a/arch/x86/include/asm/crypto/serpent-sse2.h
+++ b/arch/x86/include/asm/crypto/serpent-sse2.h
@@ -9,25 +9,23 @@
 
 #define SERPENT_PARALLEL_BLOCKS 4
 
-asmlinkage void __serpent_enc_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_4way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_4way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-					    const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_4way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-					const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_4way(ctx, dst, src);
 }
@@ -36,25 +34,23 @@ static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
 
 #define SERPENT_PARALLEL_BLOCKS 8
 
-asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void __serpent_enc_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				       const u8 *src, bool xor);
-asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
+asmlinkage void serpent_dec_blk_8way(const struct serpent_ctx *ctx, u8 *dst,
 				     const u8 *src);
 
-static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_enc_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, false);
 }
 
-static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
-				       const u8 *src)
+static inline void serpent_enc_blk_xway_xor(const struct serpent_ctx *ctx,
+					    u8 *dst, const u8 *src)
 {
 	__serpent_enc_blk_8way(ctx, dst, src, true);
 }
 
-static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
-				   const u8 *src)
+static inline void serpent_dec_blk_xway(const void *ctx, u8 *dst, const u8 *src)
 {
 	serpent_dec_blk_8way(ctx, dst, src);
 }
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index f618bf272b90..2c377a8042e1 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -7,22 +7,19 @@
 #include <crypto/b128ops.h>
 
 /* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+asmlinkage void twofish_enc_blk(const void *ctx, u8 *dst, const u8 *src);
+asmlinkage void twofish_dec_blk(const void *ctx, u8 *dst, const u8 *src);
 
 /* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
+asmlinkage void __twofish_enc_blk_3way(const void *ctx, u8 *dst, const u8 *src,
+				       bool xor);
+asmlinkage void twofish_dec_blk_3way(const void *ctx, u8 *dst, const u8 *src);
 
 /* helpers from twofish_x86_64-3way module */
-extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
-extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
+extern void twofish_dec_blk_cbc_3way(const void *ctx, u8 *dst, const u8 *src);
+extern void twofish_enc_blk_ctr(const void *ctx, u8 *dst, const u8 *src,
 				le128 *iv);
-extern void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
+extern void twofish_enc_blk_ctr_3way(const void *ctx, u8 *dst, const u8 *src,
 				     le128 *iv);
 
 #endif /* ASM_X86_TWOFISH_H */
diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index a8248f8e2777..85328522c5ca 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -154,7 +154,7 @@ int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 EXPORT_SYMBOL_GPL(cast6_setkey);
 
 /*forward quad round*/
-static inline void Q(u32 *block, u8 *Kr, u32 *Km)
+static inline void Q(u32 *block, const u8 *Kr, const u32 *Km)
 {
 	u32 I;
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
@@ -164,7 +164,7 @@ static inline void Q(u32 *block, u8 *Kr, u32 *Km)
 }
 
 /*reverse quad round*/
-static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
+static inline void QBAR(u32 *block, const u8 *Kr, const u32 *Km)
 {
 	u32 I;
 	block[3] ^= F1(block[0], Kr[3], Km[3]);
@@ -173,13 +173,14 @@ static inline void QBAR(u32 *block, u8 *Kr, u32 *Km)
 	block[2] ^= F1(block[3], Kr[0], Km[0]);
 }
 
-void __cast6_encrypt(struct cast6_ctx *c, u8 *outbuf, const u8 *inbuf)
+void __cast6_encrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
+	const struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 *Km;
-	u8 *Kr;
+	const u32 *Km;
+	const u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
@@ -211,13 +212,14 @@ static void cast6_encrypt(struct crypto_tfm *tfm, u8 *outbuf, const u8 *inbuf)
 	__cast6_encrypt(crypto_tfm_ctx(tfm), outbuf, inbuf);
 }
 
-void __cast6_decrypt(struct cast6_ctx *c, u8 *outbuf, const u8 *inbuf)
+void __cast6_decrypt(const void *ctx, u8 *outbuf, const u8 *inbuf)
 {
+	const struct cast6_ctx *c = ctx;
 	const __be32 *src = (const __be32 *)inbuf;
 	__be32 *dst = (__be32 *)outbuf;
 	u32 block[4];
-	u32 *Km;
-	u8 *Kr;
+	const u32 *Km;
+	const u8 *Kr;
 
 	block[0] = be32_to_cpu(src[0]);
 	block[1] = be32_to_cpu(src[1]);
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 56fa665a4f01..492c1d0bfe06 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -449,8 +449,9 @@ int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
 }
 EXPORT_SYMBOL_GPL(serpent_setkey);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_encrypt(const void *c, u8 *dst, const u8 *src)
 {
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
@@ -514,8 +515,9 @@ static void serpent_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	__serpent_encrypt(ctx, dst, src);
 }
 
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src)
+void __serpent_decrypt(const void *c, u8 *dst, const u8 *src)
 {
+	const struct serpent_ctx *ctx = c;
 	const u32 *k = ctx->expkey;
 	const __le32 *s = (const __le32 *)src;
 	__le32	*d = (__le32 *)dst;
diff --git a/include/crypto/cast6.h b/include/crypto/cast6.h
index c71f6ef47f0f..4c8d0c72f78d 100644
--- a/include/crypto/cast6.h
+++ b/include/crypto/cast6.h
@@ -19,7 +19,7 @@ int __cast6_setkey(struct cast6_ctx *ctx, const u8 *key,
 		   unsigned int keylen, u32 *flags);
 int cast6_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __cast6_encrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
-void __cast6_decrypt(struct cast6_ctx *ctx, u8 *dst, const u8 *src);
+void __cast6_encrypt(const void *ctx, u8 *dst, const u8 *src);
+void __cast6_decrypt(const void *ctx, u8 *dst, const u8 *src);
 
 #endif
diff --git a/include/crypto/serpent.h b/include/crypto/serpent.h
index 7dd780c5d058..75c7eaa20853 100644
--- a/include/crypto/serpent.h
+++ b/include/crypto/serpent.h
@@ -22,7 +22,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 		     unsigned int keylen);
 int serpent_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen);
 
-void __serpent_encrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
-void __serpent_decrypt(struct serpent_ctx *ctx, u8 *dst, const u8 *src);
+void __serpent_encrypt(const void *ctx, u8 *dst, const u8 *src);
+void __serpent_decrypt(const void *ctx, u8 *dst, const u8 *src);
 
 #endif
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1


-- 
Kees Cook
