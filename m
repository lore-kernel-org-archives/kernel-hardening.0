Return-Path: <SRS0=5ZM6=3J=lists.openwall.com=kernel-hardening-return-17597-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADA4C33CA1
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DE9E12077C
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="IsVuaMki"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE9E12077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17597-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22025 invoked by uid 550); 20 Jan 2020 07:44:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21911 invoked from network); 20 Jan 2020 07:44:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ceV5dzkz6HqCMW6fBoym4ypC/m9xh1QjTBMfyGPn8o=;
        b=IsVuaMkiPafyhTmbUmmKKq2zQ2knSaijf8xt11NZ6XL9Q4Hm1Cfdm8CztrO01x5ltK
         VnhPQHcNW2slNw6gRk8rL5iIUAbKO40Kuwiaqw1t/4WmuKa+tf45OOD70HBQ71fF1tLO
         +5Vv23deCqiMdkkxkLo3lvuCj1D8aE7yy6hs4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ceV5dzkz6HqCMW6fBoym4ypC/m9xh1QjTBMfyGPn8o=;
        b=RD5T5IJKLILjujVTu1yjDZwBBTodfi6zQ4X6DHjHptpLEU8Obwrqp+i9vCxUbCLzQL
         fekCfFnyvBjr1j3QRWDTAoec4oodvLvX1I/dU+ZePSdh1zJHst5jlvdKYmNeF0RSJ56O
         QVoeRwMdW9ut8nkGWbBoTNWbBcHOWxju6US0l4AETAiI2IdFc9gRk+Ys+/pB6DxUxwHZ
         X9eCRhx+nsXN6/xvzqyI2wKbFCYeV9jADGkUJUDhvp4IdScFdgnL4lv8u3aUfoIl7xhH
         FFMmmZvc6GPp89pbkTWFgMh12G3KCW6sfbMmRql3RThGP9OHPvoSYEwgWpbjach2oZ8E
         tB7Q==
X-Gm-Message-State: APjAAAXbOqObSuZD8QKJPLRhO7jUjCPdq3O2DmDpvPb4ULaZCQA4mm4+
	QBAj1iTRUx1kwdFk9EOO80nCGCKQtSc=
X-Google-Smtp-Source: APXvYqxpn7k/Ufr5n0ApK06TsYbJxU+ior64MbZ5pNsKbxSZFpNAZBslVxeMWsQFy8/9nF92ZyhObQ==
X-Received: by 2002:a63:cc4a:: with SMTP id q10mr58040093pgi.241.1579506244663;
        Sun, 19 Jan 2020 23:44:04 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4/5] [VERY RFC] mm: kmalloc(_node): return NULL immediately for SIZE_MAX
Date: Mon, 20 Jan 2020 18:43:43 +1100
Message-Id: <20200120074344.504-5-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120074344.504-1-dja@axtens.net>
References: <20200120074344.504-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

kmalloc is sometimes compiled with an size that at compile time may be
equal to SIZE_MAX.

For example, struct_size(struct, array member, array elements) returns the
size of a structure that has an array as the last element, containing a
given number of elements, or SIZE_MAX on overflow.

However, struct_size operates in (arguably) unintuitive ways at compile time.
Consider the following snippet:

struct foo {
	int a;
	int b[0];
};

struct foo *alloc_foo(int elems)
{
	struct foo *result;
	size_t size = struct_size(result, b, elems);
	if (__builtin_constant_p(size)) {
		BUILD_BUG_ON(size == SIZE_MAX);
	}
	result = kmalloc(size, GFP_KERNEL);
	return result;
}

I expected that size would only be constant if alloc_foo() was called
within that translation unit with a constant number of elements, and the
compiler had decided to inline it. I'd therefore expect that 'size' is only
SIZE_MAX if the constant provided was a huge number.

However, instead, this function hits the BUILD_BUG_ON, even if never
called.

include/linux/compiler.h:394:38: error: call to ‘__compiletime_assert_32’ declared with attribute error: BUILD_BUG_ON failed: size == SIZE_MAX

This is with gcc 9.2.1, and I've also observed it with an gcc 8 series
compiler.

My best explanation of this is:

 - elems is a signed int, so a small negative number will become a very
   large unsigned number when cast to a size_t, leading to overflow.

 - Then, the only way in which size can be a constant is if we hit the
   overflow case, in which 'size' will be 'SIZE_MAX'.

 - So the compiler takes that value into the body of the if statement and
   blows up.

But I could be totally wrong.

Anyway, this is relevant to slab.h because kmalloc() and kmalloc_node()
check if the supplied size is a constant and take a faster path if so. A
number of callers of those functions use struct_size to determine the size
of a memory allocation. Therefore, at compile time, those functions will go
down the constant path, specialising for the overflow case.

When my next patch is applied, gcc will then throw a warning any time
kmalloc_large could be called with a SIZE_MAX size, as gcc deems SIZE_MAX
to be too big an allocation.

So, make functions that check __builtin_constant_p check also against
SIZE_MAX in the constant path, and immediately return NULL if we hit it.

This brings kmalloc() and kmalloc_node() into line with the array functions
kmalloc_array() and kmalloc_array_node() for the overflow case. The overall
compiled size change per bloat-o-meter is in the noise (a reduction of
<0.01%).

Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 include/linux/slab.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 03a389358562..8141c6b1882a 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -544,6 +544,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 #ifndef CONFIG_SLOB
 		unsigned int index;
 #endif
+		if (unlikely(size == SIZE_MAX))
+			return NULL;
+
 		if (size > KMALLOC_MAX_CACHE_SIZE)
 			return kmalloc_large(size, flags);
 #ifndef CONFIG_SLOB
@@ -562,6 +565,9 @@ static __always_inline void *kmalloc(size_t size, gfp_t flags)
 
 static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
 {
+	if (__builtin_constant_p(size) && size == SIZE_MAX)
+		return NULL;
+
 #ifndef CONFIG_SLOB
 	if (__builtin_constant_p(size) &&
 		size <= KMALLOC_MAX_CACHE_SIZE) {
-- 
2.20.1

