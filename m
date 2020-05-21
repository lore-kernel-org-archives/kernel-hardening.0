Return-Path: <SRS0=gVsq=7D=lists.openwall.com=kernel-hardening-return-18852-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00BBCC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:55:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 419352072C
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E+o09LWI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 419352072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18852-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29725 invoked by uid 550); 21 May 2020 21:54:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29705 invoked from network); 21 May 2020 21:54:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qpd+pHTtktr0kpNjUZDK7A291Uhdx4ouls0jQBZgJbI=;
        b=E+o09LWIlQ+NniVPXQSRZoxiyn86jw4XjK0Z7PZG4bkhcZiTxrdDvF4boiizLY5u6L
         ntwxyw/tq0o0Zoh0/+0d7ZjBQvK+zHI4qAGvAdCyZtUg/EpAUbOosDa7aZ9GVWlUkmE7
         c+BK+YFIIKtUIcFV52JsokzIyymKsaknEfAMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qpd+pHTtktr0kpNjUZDK7A291Uhdx4ouls0jQBZgJbI=;
        b=DotmT08kzu9uBiXnXTSRN8Aojdt5g+AAQggp66y/BdClLC9zC5aLgr48ylqAQMbyVD
         tHISzSI4ef28BRAN8MRE3yD+s/Xn/oX3/ZeN6wYF7BDMTjX3kd1b7letryA1L3X//Rxn
         BVHd/9vaYgvt+SdP4rkT+g995o3R0/8qfq81WkQj3JQ1dL7YcoYGaAAhkIsKMVfk2tUP
         nsvU10hZfy2uS0OgkdvD1HAkj1g7HZEyh7vW2gugiyWnk5Lxp3j4Zu5IafCL4C7wuTda
         JGAZFTRGiJJzbPM2F+qjjjH/+PirKJSPURUvCx5oZfuayZvN8A9AA6FVn4pBWfX16etC
         AHaQ==
X-Gm-Message-State: AOAM531ZHrCA1dGm7djrXwcS8klxURkPH444ugCr89r0jRExYVUq86jO
	eKUjShbbs9ljmm0tW+PvpdSLhA==
X-Google-Smtp-Source: ABdhPJx6VolkvDgFR7ZSKtSVZiKV1tltjRSlw+AFOnkwTJE7en/CRGuk4F0KulIthu2T1RO6O0lxDQ==
X-Received: by 2002:a63:4911:: with SMTP id w17mr10574165pga.13.1590098081815;
        Thu, 21 May 2020 14:54:41 -0700 (PDT)
Date: Thu, 21 May 2020 14:54:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 0/9] Function Granular KASLR
Message-ID: <202005211441.F63205B7@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521165641.15940-1-kristen@linux.intel.com>

On Thu, May 21, 2020 at 09:56:31AM -0700, Kristen Carlson Accardi wrote:
> Changes in v2:
> --------------
> * Fix to address i386 build failure
> * Allow module reordering patch to be configured separately so that
>   arm (or other non-x86_64 arches) can take advantage of module function
>   reordering. This support has not be tested by me, but smoke tested by
>   Ard Biesheuvel <ardb@kernel.org> on arm.
> * Fix build issue when building on arm as reported by
>   Ard Biesheuvel <ardb@kernel.org> 
> * minor chages for certain checkpatch warnings and review feedback.

I successfully built and booted this on top of linux-next. For my builds
I include:

CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y

which catches various things. One of those (I assume either CONFIG_LOCKDEP
or CONFIG_DEBUG_MUTEXES) has found an issue with kallsyms:

[   34.112989] ------------[ cut here ]------------
[   34.113560] WARNING: CPU: 1 PID: 1997 at kernel/module.c:260 module_assert_mutex+0x29/0x30
[   34.114479] Modules linked in:
[   34.114831] CPU: 1 PID: 1997 Comm: grep Tainted: G        W 5.7.0-rc6-next-20200519+ #497
...
[   34.128556] Call Trace:
[   34.128867]  module_kallsyms_on_each_symbol+0x1d/0xa0
[   34.130238]  kallsyms_on_each_symbol+0xbd/0xd0
[   34.131642]  kallsyms_sorted_open+0x3f/0x70
[   34.132160]  proc_reg_open+0x99/0x180
[   34.133222]  do_dentry_open+0x176/0x400
[   34.134182]  vfs_open+0x2d/0x30
[   34.134579]  do_open.isra.0+0x2a0/0x410
[   34.135058]  path_openat+0x175/0x620
[   34.135506]  do_filp_open+0x91/0x100
[   34.136912]  do_sys_openat2+0x210/0x2d0
[   34.137388]  do_sys_open+0x46/0x80
[   34.137818]  __x64_sys_openat+0x20/0x30
[   34.138288]  do_syscall_64+0x55/0x1d0
[   34.138720]  entry_SYSCALL_64_after_hwframe+0x49/0xb3

Triggering it is easy, just "cat /proc/kallsyms" (and I'd note that I
don't even have any modules loaded). Tracking this down, it just looks
like kallsyms needs to hold a lock while sorting:


diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 558963b275ec..182b16a6079b 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -772,7 +772,9 @@ static int kallsyms_sorted_open(struct inode *inode, struct file *file)
 
 	INIT_LIST_HEAD(list);
 
+	mutex_lock(&module_mutex);
 	ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
+	mutex_unlock(&module_mutex);
 	if (ret != 0)
 		return ret;
 

This fixes it for me. Everything else seems to be lovely. :) Nice work!

-- 
Kees Cook
