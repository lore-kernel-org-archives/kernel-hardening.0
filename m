Return-Path: <SRS0=en+Y=3J=lists.openwall.com=kernel-hardening-return-17591-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83B4C32771
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 04:54:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CF9222073A
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 04:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="HErB6DHE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF9222073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17591-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20362 invoked by uid 550); 20 Jan 2020 04:54:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20263 invoked from network); 20 Jan 2020 04:54:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q4BdOeTArsFeOLkWOltqSDzbsVTMB1DhmfQ/wMwlBh8=;
        b=HErB6DHEz05P7HfbSHsadDt8p5fu0zb0K6lg8oXEJnO41RWGDIlURmCpHZMTZ1p2RD
         01u3IvBgZfq1nalGmcYXCjIz9gSELXL+VnGjSurFstSztcmbs5HpPdgXgOHP+YQKzkfM
         KVCbFl4TYZfxOxvs8kOGuWPANzXITXNZiP9UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q4BdOeTArsFeOLkWOltqSDzbsVTMB1DhmfQ/wMwlBh8=;
        b=ohXhvU387BirsWGNo1txjd9uD6aZ4X2k9Dvz7OU/JHFOy9+bZuG5aPCOsZIqag4P58
         Yad3Wr8OAf0XGiNX/gxZUfgJSDjXe+VOe3m7ecal8qne0TRkbUt6pcermPkdOI160vMz
         D0DY5QebRd1RHMZhsbwbWeATVAkRoIOA8ufbE5oczlsc2uOZsLNCqxMCPrQFv7QGutdd
         OPCjIGFnyKQs+bEs0hK73NGvKCx+Q6DIzQTugZciaOIwDdngdUwRH8uIRlt+jvC0tNFR
         7Z9+j/4U64x/AWE/dpaH2YzjwiG8k3dbrPpEiX5Qm80epJIJDV6L0tx5k5dvToLgOOmY
         uh7g==
X-Gm-Message-State: APjAAAX1aZ+AeQlUBNyUJHBU07ls/qYWdsq1CMQ/Zwh3ogtGmrt0BwAm
	tSB+5d1LJqGbq6HzkRlqYImFU5F2YZo=
X-Google-Smtp-Source: APXvYqxxSXSgIxfhFcLiHJlvxq3iD1FqCPObTaUjZE58C8mVflHN8qdOZfOJ60P3mb5NTZuthE/ttA==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr20743857pjb.99.1579496074078;
        Sun, 19 Jan 2020 20:54:34 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com,
	akpm@linux-foundation.org,
	keescook@chromium.org
Cc: linux-kernel@vger.kernel.org,
	Daniel Axtens <dja@axtens.net>,
	Daniel Micay <danielmicay@gmail.com>
Subject: [PATCH v2 1/2] string.h: detect intra-object overflow in fortified string functions
Date: Mon, 20 Jan 2020 15:54:23 +1100
Message-Id: <20200120045424.16147-2-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200120045424.16147-1-dja@axtens.net>
References: <20200120045424.16147-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the fortify feature was first introduced in commit 6974f0c4555e
("include/linux/string.h: add the option of fortified string.h functions"),
Daniel Micay observed:

  * It should be possible to optionally use __builtin_object_size(x, 1) for
    some functions (C strings) to detect intra-object overflows (like
    glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
    approach to avoid likely compatibility issues.

This is a case that often cannot be caught by KASAN. Consider:

struct foo {
    char a[10];
    char b[10];
}

void test() {
    char *msg;
    struct foo foo;

    msg = kmalloc(16, GFP_KERNEL);
    strcpy(msg, "Hello world!!");
    // this copy overwrites foo.b
    strcpy(foo.a, msg);
}

The questionable copy overflows foo.a and writes to foo.b as well. It
cannot be detected by KASAN. Currently it is also not detected by fortify,
because strcpy considers __builtin_object_size(x, 0), which considers the
size of the surrounding object (here, struct foo). However, if we switch
the string functions over to use __builtin_object_size(x, 1), the compiler
will measure the size of the closest surrounding subobject (here, foo.a),
rather than the size of the surrounding object as a whole. See
https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html for more info.

Only do this for string functions: we cannot use it on things like
memcpy, memmove, memcmp and memchr_inv due to code like this which
purposefully operates on multiple structure members:
(arch/x86/kernel/traps.c)

	/*
	 * regs->sp points to the failing IRET frame on the
	 * ESPFIX64 stack.  Copy it to the entry stack.  This fills
	 * in gpregs->ss through gpregs->ip.
	 *
	 */
	memmove(&gpregs->ip, (void *)regs->sp, 5*8);

This change passes an allyesconfig on powerpc and x86, and an x86 kernel
built with it survives running with syz-stress from syzkaller, so it seems
safe so far.

Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 include/linux/string.h | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index 3b8e8b12dd37..e7f34c3113f8 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -319,7 +319,7 @@ void __write_overflow(void) __compiletime_error("detected write beyond size of o
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
 __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	if (__builtin_constant_p(size) && p_size < size)
 		__write_overflow();
 	if (p_size < size)
@@ -329,7 +329,7 @@ __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
 
 __FORTIFY_INLINE char *strcat(char *p, const char *q)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	if (p_size == (size_t)-1)
 		return __builtin_strcat(p, q);
 	if (strlcat(p, q, p_size) >= p_size)
@@ -340,7 +340,7 @@ __FORTIFY_INLINE char *strcat(char *p, const char *q)
 __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 {
 	__kernel_size_t ret;
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 
 	/* Work around gcc excess stack consumption issue */
 	if (p_size == (size_t)-1 ||
@@ -355,7 +355,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
 extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
 __FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
 {
-	size_t p_size = __builtin_object_size(p, 0);
+	size_t p_size = __builtin_object_size(p, 1);
 	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
 	if (p_size <= ret && maxlen != ret)
 		fortify_panic(__func__);
@@ -367,8 +367,8 @@ extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
 __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 {
 	size_t ret;
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __real_strlcpy(p, q, size);
 	ret = strlen(q);
@@ -388,8 +388,8 @@ __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
 __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
 {
 	size_t p_len, copy_len;
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __builtin_strncat(p, q, count);
 	p_len = strlen(p);
@@ -502,11 +502,16 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
 /* defined after fortified strlen and memcpy to reuse them */
 __FORTIFY_INLINE char *strcpy(char *p, const char *q)
 {
-	size_t p_size = __builtin_object_size(p, 0);
-	size_t q_size = __builtin_object_size(q, 0);
+	size_t p_size = __builtin_object_size(p, 1);
+	size_t q_size = __builtin_object_size(q, 1);
+	size_t size;
 	if (p_size == (size_t)-1 && q_size == (size_t)-1)
 		return __builtin_strcpy(p, q);
-	memcpy(p, q, strlen(q) + 1);
+	size = strlen(q) + 1;
+	/* test here to use the more stringent object size */
+	if (p_size < size)
+		fortify_panic(__func__);
+	memcpy(p, q, size);
 	return p;
 }
 
-- 
2.20.1

