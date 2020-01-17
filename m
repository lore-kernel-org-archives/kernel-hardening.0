Return-Path: <SRS0=n+T/=3G=lists.openwall.com=kernel-hardening-return-17584-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D41EC33CB1
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jan 2020 05:41:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4B30E20748
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jan 2020 05:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="hIZBK5QZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B30E20748
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17584-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31754 invoked by uid 550); 17 Jan 2020 05:41:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30707 invoked from network); 17 Jan 2020 05:41:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g/cwxvTnvyDFyjw0sd/guJDNkXpw4lQAyMRmwwXOBQA=;
        b=hIZBK5QZ4W4Z4JfXvpe9lMgiGY9Xi+7ZI79ZY2D5fDGsjVOBX4WNe6boER+vehq0Xx
         19yUVSK4P2F76eyuEjwz+yyuDuH5GZnG/oRShAzd35E0PcO0Ua9rdjIqUhUy3basckN1
         4H5KwI62N3uSP5XRC3xFV5P3+Etu+F0by9icI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g/cwxvTnvyDFyjw0sd/guJDNkXpw4lQAyMRmwwXOBQA=;
        b=ABzbi+2WmYghreKxmKislxYJdzVpqqLG8IRuhd+5IUbIc61OI9a6z20q6Qhtl7Ma0c
         GEsrjpD9XKKqteYkHbwcO978OVkKMF4ShzXu1uMYJqkbbwb/lN50R689w0Ul7WnpjLMI
         4TF88gQeoVUkw+gKEIShi2Tc2+asZV9ZPk3eiZpBy/scfo6cr8vD/C5mGDng1wHYOxL3
         nkMydYhjx+KRpe4py60PDWqUjpKV212uKKFkPuekTtqyL+SuHufG8Lf2ej8XZIKQaf/f
         rD/3ttjgPSGad4T/XfUI/B82IQPomlUuTlRLVOnOmJhoYu5bFYfFoI6G4oDSScrhUnFJ
         gWYw==
X-Gm-Message-State: APjAAAUU1/FNRGK2eDGpp/TlZ928VVCqiNf0UuOts7WkS13QmTVnMM17
	Bt+w/r54BpHKtOIAEKnu5jOjDc/5M2E=
X-Google-Smtp-Source: APXvYqweR7PZf2ANLtmqAMDzxZ6LhCKzj1xEHFShAYQ+Fz/GxjkG32njELtIFh/YOvY6XPQfLzPFEw==
X-Received: by 2002:a17:90a:cb0f:: with SMTP id z15mr3688006pjt.131.1579239656216;
        Thu, 16 Jan 2020 21:40:56 -0800 (PST)
From: Daniel Axtens <dja@axtens.net>
To: kernel-hardening@lists.openwall.com
Cc: Daniel Axtens <dja@axtens.net>,
	Daniel Micay <danielmicay@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH] string.h: detect intra-object overflow in fortified string functions
Date: Fri, 17 Jan 2020 16:40:50 +1100
Message-Id: <20200117054050.30144-1-dja@axtens.net>
X-Mailer: git-send-email 2.20.1
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

Add a test demonstrating and validating the feature to lkdtm:
FORTIFY_SUBOBJECT.

Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 drivers/misc/lkdtm/bugs.c  | 26 ++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 include/linux/string.h     | 27 ++++++++++++++++-----------
 4 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index a4fdad04809a..1bbe291e44b7 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -11,6 +11,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_X86_32
 #include <asm/desc.h>
@@ -376,3 +377,28 @@ void lkdtm_DOUBLE_FAULT(void)
 	panic("tried to double fault but didn't die\n");
 }
 #endif
+
+void lkdtm_FORTIFY_SUBOBJECT(void)
+{
+	struct target {
+		char a[10];
+		char b[10];
+	} target;
+	char *src;
+
+	src = kmalloc(20, GFP_KERNEL);
+	strscpy(src, "over ten bytes", 20);
+
+	pr_info("trying to strcpy past the end of a member of a struct\n");
+
+	/*
+	 * strncpy(target.a, src, 20); will hit a compile error because the
+	 * compiler knows at build time that target.a < 20 bytes. Use strcpy()
+	 * to force a runtime error.
+	 */
+	strcpy(target.a, src);
+
+	/* Use target.a to prevent the code from being eliminated */
+	pr_err("FAIL: fortify did not catch an sub-object overrun!\n"
+	       "\"%s\" was copied.\n", target.a);
+}
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ee0d6e721441..c357e8fece3b 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -117,6 +117,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
 	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
+	CRASHTYPE(FORTIFY_SUBOBJECT),
 	CRASHTYPE(OVERWRITE_ALLOCATION),
 	CRASHTYPE(WRITE_AFTER_FREE),
 	CRASHTYPE(READ_AFTER_FREE),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index c56d23e37643..45928e25a3a5 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -31,6 +31,7 @@ void lkdtm_UNSET_SMEP(void);
 #ifdef CONFIG_X86_32
 void lkdtm_DOUBLE_FAULT(void);
 #endif
+void lkdtm_FORTIFY_SUBOBJECT(void);
 
 /* lkdtm_heap.c */
 void __init lkdtm_heap_init(void);
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

