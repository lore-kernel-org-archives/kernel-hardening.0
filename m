Return-Path: <SRS0=tP+M=P7=lists.openwall.com=kernel-hardening-return-21463-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A387C433F5
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 18:53:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9954160F93
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 18:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9954160F93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 9779 invoked by uid 550); 12 Nov 2021 18:53:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9744 invoked from network); 12 Nov 2021 18:53:01 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Iawy8hM8eRyCMBEMC4y1moygOWRTeool6h66VnaFg/k=;
        b=n9qik/PNdef+tSS63gtmde1lRDExB9qmXXitSdRqJOuUWk+1DWGBy78kkhDSkduZQi
         N8HsOEQB1sebUQVkoeEkUkwxpj7aQNn4AAJxPc0mYcsJWwbvrOUQohGnrZNkTE3s6r3H
         l7yrGrIvZtRMI7pBL674y6cZVljuEEOlvokXDUEvYef2f/t+PY/iAnXW6kbte+ypDZgh
         A79AYWbQjb7FeU3Ac8DthG+UtWRvqwEuzQjHMiZsxOL8+xY05AUH3dHwU0jkdyJWezR3
         /5cKg+F5ckgsW9sxS3AhhxoO1BXGGy00R8W19vPh+/1Ezvlc76JM/VoV/WlwopBIo0av
         GtTQ==
X-Gm-Message-State: AOAM530ZFPkZwRfjzvJbvDjC9PzApDlNDOuNls7mjLwFgyQnP7eojxG8
	d/382gFcUwLv89NOKSZ/o3I=
X-Google-Smtp-Source: ABdhPJwoNfruuYTvSVpxsn9iT2utV+KOqOD0XFVXh8/k9BMPHVsZUaxfTQcSxhRcSsx36Ytc7ut/oA==
X-Received: by 2002:a50:e608:: with SMTP id y8mr23538543edm.39.1636743169660;
        Fri, 12 Nov 2021 10:52:49 -0800 (PST)
Message-ID: <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
Date: Fri, 12 Nov 2021 21:52:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] Introduce the pkill_on_warn parameter
Content-Language: en-US
To: Jonathan Corbet <corbet@lwn.net>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Paul McKenney <paulmck@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>,
 Maciej Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>,
 Viresh Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>,
 Randy Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 Petr Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>,
 John Ogness <john.ogness@linutronix.de>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Laura Abbott <labbott@kernel.org>,
 David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Scull <ascull@google.com>,
 Marc Zyngier <maz@kernel.org>, Jessica Yu <jeyu@kernel.org>,
 Iurii Zaikin <yzaikin@google.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>,
 Mel Gorman <mgorman@suse.de>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Andrew Klychkov <andrew.a.klychkov@gmail.com>,
 Mathieu Chouquet-Stringer <me@mathieu.digital>,
 Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt <steve@sk2.org>,
 Stephen Boyd <sboyd@kernel.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Mike Rapoport <rppt@kernel.org>, Bjorn Andersson
 <bjorn.andersson@linaro.org>, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: notify@kernel.org
References: <20211027233215.306111-1-alex.popov@linux.com>
From: Alexander Popov <alex.popov@linux.com>
In-Reply-To: <20211027233215.306111-1-alex.popov@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.10.2021 02:32, Alexander Popov wrote:
> Hello! This is the v2 of pkill_on_warn.
> Changes from v1 and tricks for testing are described below.

Hello everyone!
Friendly ping for your feedback.

Thanks.
Alexander

> Rationale
> =========
> 
> Currently, the Linux kernel provides two types of reaction to kernel
> warnings:
>   1. Do nothing (by default),
>   2. Call panic() if panic_on_warn is set. That's a very strong reaction,
>      so panic_on_warn is usually disabled on production systems.
> 
>  From a safety point of view, the Linux kernel misses a middle way of
> handling kernel warnings:
>   - The kernel should stop the activity that provokes a warning,
>   - But the kernel should avoid complete denial of service.
> 
>  From a security point of view, kernel warning messages provide a lot of
> useful information for attackers. Many GNU/Linux distributions allow
> unprivileged users to read the kernel log, so attackers use kernel
> warning infoleak in vulnerability exploits. See the examples:
> https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
> https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
> 
> Let's introduce the pkill_on_warn sysctl.
> If this parameter is set, the kernel kills all threads in a process that
> provoked a kernel warning. This behavior is reasonable from a safety point of
> view described above. It is also useful for kernel security hardening because
> the system kills an exploit process that hits a kernel warning.
> 
> Moreover, bugs usually don't come alone, and a kernel warning may be
> followed by memory corruption or other bad effects. So pkill_on_warn allows
> the kernel to stop the process when the first signs of wrong behavior
> are detected.
> 
> 
> Changes from v1
> ===============
> 
> 1) Introduce do_pkill_on_warn() and call it in all warning handling paths.
> 
> 2) Do refactoring without functional changes in a separate patch.
> 
> 3) Avoid killing init and kthreads.
> 
> 4) Use do_send_sig_info() instead of do_group_exit().
> 
> 5) Introduce sysctl instead of using core_param().
> 
> 
> Tricks for testing
> ==================
> 
> 1) This patch series was tested on x86_64 using CONFIG_LKDTM.
> The kernel kills a process that performs this:
>    echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
> 
> 2) The warn_slowpath_fmt() path was tested using this trick:
> diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
> index 84b87538a15d..3106c203ebb6 100644
> --- a/arch/x86/include/asm/bug.h
> +++ b/arch/x86/include/asm/bug.h
> @@ -73,7 +73,7 @@ do {                                                          \
>    * were to trigger, we'd rather wreck the machine in an attempt to get the
>    * message out than not know about it.
>    */
> -#define __WARN_FLAGS(flags)                                    \
> +#define ___WARN_FLAGS(flags)                                   \
>   do {                                                           \
>          instrumentation_begin();                                \
>          _BUG_FLAGS(ASM_UD2, BUGFLAG_WARNING|(flags));           \
> 
> 3) Testing pkill_on_warn with kthreads was done using this trick:
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index bce848e50512..13c56f472681 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -2133,6 +2133,8 @@ static int __noreturn rcu_gp_kthread(void *unused)
>                  WRITE_ONCE(rcu_state.gp_state, RCU_GP_CLEANUP);
>                  rcu_gp_cleanup();
>                  WRITE_ONCE(rcu_state.gp_state, RCU_GP_CLEANED);
> +
> +               WARN_ONCE(1, "hello from kthread\n");
>          }
>   }
> 
> 4) Changing drivers/misc/lkdtm/bugs.c:lkdtm_WARNING() allowed me
> to test all warning flavours:
>   - WARN_ON()
>   - WARN()
>   - WARN_TAINT()
>   - WARN_ON_ONCE()
>   - WARN_ONCE()
>   - WARN_TAINT_ONCE()
> 
> Thanks!
> 
> Alexander Popov (2):
>    bug: do refactoring allowing to add a warning handling action
>    sysctl: introduce kernel.pkill_on_warn
> 
>   Documentation/admin-guide/sysctl/kernel.rst | 14 ++++++++
>   include/asm-generic/bug.h                   | 37 +++++++++++++++------
>   include/linux/panic.h                       |  3 ++
>   kernel/panic.c                              | 22 +++++++++++-
>   kernel/sysctl.c                             |  9 +++++
>   lib/bug.c                                   | 22 ++++++++----
>   6 files changed, 90 insertions(+), 17 deletions(-)
> 

