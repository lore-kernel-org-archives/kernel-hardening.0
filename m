Return-Path: <SRS0=nJID=OW=lists.openwall.com=kernel-hardening-return-21408-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186D7C433EF
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 12:14:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 18C4061AFB
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Oct 2021 12:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 18C4061AFB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 15907 invoked by uid 550); 2 Oct 2021 12:14:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15871 invoked from network); 2 Oct 2021 12:14:14 -0000
Date: Sat, 2 Oct 2021 08:13:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Petr Mladek
 <pmladek@suse.com>, "Paul E. McKenney" <paulmck@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Thomas
 Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Joerg
 Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>, Muchun Song
 <songmuchun@bytedance.com>, Viresh Kumar <viresh.kumar@linaro.org>, Robin
 Murphy <robin.murphy@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Lu
 Baolu <baolu.lu@linux.intel.com>, Kees Cook <keescook@chromium.org>, Luis
 Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness
 <john.ogness@linutronix.de>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark
 Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>,
 David S Miller <davem@davemloft.net>, Borislav Petkov <bp@alien8.de>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-hardening@vger.kernel.org, "open list:DOCUMENTATION"
 <linux-doc@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <20211002081359.5de4e2b1@oasis.local.home>
In-Reply-To: <ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
References: <20210929185823.499268-1-alex.popov@linux.com>
	<d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
	<20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>
	<YVWAPXSzFNbHz6+U@alley>
	<CAHk-=widOm3FXMPXXK0cVaoFuy3jCk65=5VweLceQCuWdep=Hg@mail.gmail.com>
	<ba67ead7-f075-e7ad-3274-d9b2bc4c1f44@linux.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 2 Oct 2021 14:41:34 +0300
Alexander Popov <alex.popov@linux.com> wrote:

> Currently, the Linux kernel provides two types of reaction to kernel warnings:
>  1. Do nothing (by default),
>  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
>     so panic_on_warn is usually disabled on production systems.
> 
> >From a safety point of view, the Linux kernel misses a middle way of handling  
> kernel warnings:
>  - The kernel should stop the activity that provokes a warning,
>  - But the kernel should avoid complete denial of service.
> 
> >From a security point of view, kernel warning messages provide a lot of useful  
> information for attackers. Many GNU/Linux distributions allow unprivileged users
> to read the kernel log (for various reasons), so attackers use kernel warning
> infoleak in vulnerability exploits. See the examples:
> https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
> https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html
> 
> Let's introduce the pkill_on_warn parameter.
> If this parameter is set, the kernel kills all threads in a process that
> provoked a kernel warning. This behavior is reasonable from a safety point of
> view described above. It is also useful for kernel security hardening because
> the system kills an exploit process that hits a kernel warning.

How does this help? It only kills the process that caused the warning,
it doesn't kill the process that spawned it. This is trivial to get
around. Just fork a process, trigger the warning (it gets killed) and
then read the kernel log.

If this is your rationale, then I'm not convinced this helps at all.

-- Steve
