Return-Path: <SRS0=VluL=OU=lists.openwall.com=kernel-hardening-return-21396-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C071CC433F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 09:16:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3B37619E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Sep 2021 09:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C3B37619E2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 20170 invoked by uid 550); 30 Sep 2021 09:15:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20148 invoked from network); 30 Sep 2021 09:15:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1632993343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9v0cDRtjz+Qty/pNK3HqvGsd28WaeRcwU5KxIB9csFA=;
	b=nvKK1nWNV14UaTB8IMbYFWni08fMq6+3Den+i80jpAm5/5C9GCcUabZH8roBfEgwoFdq5Q
	kxn1AaTyRLa4hKXlWJ3AgVAU1TN37JVEOL8nP0x/91KmBDNZItHeUvMCH9oQfdfPS8KuFW
	TgPlALRx6BRJlaCBuXXW/dA4dHSvfHQ=
Date: Thu, 30 Sep 2021 11:15:41 +0200
From: Petr Mladek <pmladek@suse.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Joerg Roedel <jroedel@suse.de>, Maciej Rozycki <macro@orcam.me.uk>,
	Muchun Song <songmuchun@bytedance.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
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
	linux-kernel@vger.kernel.org, notify@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <YVWAPXSzFNbHz6+U@alley>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>

On Wed 2021-09-29 12:49:24, Paul E. McKenney wrote:
> On Wed, Sep 29, 2021 at 10:01:33PM +0300, Alexander Popov wrote:
> > On 29.09.2021 21:58, Alexander Popov wrote:
> > > Currently, the Linux kernel provides two types of reaction to kernel
> > > warnings:
> > >  1. Do nothing (by default),
> > >  2. Call panic() if panic_on_warn is set. That's a very strong reaction,
> > >     so panic_on_warn is usually disabled on production systems.

Honestly, I am not sure if panic_on_warn() or the new pkill_on_warn()
work as expected. I wonder who uses it in practice and what is
the experience.

The problem is that many developers do not know about this behavior.
They use WARN() when they are lazy to write more useful message or when
they want to see all the provided details: task, registry, backtrace.

Also it is inconsistent with pr_warn() behavior. Why a single line
warning would be innocent and full info WARN() cause panic/pkill?

What about pr_err(), pr_crit(), pr_alert(), pr_emerg()? They inform
about even more serious problems. Why a warning should cause panic/pkill
while an alert message is just printed?


It somehow reminds me the saga with %pK. We were not able to teach
developers to use it correctly for years and ended with hashed
pointers.

Well, this might be different. Developers might learn this the hard
way from bug reports. But there will be bug reports only when
anyone really enables this behavior. They will enable it only
when it works the right way most of the time.


> > > From a safety point of view, the Linux kernel misses a middle way of
> > > handling kernel warnings:
> > >  - The kernel should stop the activity that provokes a warning,
> > >  - But the kernel should avoid complete denial of service.
> > > 
> > > From a security point of view, kernel warning messages provide a lot of
> > > useful information for attackers. Many GNU/Linux distributions allow
> > > unprivileged users to read the kernel log, so attackers use kernel
> > > warning infoleak in vulnerability exploits. See the examples:
> > >   https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> > >   https://a13xp0p0v.github.io/2021/02/09/CVE-2021-26708.html
> > > 
> > > Let's introduce the pkill_on_warn boot parameter.
> > > If this parameter is set, the kernel kills all threads in a process
> > > that provoked a kernel warning. This behavior is reasonable from a safety
> > > point of view described above. It is also useful for kernel security
> > > hardening because the system kills an exploit process that hits a
> > > kernel warning.
> > > 
> > > Signed-off-by: Alexander Popov <alex.popov@linux.com>
> > 
> > This patch was tested using CONFIG_LKDTM.
> > The kernel kills a process that performs this:
> >   echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
> > 
> > If you are fine with this approach, I will prepare a patch adding the
> > pkill_on_warn sysctl.
> 
> I suspect that you need a list of kthreads for which you are better
> off just invoking panic().  RCU's various kthreads, for but one set
> of examples.

I wonder if kernel could survive killing of any kthread. I have never
seen a code that would check whether a kthread was killed and
restart it.

Best Regards,
Petr
