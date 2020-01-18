Return-Path: <SRS0=NjIS=3H=lists.openwall.com=kernel-hardening-return-17588-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270EBC33CB1
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jan 2020 11:46:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 46A672468D
	for <kernel-hardening@archiver.kernel.org>; Sat, 18 Jan 2020 11:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hMzOzfVQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46A672468D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17588-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1426 invoked by uid 550); 18 Jan 2020 11:46:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1406 invoked from network); 18 Jan 2020 11:46:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cdo5UbOuzWaC39/eItrJUmIAuMxWtOmottAnR2YI9a4=;
        b=hMzOzfVQddpY5UELIfYz9cmXOaXAxPHDofHztIK3Y6EWb+yve5fZ89o/1D3RILFmcL
         8vh69HUj3Se92a7tGrjIP6698mb6MoSvbWyWFDtAsnBsNkIlP8xYdJ/GBKAxJuCyq/h7
         kvm6Vr31ZrxcpTVZFsMwW9tiAtJcKYVa1VoAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cdo5UbOuzWaC39/eItrJUmIAuMxWtOmottAnR2YI9a4=;
        b=sJKrSVOj2Iip+neSEvF6Cz+2jEDlCYVCt4WVo/JeikIsvAWQRidXxDqJ7ZUzH7DwTr
         CobS+QUXw5fd5MRIdXyXRclp8csJ78TwxxBuQAPbLvM1x26mPzLAWWWujb7JI9lvTes6
         4Oq5if8QrSZP/l2CgEc7B5nBtzR4cboXpjOP4AgZm0y7npOVvsfKSuPNmiG0J3CENBg9
         mRTozTv5SNbChMI8XmMgflBGBpfCklx1sgRPcK55uNXEqQVitIvaWNsjk+MINFxONSjX
         MGhvr0sA0VTQ0ODHuiom+HChyeLE31oopdX2BRuk4bglcsG7zv7TJH5fuqi4MeqiWFY2
         Za+g==
X-Gm-Message-State: APjAAAXmjWXqlNwVS28xCL3zxYED4VgZKyPg951XnO8PltC/jHUYltf+
	jQrvshJnIDddWLKtnUwaCpHKgw==
X-Google-Smtp-Source: APXvYqwhhHq9uhltEHyJYx3rhuUUoZ/75D8/5K0LopXJ7NU+IX26vYjJzSkzGkLHG/4ZcBRN9HPCog==
X-Received: by 2002:a63:5fd7:: with SMTP id t206mr51098555pgb.281.1579347979803;
        Sat, 18 Jan 2020 03:46:19 -0800 (PST)
Date: Sat, 18 Jan 2020 03:46:17 -0800
From: Kees Cook <keescook@chromium.org>
To: Daniel Axtens <dja@axtens.net>
Cc: kernel-hardening@lists.openwall.com,
	Daniel Micay <danielmicay@gmail.com>
Subject: Re: [PATCH] string.h: detect intra-object overflow in fortified
 string functions
Message-ID: <202001180342.B23414E28@keescook>
References: <20200117054050.30144-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117054050.30144-1-dja@axtens.net>

On Fri, Jan 17, 2020 at 04:40:50PM +1100, Daniel Axtens wrote:
> When the fortify feature was first introduced in commit 6974f0c4555e
> ("include/linux/string.h: add the option of fortified string.h functions"),
> Daniel Micay observed:
> 
>   * It should be possible to optionally use __builtin_object_size(x, 1) for
>     some functions (C strings) to detect intra-object overflows (like
>     glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
>     approach to avoid likely compatibility issues.
> 


Yes please! :)

> This is a case that often cannot be caught by KASAN. Consider:
> 
> struct foo {
>     char a[10];
>     char b[10];
> }
> 
> void test() {
>     char *msg;
>     struct foo foo;
> 
>     msg = kmalloc(16, GFP_KERNEL);
>     strcpy(msg, "Hello world!!");
>     // this copy overwrites foo.b
>     strcpy(foo.a, msg);
> }
> 
> The questionable copy overflows foo.a and writes to foo.b as well. It
> cannot be detected by KASAN. Currently it is also not detected by fortify,
> because strcpy considers __builtin_object_size(x, 0), which considers the
> size of the surrounding object (here, struct foo). However, if we switch
> the string functions over to use __builtin_object_size(x, 1), the compiler
> will measure the size of the closest surrounding subobject (here, foo.a),
> rather than the size of the surrounding object as a whole. See
> https://gcc.gnu.org/onlinedocs/gcc/Object-Size-Checking.html for more info.
> 
> Only do this for string functions: we cannot use it on things like
> memcpy, memmove, memcmp and memchr_inv due to code like this which
> purposefully operates on multiple structure members:
> (arch/x86/kernel/traps.c)
> 
> 	/*
> 	 * regs->sp points to the failing IRET frame on the
> 	 * ESPFIX64 stack.  Copy it to the entry stack.  This fills
> 	 * in gpregs->ss through gpregs->ip.
> 	 *
> 	 */
> 	memmove(&gpregs->ip, (void *)regs->sp, 5*8);
> 
> This change passes an allyesconfig on powerpc and x86, and an x86 kernel
> built with it survives running with syz-stress from syzkaller, so it seems
> safe so far.
> 
> Add a test demonstrating and validating the feature to lkdtm:
> FORTIFY_SUBOBJECT.

Can you actually split this into two patches? One with the lkdtm changes
and one with the string.h changes?

I can take the lkdtm changes and then akpm can take the string.h changes
(please add him as the To for v2, and include lkml in Cc too). (Also,
it's be nice to have a non-subobject fortify test in lkdtm too.)

Thanks for doing this! Please consider these:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> Cc: Daniel Micay <danielmicay@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  drivers/misc/lkdtm/bugs.c  | 26 ++++++++++++++++++++++++++
>  drivers/misc/lkdtm/core.c  |  1 +
>  drivers/misc/lkdtm/lkdtm.h |  1 +
>  include/linux/string.h     | 27 ++++++++++++++++-----------
>  4 files changed, 44 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
> index a4fdad04809a..1bbe291e44b7 100644
> --- a/drivers/misc/lkdtm/bugs.c
> +++ b/drivers/misc/lkdtm/bugs.c
> @@ -11,6 +11,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/uaccess.h>
> +#include <linux/slab.h>
>  
>  #ifdef CONFIG_X86_32
>  #include <asm/desc.h>
> @@ -376,3 +377,28 @@ void lkdtm_DOUBLE_FAULT(void)
>  	panic("tried to double fault but didn't die\n");
>  }
>  #endif
> +
> +void lkdtm_FORTIFY_SUBOBJECT(void)
> +{
> +	struct target {
> +		char a[10];
> +		char b[10];
> +	} target;
> +	char *src;
> +
> +	src = kmalloc(20, GFP_KERNEL);
> +	strscpy(src, "over ten bytes", 20);
> +
> +	pr_info("trying to strcpy past the end of a member of a struct\n");
> +
> +	/*
> +	 * strncpy(target.a, src, 20); will hit a compile error because the
> +	 * compiler knows at build time that target.a < 20 bytes. Use strcpy()
> +	 * to force a runtime error.
> +	 */
> +	strcpy(target.a, src);
> +
> +	/* Use target.a to prevent the code from being eliminated */
> +	pr_err("FAIL: fortify did not catch an sub-object overrun!\n"
> +	       "\"%s\" was copied.\n", target.a);
> +}
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index ee0d6e721441..c357e8fece3b 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -117,6 +117,7 @@ static const struct crashtype crashtypes[] = {
>  	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
>  	CRASHTYPE(UNSET_SMEP),
>  	CRASHTYPE(UNALIGNED_LOAD_STORE_WRITE),
> +	CRASHTYPE(FORTIFY_SUBOBJECT),
>  	CRASHTYPE(OVERWRITE_ALLOCATION),
>  	CRASHTYPE(WRITE_AFTER_FREE),
>  	CRASHTYPE(READ_AFTER_FREE),
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index c56d23e37643..45928e25a3a5 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -31,6 +31,7 @@ void lkdtm_UNSET_SMEP(void);
>  #ifdef CONFIG_X86_32
>  void lkdtm_DOUBLE_FAULT(void);
>  #endif
> +void lkdtm_FORTIFY_SUBOBJECT(void);
>  
>  /* lkdtm_heap.c */
>  void __init lkdtm_heap_init(void);
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 3b8e8b12dd37..e7f34c3113f8 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -319,7 +319,7 @@ void __write_overflow(void) __compiletime_error("detected write beyond size of o
>  #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
>  __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
>  {
> -	size_t p_size = __builtin_object_size(p, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
>  	if (__builtin_constant_p(size) && p_size < size)
>  		__write_overflow();
>  	if (p_size < size)
> @@ -329,7 +329,7 @@ __FORTIFY_INLINE char *strncpy(char *p, const char *q, __kernel_size_t size)
>  
>  __FORTIFY_INLINE char *strcat(char *p, const char *q)
>  {
> -	size_t p_size = __builtin_object_size(p, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
>  	if (p_size == (size_t)-1)
>  		return __builtin_strcat(p, q);
>  	if (strlcat(p, q, p_size) >= p_size)
> @@ -340,7 +340,7 @@ __FORTIFY_INLINE char *strcat(char *p, const char *q)
>  __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
>  {
>  	__kernel_size_t ret;
> -	size_t p_size = __builtin_object_size(p, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
>  
>  	/* Work around gcc excess stack consumption issue */
>  	if (p_size == (size_t)-1 ||
> @@ -355,7 +355,7 @@ __FORTIFY_INLINE __kernel_size_t strlen(const char *p)
>  extern __kernel_size_t __real_strnlen(const char *, __kernel_size_t) __RENAME(strnlen);
>  __FORTIFY_INLINE __kernel_size_t strnlen(const char *p, __kernel_size_t maxlen)
>  {
> -	size_t p_size = __builtin_object_size(p, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
>  	__kernel_size_t ret = __real_strnlen(p, maxlen < p_size ? maxlen : p_size);
>  	if (p_size <= ret && maxlen != ret)
>  		fortify_panic(__func__);
> @@ -367,8 +367,8 @@ extern size_t __real_strlcpy(char *, const char *, size_t) __RENAME(strlcpy);
>  __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
>  {
>  	size_t ret;
> -	size_t p_size = __builtin_object_size(p, 0);
> -	size_t q_size = __builtin_object_size(q, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
> +	size_t q_size = __builtin_object_size(q, 1);
>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>  		return __real_strlcpy(p, q, size);
>  	ret = strlen(q);
> @@ -388,8 +388,8 @@ __FORTIFY_INLINE size_t strlcpy(char *p, const char *q, size_t size)
>  __FORTIFY_INLINE char *strncat(char *p, const char *q, __kernel_size_t count)
>  {
>  	size_t p_len, copy_len;
> -	size_t p_size = __builtin_object_size(p, 0);
> -	size_t q_size = __builtin_object_size(q, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
> +	size_t q_size = __builtin_object_size(q, 1);
>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>  		return __builtin_strncat(p, q, count);
>  	p_len = strlen(p);
> @@ -502,11 +502,16 @@ __FORTIFY_INLINE void *kmemdup(const void *p, size_t size, gfp_t gfp)
>  /* defined after fortified strlen and memcpy to reuse them */
>  __FORTIFY_INLINE char *strcpy(char *p, const char *q)
>  {
> -	size_t p_size = __builtin_object_size(p, 0);
> -	size_t q_size = __builtin_object_size(q, 0);
> +	size_t p_size = __builtin_object_size(p, 1);
> +	size_t q_size = __builtin_object_size(q, 1);
> +	size_t size;
>  	if (p_size == (size_t)-1 && q_size == (size_t)-1)
>  		return __builtin_strcpy(p, q);
> -	memcpy(p, q, strlen(q) + 1);
> +	size = strlen(q) + 1;
> +	/* test here to use the more stringent object size */
> +	if (p_size < size)
> +		fortify_panic(__func__);
> +	memcpy(p, q, size);
>  	return p;
>  }
>  
> -- 
> 2.20.1
> 

-- 
Kees Cook
