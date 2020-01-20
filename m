Return-Path: <SRS0=up82=3J=lists.openwall.com=kernel-hardening-return-17598-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B68C33CA1
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F289F2077C
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 07:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="NenyvpxA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F289F2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17598-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22418 invoked by uid 550); 20 Jan 2020 07:44:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22281 invoked from network); 20 Jan 2020 07:44:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q9naSqUxzHPFtc57EHQL2H0oZQeWzVS7OaqvwD1FRfU=;
        b=NenyvpxABKd6hOcqPhh83eoyF/gaiZOh+OeEvInZfRRI5Zokd3GFOAIlA2nobLePtG
         Xd9NwHEJBKVJ9xd7+v9ystKIqbw060Bco8cqIiqjgcjmjMwqC7nvTxi6xupNsuzZeTMs
         E4s3sqs4MNeEmMD9aR2ToUAC/zQCLo1LKVqWU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q9naSqUxzHPFtc57EHQL2H0oZQeWzVS7OaqvwD1FRfU=;
        b=iq9bhi3IKnv1ik0cdSaqfRbnTC5q1KB57F683J7cQYwDYnPB4T9C8DxcHe5d9maJxh
         qkaZVHdEWhOORyVyJtJA17ZQYn+4eRUTpc1ZzzDjDWSPQlDvhTtP2mUqxgZlm1DPTTCQ
         23jrspJlPdCiPxvGbg83Ag9Gh53pwnAsoEVOVoIR121h73ypgcchc/BRljE0u8lAerOf
         HlozWlLAsFxk40hu2k420NvPVkZQHUBRuxiVDhQ9xxlsLZZHEyAzzDZw/Cyv6KmOtb+X
         gJGBfqOxpoz+lnRiNAA+KTPFGqlZVv+icxHIIom2CINr7aLTlmxo14or1rl9KLJahy34
         Sq6g==
X-Gm-Message-State: APjAAAWyXsUiCWmbeicFF9d4eLxHRc2BwE95GQ2UJKicPjOwtO5fGYQt
	pjiFvfEqKZEuZ/lRQqXSD0WAzZDINIg=
X-Google-Smtp-Source: APXvYqxLeiWwe5nyCHjHlUvo/yCR2up/7I6JYzI4pzU3HwwuWU199gXkrFBh0vomggtFROnkeJlIXA==
X-Received: by 2002:a17:902:8f94:: with SMTP id z20mr13991205plo.62.1579506248432;
        Sun, 19 Jan 2020 23:44:08 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	Daniel Axtens <dja@axtens.net>,
	Daniel Micay <danielmicay@gmail.com>
Subject: [PATCH 5/5] [RFC] mm: annotate memory allocation functions with their sizes
Date: Mon, 20 Jan 2020 18:43:44 +1100
Message-Id: <20200120074344.504-6-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120074344.504-1-dja@axtens.net>
References: <20200120074344.504-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gcc and clang support the alloc_size attribute. Quoting
<https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes>:

  alloc_size (position)
  alloc_size (position-1, position-2)

    The alloc_size attribute may be applied to a function that returns a
    pointer and takes at least one argument of an integer or enumerated
    type. It indicates that the returned pointer points to memory whose
    size is given by the function argument at position-1, or by the product
    of the arguments at position-1 and position-2. Meaningful sizes are
    positive values less than PTRDIFF_MAX. GCC uses this information to
    improve the results of __builtin_object_size.

gcc supports this back to at least 4.3.6 [1], and clang has supported it
since December 2016 [2]. I think this is sufficent to make it always-on.

Annotate the kmalloc and vmalloc family: where a memory allocation has a
size knowable at compile time, allow the compiler to use that for
__builtin_object_size() calculations.

There are a couple of limitations:

 * only functions that return a single pointer can be directly annotated

 * only functions that take the size as a parameter (or as the product of
   two parameters) can be directly annotated.

These could possibly be addressed in future with some hackery.

This is useful for two things:

  * __builtin_object_size() is used in fortify and copy_to/from_user to
    find bugs at compile time and run time.

  * knowing the size allows the compiler to inline things when using
    __builtin_* functions. With my config with FORTIFY_SOURCE enabled
    I see a number of strlcpys being converted into a strlen and inline
    memcpy. This leads to an overall size increase of 0.04% (per
    bloat-o-meter) when compiled with -O2.

[1]: https://gcc.gnu.org/onlinedocs/gcc-4.3.6/gcc/Function-Attributes.html#Function-Attributes
[2]: https://reviews.llvm.org/D14274

Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 include/linux/compiler_attributes.h |  6 +++++
 include/linux/kasan.h               | 12 ++++-----
 include/linux/slab.h                | 38 ++++++++++++++++++-----------
 include/linux/vmalloc.h             | 26 ++++++++++----------
 4 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index cdf016596659..ccacbb2f2c56 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -56,6 +56,12 @@
 #define __aligned(x)                    __attribute__((__aligned__(x)))
 #define __aligned_largest               __attribute__((__aligned__))
 
+/*
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
+ */
+#define __alloc_size(a, ...)		__attribute__((alloc_size(a, ## __VA_ARGS__)))
+
 /*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 5cde9e7c2664..a8da784c98ad 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -53,13 +53,13 @@ void * __must_check kasan_init_slab_obj(struct kmem_cache *cache,
 					const void *object);
 
 void * __must_check kasan_kmalloc_large(const void *ptr, size_t size,
-						gfp_t flags);
+						gfp_t flags) __alloc_size(2);
 void kasan_kfree_large(void *ptr, unsigned long ip);
 void kasan_poison_kfree(void *ptr, unsigned long ip);
 void * __must_check kasan_kmalloc(struct kmem_cache *s, const void *object,
-					size_t size, gfp_t flags);
+					size_t size, gfp_t flags) __alloc_size(3);
 void * __must_check kasan_krealloc(const void *object, size_t new_size,
-					gfp_t flags);
+					gfp_t flags) __alloc_size(2);
 
 void * __must_check kasan_slab_alloc(struct kmem_cache *s, void *object,
 					gfp_t flags);
@@ -124,18 +124,18 @@ static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
 	return (void *)object;
 }
 
-static inline void *kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags)
+static inline __alloc_size(2) void *kasan_kmalloc_large(void *ptr, size_t size, gfp_t flags)
 {
 	return ptr;
 }
 static inline void kasan_kfree_large(void *ptr, unsigned long ip) {}
 static inline void kasan_poison_kfree(void *ptr, unsigned long ip) {}
-static inline void *kasan_kmalloc(struct kmem_cache *s, const void *object,
+static inline __alloc_size(3) void *kasan_kmalloc(struct kmem_cache *s, const void *object,
 				size_t size, gfp_t flags)
 {
 	return (void *)object;
 }
-static inline void *kasan_krealloc(const void *object, size_t new_size,
+static inline __alloc_size(2) void *kasan_krealloc(const void *object, size_t new_size,
 				 gfp_t flags)
 {
 	return (void *)object;
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 8141c6b1882a..fbfc81f37374 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -184,7 +184,7 @@ void memcg_deactivate_kmem_caches(struct mem_cgroup *, struct mem_cgroup *);
 /*
  * Common kmalloc functions provided by all allocators
  */
-void * __must_check krealloc(const void *, size_t, gfp_t);
+void * __must_check krealloc(const void *, size_t, gfp_t) __alloc_size(2);
 void kfree(const void *);
 void kzfree(const void *);
 size_t __ksize(const void *);
@@ -389,7 +389,9 @@ static __always_inline unsigned int kmalloc_index(size_t size)
 }
 #endif /* !CONFIG_SLOB */
 
-void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
+__assume_kmalloc_alignment __malloc __alloc_size(1) void *
+__kmalloc(size_t size, gfp_t flags);
+
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags) __assume_slab_alignment __malloc;
 void kmem_cache_free(struct kmem_cache *, void *);
 
@@ -413,8 +415,11 @@ static __always_inline void kfree_bulk(size_t size, void **p)
 }
 
 #ifdef CONFIG_NUMA
-void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_kmalloc_alignment __malloc;
-void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node) __assume_slab_alignment __malloc;
+__assume_kmalloc_alignment __malloc __alloc_size(1) void *
+__kmalloc_node(size_t size, gfp_t flags, int node);
+
+__assume_slab_alignment __malloc void *
+kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
 #else
 static __always_inline void *__kmalloc_node(size_t size, gfp_t flags, int node)
 {
@@ -428,12 +433,14 @@ static __always_inline void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t f
 #endif
 
 #ifdef CONFIG_TRACING
-extern void *kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t) __assume_slab_alignment __malloc;
+extern __alloc_size(3) void *
+kmem_cache_alloc_trace(struct kmem_cache *, gfp_t, size_t);
 
 #ifdef CONFIG_NUMA
-extern void *kmem_cache_alloc_node_trace(struct kmem_cache *s,
-					   gfp_t gfpflags,
-					   int node, size_t size) __assume_slab_alignment __malloc;
+extern  __assume_slab_alignment __malloc __alloc_size(4) void *
+kmem_cache_alloc_node_trace(struct kmem_cache *s,
+			    gfp_t gfpflags,
+			    int node, size_t size);
 #else
 static __always_inline void *
 kmem_cache_alloc_node_trace(struct kmem_cache *s,
@@ -445,8 +452,8 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
 #endif /* CONFIG_NUMA */
 
 #else /* CONFIG_TRACING */
-static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s,
-		gfp_t flags, size_t size)
+static __always_inline __alloc_size(3) void *
+kmem_cache_alloc_trace(struct kmem_cache *s, gfp_t flags, size_t size)
 {
 	void *ret = kmem_cache_alloc(s, flags);
 
@@ -454,7 +461,7 @@ static __always_inline void *kmem_cache_alloc_trace(struct kmem_cache *s,
 	return ret;
 }
 
-static __always_inline void *
+static __always_inline __alloc_size(4) void *
 kmem_cache_alloc_node_trace(struct kmem_cache *s,
 			      gfp_t gfpflags,
 			      int node, size_t size)
@@ -466,10 +473,12 @@ kmem_cache_alloc_node_trace(struct kmem_cache *s,
 }
 #endif /* CONFIG_TRACING */
 
-extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern __assume_page_alignment __malloc __alloc_size(1) void *
+kmalloc_order(size_t size, gfp_t flags, unsigned int order);
 
 #ifdef CONFIG_TRACING
-extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order) __assume_page_alignment __malloc;
+extern __assume_page_alignment __malloc __alloc_size(1) void *
+kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order);
 #else
 static __always_inline void *
 kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
@@ -645,7 +654,8 @@ static inline void *kcalloc_node(size_t n, size_t size, gfp_t flags, int node)
 
 
 #ifdef CONFIG_NUMA
-extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
+extern __alloc_size(1) void *
+__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
 			_RET_IP_)
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 0507a162ccd0..a3651bcc62a3 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -102,22 +102,22 @@ static inline void vmalloc_init(void)
 static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 #endif
 
-extern void *vmalloc(unsigned long size);
-extern void *vzalloc(unsigned long size);
-extern void *vmalloc_user(unsigned long size);
-extern void *vmalloc_node(unsigned long size, int node);
-extern void *vzalloc_node(unsigned long size, int node);
-extern void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags);
-extern void *vmalloc_exec(unsigned long size);
-extern void *vmalloc_32(unsigned long size);
-extern void *vmalloc_32_user(unsigned long size);
-extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot);
+extern void *vmalloc(unsigned long size) __alloc_size(1);
+extern void *vzalloc(unsigned long size) __alloc_size(1);
+extern void *vmalloc_user(unsigned long size) __alloc_size(1);
+extern void *vmalloc_node(unsigned long size, int node) __alloc_size(1);
+extern void *vzalloc_node(unsigned long size, int node) __alloc_size(1);
+extern void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags) __alloc_size(1);
+extern void *vmalloc_exec(unsigned long size) __alloc_size(1);
+extern void *vmalloc_32(unsigned long size) __alloc_size(1);
+extern void *vmalloc_32_user(unsigned long size) __alloc_size(1);
+extern void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot) __alloc_size(1);
 extern void *__vmalloc_node_range(unsigned long size, unsigned long align,
 			unsigned long start, unsigned long end, gfp_t gfp_mask,
 			pgprot_t prot, unsigned long vm_flags, int node,
-			const void *caller);
+			const void *caller) __alloc_size(1);
 #ifndef CONFIG_MMU
-extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags);
+extern void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags) __alloc_size(1);
 static inline void *__vmalloc_node_flags_caller(unsigned long size, int node,
 						gfp_t flags, void *caller)
 {
@@ -125,7 +125,7 @@ static inline void *__vmalloc_node_flags_caller(unsigned long size, int node,
 }
 #else
 extern void *__vmalloc_node_flags_caller(unsigned long size,
-					 int node, gfp_t flags, void *caller);
+					 int node, gfp_t flags, void *caller) __alloc_size(1);
 #endif
 
 extern void vfree(const void *addr);
-- 
2.20.1

