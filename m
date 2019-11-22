Return-Path: <SRS0=W9N7=ZO=lists.openwall.com=kernel-hardening-return-17428-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCBBC432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:05:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AF5D9204FD
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 01:05:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gv0IHxYg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF5D9204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17428-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20176 invoked by uid 550); 22 Nov 2019 01:04:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20001 invoked from network); 22 Nov 2019 01:03:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qTi7QKHxCikdI0tmHa1luqmE/dJyaW51e2pyeW/8+4I=;
        b=gv0IHxYgfU3jIYGq3xFvZ8xp9OxfrBp4+7jfUKcfcrhhbJdlyYjWolIzF4epOQpN4X
         fNg94wGa+gSO9dMc6atDoouxqS4j6oAdZY8lr0qRdfOhlwwPFlkIViW+ItPVahztTGHj
         5AUzDDT48TWvJnBVN7t2fyZGN0AXrNZvdtnNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qTi7QKHxCikdI0tmHa1luqmE/dJyaW51e2pyeW/8+4I=;
        b=qX5z48fmGzNmSCprHySwCMD+gD2iRv6E/lQWD7NKlLQxZNBncjazL8HWPbif2Cc1jZ
         t1Mg7CRSJUV6XjFWfJYNZsgkZ9scsahJVvjaEEC/ePJadEJGJvSnWkxOg7+qBTfR98X6
         Pw7HD3k7g1MbWu7wLF5HPgEnB3k79Cj0+fpy+YnFqfAFG6VQIJat284gVCD60Hvw0w4w
         IvShkTpuiscxBvxeQ1148isExQKPBc+d7ypNxLvO/e/NWf/a11m08K5TIPqOwq1EGp+r
         /yeXzHcxUG+mnndwhUZI+OQCYAsLZqy3EPvd/aDxD+C8ks64xAOKlej5geHb/iFaPgkx
         3tUw==
X-Gm-Message-State: APjAAAVpXpGWTfcwGc6Bg3cu4PR9DyEbmZjYtaLF0chWR6RzZ74Uo207
	7iIHs7Ujkdp6K6cwW7bl+Tz1qA==
X-Google-Smtp-Source: APXvYqxnkbBh37NiGw48teVpABuD2V3PAJNIx1cE2AHYBTVQLvihkQjsd06KPVNFwVc2VbIUPh8w2g==
X-Received: by 2002:a17:90a:db43:: with SMTP id u3mr15428691pjx.56.1574384626103;
        Thu, 21 Nov 2019 17:03:46 -0800 (PST)
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
Subject: [PATCH v6 8/8] crypto, x86/sha: Eliminate casts on asm implementations
Date: Thu, 21 Nov 2019 17:03:34 -0800
Message-Id: <20191122010334.12081-9-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
References: <20191122010334.12081-1-keescook@chromium.org>

In order to avoid CFI function prototype mismatches, this removes the
casts on assembly implementations of sha1/256/512 accelerators. The
safety checks from BUILD_BUG_ON() remain.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/sha1_ssse3_asm.S    | 10 +++--
 arch/x86/crypto/sha1_ssse3_glue.c   | 64 ++++++++++++-----------------
 arch/x86/crypto/sha256-ssse3-asm.S  |  4 +-
 arch/x86/crypto/sha256_ssse3_glue.c | 34 +++++++--------
 arch/x86/crypto/sha512-ssse3-asm.S  |  4 +-
 arch/x86/crypto/sha512_ssse3_glue.c | 31 +++++++-------
 6 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/arch/x86/crypto/sha1_ssse3_asm.S b/arch/x86/crypto/sha1_ssse3_asm.S
index 99c5b8c4dc38..b6443979a60b 100644
--- a/arch/x86/crypto/sha1_ssse3_asm.S
+++ b/arch/x86/crypto/sha1_ssse3_asm.S
@@ -457,9 +457,13 @@ W_PRECALC_SSSE3
 	movdqu	\a,\b
 .endm
 
-/* SSSE3 optimized implementation:
- *  extern "C" void sha1_transform_ssse3(u32 *digest, const char *data, u32 *ws,
- *                                       unsigned int rounds);
+/*
+ * SSSE3 optimized implementation:
+ *
+ * extern "C" void sha1_transform_ssse3(struct sha1_state *digest,
+ *					const u8 *data, int rounds);
+ *
+ * Note that struct sha1_state is assumed to begin with u32 state[5].
  */
 SHA1_VECTOR_ASM     sha1_transform_ssse3
 
diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 639d4c2fd6a8..f2864a15a203 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -27,11 +27,8 @@
 #include <crypto/sha1_base.h>
 #include <asm/simd.h>
 
-typedef void (sha1_transform_fn)(u32 *digest, const char *data,
-				unsigned int rounds);
-
 static int sha1_update(struct shash_desc *desc, const u8 *data,
-			     unsigned int len, sha1_transform_fn *sha1_xform)
+			     unsigned int len, sha1_block_fn *sha1_xform)
 {
 	struct sha1_state *sctx = shash_desc_ctx(desc);
 
@@ -39,48 +36,47 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	    (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
 		return crypto_sha1_update(desc, data, len);
 
-	/* make sure casting to sha1_block_fn() is safe */
+	/*
+	 * Make sure struct sha1_state begins directly with the SHA1
+	 * 160-bit internal state, as this is what the asm functions expect.
+	 */
 	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha1_base_do_update(desc, data, len,
-			    (sha1_block_fn *)sha1_xform);
+	sha1_base_do_update(desc, data, len, sha1_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
 static int sha1_finup(struct shash_desc *desc, const u8 *data,
-		      unsigned int len, u8 *out, sha1_transform_fn *sha1_xform)
+		      unsigned int len, u8 *out, sha1_block_fn *sha1_xform)
 {
 	if (!crypto_simd_usable())
 		return crypto_sha1_finup(desc, data, len, out);
 
 	kernel_fpu_begin();
 	if (len)
-		sha1_base_do_update(desc, data, len,
-				    (sha1_block_fn *)sha1_xform);
-	sha1_base_do_finalize(desc, (sha1_block_fn *)sha1_xform);
+		sha1_base_do_update(desc, data, len, sha1_xform);
+	sha1_base_do_finalize(desc, sha1_xform);
 	kernel_fpu_end();
 
 	return sha1_base_finish(desc, out);
 }
 
-asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
-				     unsigned int rounds);
+asmlinkage void sha1_transform_ssse3(struct sha1_state *digest,
+				     const u8 *data, int rounds);
 
 static int sha1_ssse3_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
-	return sha1_update(desc, data, len,
-			(sha1_transform_fn *) sha1_transform_ssse3);
+	return sha1_update(desc, data, len, sha1_transform_ssse3);
 }
 
 static int sha1_ssse3_finup(struct shash_desc *desc, const u8 *data,
 			      unsigned int len, u8 *out)
 {
-	return sha1_finup(desc, data, len, out,
-			(sha1_transform_fn *) sha1_transform_ssse3);
+	return sha1_finup(desc, data, len, out, sha1_transform_ssse3);
 }
 
 /* Add padding and return the message digest. */
@@ -119,21 +115,19 @@ static void unregister_sha1_ssse3(void)
 }
 
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
-				   unsigned int rounds);
+asmlinkage void sha1_transform_avx(struct sha1_state *digest,
+				   const u8 *data, int rounds);
 
 static int sha1_avx_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
-	return sha1_update(desc, data, len,
-			(sha1_transform_fn *) sha1_transform_avx);
+	return sha1_update(desc, data, len, sha1_transform_avx);
 }
 
 static int sha1_avx_finup(struct shash_desc *desc, const u8 *data,
 			      unsigned int len, u8 *out)
 {
-	return sha1_finup(desc, data, len, out,
-			(sha1_transform_fn *) sha1_transform_avx);
+	return sha1_finup(desc, data, len, out, sha1_transform_avx);
 }
 
 static int sha1_avx_final(struct shash_desc *desc, u8 *out)
@@ -190,8 +184,8 @@ static inline void unregister_sha1_avx(void) { }
 #if defined(CONFIG_AS_AVX2) && (CONFIG_AS_AVX)
 #define SHA1_AVX2_BLOCK_OPTSIZE	4	/* optimal 4*64 bytes of SHA1 blocks */
 
-asmlinkage void sha1_transform_avx2(u32 *digest, const char *data,
-				    unsigned int rounds);
+asmlinkage void sha1_transform_avx2(struct sha1_state *digest,
+				    const u8 *data, int rounds);
 
 static bool avx2_usable(void)
 {
@@ -203,8 +197,8 @@ static bool avx2_usable(void)
 	return false;
 }
 
-static void sha1_apply_transform_avx2(u32 *digest, const char *data,
-				unsigned int rounds)
+static void sha1_apply_transform_avx2(struct sha1_state *digest,
+				      const u8 *data, int rounds)
 {
 	/* Select the optimal transform based on data block size */
 	if (rounds >= SHA1_AVX2_BLOCK_OPTSIZE)
@@ -216,15 +210,13 @@ static void sha1_apply_transform_avx2(u32 *digest, const char *data,
 static int sha1_avx2_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
-	return sha1_update(desc, data, len,
-		(sha1_transform_fn *) sha1_apply_transform_avx2);
+	return sha1_update(desc, data, len, sha1_apply_transform_avx2);
 }
 
 static int sha1_avx2_finup(struct shash_desc *desc, const u8 *data,
 			      unsigned int len, u8 *out)
 {
-	return sha1_finup(desc, data, len, out,
-		(sha1_transform_fn *) sha1_apply_transform_avx2);
+	return sha1_finup(desc, data, len, out, sha1_apply_transform_avx2);
 }
 
 static int sha1_avx2_final(struct shash_desc *desc, u8 *out)
@@ -267,21 +259,19 @@ static inline void unregister_sha1_avx2(void) { }
 #endif
 
 #ifdef CONFIG_AS_SHA1_NI
-asmlinkage void sha1_ni_transform(u32 *digest, const char *data,
-				   unsigned int rounds);
+asmlinkage void sha1_ni_transform(struct sha1_state *digest, const u8 *data,
+				  int rounds);
 
 static int sha1_ni_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len)
 {
-	return sha1_update(desc, data, len,
-		(sha1_transform_fn *) sha1_ni_transform);
+	return sha1_update(desc, data, len, sha1_ni_transform);
 }
 
 static int sha1_ni_finup(struct shash_desc *desc, const u8 *data,
 			      unsigned int len, u8 *out)
 {
-	return sha1_finup(desc, data, len, out,
-		(sha1_transform_fn *) sha1_ni_transform);
+	return sha1_finup(desc, data, len, out, sha1_ni_transform);
 }
 
 static int sha1_ni_final(struct shash_desc *desc, u8 *out)
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index c6c05ed2c16a..a3ea5f9b0522 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -347,8 +347,10 @@ a = TMP_
 .endm
 
 ########################################################################
-## void sha256_transform_ssse3(void *input_data, UINT32 digest[8], UINT64 num_blks)
+## void sha256_transform_ssse3(struct sha1_state *digest, const u8 *data,
+##			       int rounds);
 ## arg 1 : pointer to digest
+##	   (struct sha256_state is assumed to begin with u32 state[8])
 ## arg 2 : pointer to input data
 ## arg 3 : Num blocks
 ########################################################################
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index f9aff31fe59e..08ec76ae4de7 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -41,12 +41,11 @@
 #include <linux/string.h>
 #include <asm/simd.h>
 
-asmlinkage void sha256_transform_ssse3(u32 *digest, const char *data,
-				       u64 rounds);
-typedef void (sha256_transform_fn)(u32 *digest, const char *data, u64 rounds);
+asmlinkage void sha256_transform_ssse3(struct sha256_state *digest,
+				       const u8 *data, int rounds);
 
 static int _sha256_update(struct shash_desc *desc, const u8 *data,
-			  unsigned int len, sha256_transform_fn *sha256_xform)
+			  unsigned int len, sha256_block_fn *sha256_xform)
 {
 	struct sha256_state *sctx = shash_desc_ctx(desc);
 
@@ -54,28 +53,29 @@ static int _sha256_update(struct shash_desc *desc, const u8 *data,
 	    (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
 		return crypto_sha256_update(desc, data, len);
 
-	/* make sure casting to sha256_block_fn() is safe */
+	/*
+	 * Make sure struct sha256_state begins directly with the SHA256
+	 * 256-bit internal state, as this is what the asm functions expect.
+	 */
 	BUILD_BUG_ON(offsetof(struct sha256_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha256_base_do_update(desc, data, len,
-			      (sha256_block_fn *)sha256_xform);
+	sha256_base_do_update(desc, data, len, sha256_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
 static int sha256_finup(struct shash_desc *desc, const u8 *data,
-	      unsigned int len, u8 *out, sha256_transform_fn *sha256_xform)
+	      unsigned int len, u8 *out, sha256_block_fn *sha256_xform)
 {
 	if (!crypto_simd_usable())
 		return crypto_sha256_finup(desc, data, len, out);
 
 	kernel_fpu_begin();
 	if (len)
-		sha256_base_do_update(desc, data, len,
-				      (sha256_block_fn *)sha256_xform);
-	sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_xform);
+		sha256_base_do_update(desc, data, len, sha256_xform);
+	sha256_base_do_finalize(desc, sha256_xform);
 	kernel_fpu_end();
 
 	return sha256_base_finish(desc, out);
@@ -145,8 +145,8 @@ static void unregister_sha256_ssse3(void)
 }
 
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha256_transform_avx(u32 *digest, const char *data,
-				     u64 rounds);
+asmlinkage void sha256_transform_avx(struct sha256_state *digest,
+				     const u8 *data, int blocks);
 
 static int sha256_avx_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
@@ -227,8 +227,8 @@ static inline void unregister_sha256_avx(void) { }
 #endif
 
 #if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
-asmlinkage void sha256_transform_rorx(u32 *digest, const char *data,
-				      u64 rounds);
+asmlinkage void sha256_transform_rorx(struct sha256_state *digest,
+				      const u8 *data, int rounds);
 
 static int sha256_avx2_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
@@ -307,8 +307,8 @@ static inline void unregister_sha256_avx2(void) { }
 #endif
 
 #ifdef CONFIG_AS_SHA256_NI
-asmlinkage void sha256_ni_transform(u32 *digest, const char *data,
-				   u64 rounds); /*unsigned int rounds);*/
+asmlinkage void sha256_ni_transform(struct sha256_state *digest,
+				    const u8 *data, int rounds);
 
 static int sha256_ni_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index 66bbd9058a90..840c749051ee 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -269,7 +269,9 @@ frame_size = frame_GPRSAVE + GPRSAVE_SIZE
 .endm
 
 ########################################################################
-# void sha512_transform_ssse3(void* D, const void* M, u64 L)#
+## void sha512_transform_ssse3(struct sha1_state *digest, const u8 *data,
+##			       int rounds);
+# (struct sha512_state is assumed to begin with u64 state[8])
 # Purpose: Updates the SHA512 digest stored at D with the message stored in M.
 # The size of the message pointed to by M must be an integer multiple of SHA512
 #   message blocks.
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 458356a3f124..19c9596534aa 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -39,13 +39,11 @@
 #include <crypto/sha512_base.h>
 #include <asm/simd.h>
 
-asmlinkage void sha512_transform_ssse3(u64 *digest, const char *data,
-				       u64 rounds);
-
-typedef void (sha512_transform_fn)(u64 *digest, const char *data, u64 rounds);
+asmlinkage void sha512_transform_ssse3(struct sha512_state *digest,
+				       const u8 *data, int rounds);
 
 static int sha512_update(struct shash_desc *desc, const u8 *data,
-		       unsigned int len, sha512_transform_fn *sha512_xform)
+		       unsigned int len, sha512_block_fn *sha512_xform)
 {
 	struct sha512_state *sctx = shash_desc_ctx(desc);
 
@@ -53,28 +51,29 @@ static int sha512_update(struct shash_desc *desc, const u8 *data,
 	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
 		return crypto_sha512_update(desc, data, len);
 
-	/* make sure casting to sha512_block_fn() is safe */
+	/*
+	 * Make sure struct sha512_state begins directly with the SHA512
+	 * 512-bit internal state, as this is what the asm functions expect.
+	 */
 	BUILD_BUG_ON(offsetof(struct sha512_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha512_base_do_update(desc, data, len,
-			      (sha512_block_fn *)sha512_xform);
+	sha512_base_do_update(desc, data, len, sha512_xform);
 	kernel_fpu_end();
 
 	return 0;
 }
 
 static int sha512_finup(struct shash_desc *desc, const u8 *data,
-	      unsigned int len, u8 *out, sha512_transform_fn *sha512_xform)
+	      unsigned int len, u8 *out, sha512_block_fn *sha512_xform)
 {
 	if (!crypto_simd_usable())
 		return crypto_sha512_finup(desc, data, len, out);
 
 	kernel_fpu_begin();
 	if (len)
-		sha512_base_do_update(desc, data, len,
-				      (sha512_block_fn *)sha512_xform);
-	sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_xform);
+		sha512_base_do_update(desc, data, len, sha512_xform);
+	sha512_base_do_finalize(desc, sha512_xform);
 	kernel_fpu_end();
 
 	return sha512_base_finish(desc, out);
@@ -144,8 +143,8 @@ static void unregister_sha512_ssse3(void)
 }
 
 #ifdef CONFIG_AS_AVX
-asmlinkage void sha512_transform_avx(u64 *digest, const char *data,
-				     u64 rounds);
+asmlinkage void sha512_transform_avx(struct sha512_state *digest,
+				     const u8 *data, int rounds);
 static bool avx_usable(void)
 {
 	if (!cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
@@ -225,8 +224,8 @@ static inline void unregister_sha512_avx(void) { }
 #endif
 
 #if defined(CONFIG_AS_AVX2) && defined(CONFIG_AS_AVX)
-asmlinkage void sha512_transform_rorx(u64 *digest, const char *data,
-				      u64 rounds);
+asmlinkage void sha512_transform_rorx(struct sha512_state *digest,
+				      const u8 *data, int rounds);
 
 static int sha512_avx2_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
-- 
2.17.1

