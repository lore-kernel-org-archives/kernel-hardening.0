Return-Path: <SRS0=6Jt0=OV=lists.openwall.com=kernel-hardening-return-21405-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23570C433EF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Oct 2021 12:24:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4E3F56136A
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Oct 2021 12:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4E3F56136A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5793 invoked by uid 550); 1 Oct 2021 12:24:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5761 invoked from network); 1 Oct 2021 12:24:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1633091029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wtBZ7U5ewDlKJ28ZtqZTNSvN7kEYRmILRT2iVxUTj2c=;
	b=m/wphk5uR59ODqBgPtgUELkhpG+snjW4Ik51wxuXL7I+dgCA/YWVS6i8kfqV3u/+B2rFRf
	nuk6zDSKvhAs2QhrlRxWlDH53/17tz18jDnmmyRctW1FYjWNFKCdFZkZjrQGIpTzSWjafn
	dUFZjBihk0jDWceRW3LSio4aswzbFdw=
Date: Fri, 1 Oct 2021 14:23:48 +0200
From: Petr Mladek <pmladek@suse.com>
To: Alexander Popov <alex.popov@linux.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
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
	Will Deacon <will.deacon@arm.com>,
	David S Miller <davem@davemloft.net>,
	Borislav Petkov <bp@alien8.de>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, notify@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] Introduce the pkill_on_warn boot parameter
Message-ID: <20211001122348.GB965@pathway.suse.cz>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <d290202d-a72d-0821-9edf-efbecf6f6cef@linux.com>
 <20210929194924.GA880162@paulmck-ThinkPad-P17-Gen-1>
 <YVWAPXSzFNbHz6+U@alley>
 <a09c1d4d-1d5b-9092-ae3a-61bc22689dd2@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a09c1d4d-1d5b-9092-ae3a-61bc22689dd2@linux.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu 2021-09-30 18:05:54, Alexander Popov wrote:
> On 30.09.2021 12:15, Petr Mladek wrote:
> > On Wed 2021-09-29 12:49:24, Paul E. McKenney wrote:
> >> On Wed, Sep 29, 2021 at 10:01:33PM +0300, Alexander Popov wrote:
> >>> This patch was tested using CONFIG_LKDTM.
> >>> The kernel kills a process that performs this:
> >>>   echo WARNING > /sys/kernel/debug/provoke-crash/DIRECT
> >>>
> >>> If you are fine with this approach, I will prepare a patch adding the
> >>> pkill_on_warn sysctl.
> >>
> >> I suspect that you need a list of kthreads for which you are better
> >> off just invoking panic().  RCU's various kthreads, for but one set
> >> of examples.
> > 
> > I wonder if kernel could survive killing of any kthread. I have never
> > seen a code that would check whether a kthread was killed and
> > restart it.
> 
> The do_group_exit() function calls do_exit() from kernel/exit.c, which is also
> called during a kernel oops. This function cares about a lot of special cases
> depending on the current task_struct. Is it fine?

IMHO, the bigger problem is that nobody will start the kthreads again.
As a result, some kernel functionality will not longer work.

User space threads are different. The user/admin typically
have a chance to start them again.

We might get inspiration in OOM killer. It never kills kthreads
and the init process, see oom_unkillable_task().

It would be better to panic() when WARN() is called from a kthread
or the init process.

Best Regards,
Petr
