Return-Path: <SRS0=9WEN=OT=lists.openwall.com=kernel-hardening-return-21395-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D24C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 23:32:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CBAAB61507
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 23:32:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CBAAB61507
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 1924 invoked by uid 550); 29 Sep 2021 23:31:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1897 invoked from network); 29 Sep 2021 23:31:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1632958305;
	bh=gDC8FeyWEK+m6y1oljAXM/J6NEZQW93X8rLKfj3knFM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NN3ijR4TISmoUJq81Zy37jY9PjgUYWr1BP/sBn1OfDNimXfNczZOTVlBRFYi7KdEr
	 RW3FtjLpG7VUwM3JHrL8iT/N71iEhCjuMHpQ9p1+bEiLpk/Yb7F3BjkQeuutBDFOuo
	 4y8StbCdPsAQAqoV6S/9tsLkZcjUHrmh5gA8n9kA=
Date: Wed, 29 Sep 2021 16:31:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alex.popov@linux.com
Cc: Jonathan Corbet <corbet@lwn.net>, Paul McKenney <paulmck@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra
 <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, Maciej Rozycki
 <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, Viresh Kumar
 <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Petr
 Mladek <pmladek@suse.com>, Kees Cook <keescook@chromium.org>, Luis
 Chamberlain <mcgrof@kernel.org>, Wei Liu <wl@xen.org>, John Ogness
 <john.ogness@linutronix.de>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark
 Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Thomas Garnier <thgarnie@google.com>, Will Deacon <will.deacon@arm.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott
 <labbott@redhat.com>, David S Miller <davem@davemloft.net>, Borislav Petkov
 <bp@alien8.de>, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, notify@kernel.org
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-Id: <20210929163143.aa8b70ac9d5cf0b628823370@linux-foundation.org>
In-Reply-To: <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
References: <20210929185823.499268-1-alex.popov@linux.com>
	<d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Sep 2021 22:01:33 +0300 Alexander Popov <alex.popov@linux.com> wrote:

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

Why do we need a boot parameter?  Isn't a sysctl all we need for this
feature?

Also, 

	if (pkill_on_warn && system_state >= SYSTEM_RUNNING)
		do_group_exit(SIGKILL);

- why do we care about system_state?  An explanatory code comment
  seems appropriate.

- do we really want to do this in states > SYSTEM_RUNNING?  If so, why?
