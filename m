Return-Path: <SRS0=WVvp=OT=lists.openwall.com=kernel-hardening-return-21392-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F088C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 19:49:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A368261462
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 19:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A368261462
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 9473 invoked by uid 550); 29 Sep 2021 19:49:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9443 invoked from network); 29 Sep 2021 19:49:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1632944964;
	bh=RCKQpg6aiz4Y9fPYcSghXnoRac3MFMpvYTPY8Mo6PQg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=qMRZEt6iSy2H7y+pvJRvlJW+JjzXzQNPxL6gVS71pais8DGDEILD6LmrDGMxrL8f0
	 ZbrWnvez97yhBGwmmAWpSxZkQzAveqPKNirHZjoJOiBrS1gPo7hTKS9eEC3ZNBnqGj
	 SUCZONbIx9PVl1YveGfKCurZ5IuRTELe4zXuUW8F0Umy9xPjD5TPQlhF4stNJhD22d
	 Nzw9IJb71BImaaZL42CuuJRKVqyePwHhgXm3L81iN7ih4Onsm82BlZZxrh29lWoA9d
	 tEpNokDFUKxgWjrat20JzW5Es9aZikeWXsnDD43mqTo3URGnqp2ZFOf3hvRzEkpmD9
	 cRJa0HFNj8vSA==
Date: Wed, 29 Sep 2021 12:49:24 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
	Muchun Song <songmuchun@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Petr Mladek <pmladek@suse.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>,
	John Ogness <john.ogness@linutronix.de>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Garnier <thgarnie@google.com>,
	Will Deacon <will.deacon@arm.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Laura Abbott <labbott@redhat.com>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>

On Wed, Sep 29, 2021 at 10:01:33PM +0300, Alexander Popov wrote:
> On 29.09.2021 21:58, Alexander Popov wrote:
> > Currently, the Linux kernel provides two types of reaction to kernel
> > warnings:
> >  1. Do nothing (by default),
> >  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
> >     so panic_on_warn is usually disabled on production systems.
> > 
> > From a safety point of view, the Linux kernel misses a middle way of
> > handling kernel warnings:
> >  - The kernel should stop the activity that provokes a warning,
> >  - But the kernel should avoid complete denial of service.
> > 
> > From a security point of view, kernel warning messages provide a lot of
> > useful information for attackers. Many GNU/Linux distributions allow
> > unprivileged users to read the kernel log, so attackers use kernel
> > warning infoleak in vulnerability exploits. See the examples:
> >   https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> >   https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
> > 
> > Let's introduce the pkill_on_warn boot parameter.
> > If this parameter is set, the kernel kills all threads in a process
> > that provoked a kernel warning. This behavior is reasonable from a safety
> > point of view described above. It is also useful for kernel security
> > hardening because the system kills an exploit process that hits a
> > kernel warning.
> > 
> > Signed-off-by: Alexander Popov <alex.popov@linux.com>
> 
> This patch was tested using CONFIG_LKDTM.
> The kernel kills a process that performs this:
>   echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
> 
> If you are fine with this approach, I will prepare a patch adding the
> pkill_on_warn sysctl.

I suspect that you need a list of kthreads for which you are better
off just invoking panic().  RCU's various kthreads, for but one set
of examples.

							Thanx, Paul

> Best regards,
> Alexander
> 
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt | 4 ++++
> >  kernel/panic.c                                  | 5 +++++
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 91ba391f9b32..86c748907666 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -4112,6 +4112,10 @@
> >  	pirq=		[SMP,APIC] Manual mp-table setup
> >  			See Documentation/x86/i386/IO-APIC.rst.
> >  
> > +	pkill_on_warn=	Kill all threads in a process that provoked a
> > +			kernel warning.
> > +			Format: { "0" | "1" }
> > +
> >  	plip=		[PPT,NET] Parallel port network link
> >  			Format: { parport<nr> | timid | 0 }
> >  			See also Documentation/admin-guide/parport.rst.
> > diff --git a/kernel/panic.c b/kernel/panic.c
> > index cefd7d82366f..47b728bfb1d3 100644
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -53,6 +53,7 @@ static int pause_on_oops_flag;
> >  static DEFINE_SPINLOCK(pause_on_oops_lock);
> >  bool crash_kexec_post_notifiers;
> >  int panic_on_warn __read_mostly;
> > +int pkill_on_warn __read_mostly;
> >  unsigned long panic_on_taint;
> >  bool panic_on_taint_nousertaint = false;
> >  
> > @@ -610,6 +611,9 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
> >  
> >  	print_oops_end_marker();
> >  
> > +	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
> > +		do_group_exit(SIGKILL);
> > +
> >  	/* Just a warning, don't kill lockdep. */
> >  	add_taint(taint, LOCKDEP_STILL_OK);
> >  }
> > @@ -694,6 +698,7 @@ core_param(panic, panic_timeout, int, 0644);
> >  core_param(panic_print, panic_print, ulong, 0644);
> >  core_param(pause_on_oops, pause_on_oops, int, 0644);
> >  core_param(panic_on_warn, panic_on_warn, int, 0644);
> > +core_param(pkill_on_warn, pkill_on_warn, int, 0644);
> >  core_param(crash_kexec_post_notifiers, crash_kexec_post_notifiers, bool, 0644);
> >  
> >  static int __init oops_setup(char *s)
> > 
> 
