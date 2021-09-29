Return-Path: <SRS0=dwfT=OT=lists.openwall.com=kernel-hardening-return-21393-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90429C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 19:53:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AED8E61462
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Sep 2021 19:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AED8E61462
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 13527 invoked by uid 550); 29 Sep 2021 19:52:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13507 invoked from network); 29 Sep 2021 19:52:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hFOGKPuhhfj9xW2jOvQT+nHKqB9j9dqpkjZzQyMzNZA=; b=K2nrTG3EL0nN/zraOAxNEfggL3
	ZYhqUqepv1ta3h4uZsqjlg/0fZuacEQEUAbxOtGaBpOctsemaHQhZCJVR/Q4wUMsopgTQe5k2Ao/r
	NSAelQStPA5CrdRxuiBXZC5yhCRvrNBE6DBpy2Rfp6cq4oTcLt6BYZprH+qoaR5LVDPU26EKQxOFv
	694jxJgFnaNkRm25H57+eZVm5bysToxe7o/S9ScyfFMQZAc+uGUyxuKLYNqSRY7lbGzAESYupmfpy
	hI8Z+4BJXToUIq3yJQB6d4aJ62cwqm7GAwumMYoxEL6czAG0GJSR8PzxSYEL4umpUjsLvlG4fCljD
	uvbQWjHg==;
Date: Wed, 29 Sep 2021 21:47:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Alexander Popov <alex.popov@linux.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Paul McKenney <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20210929194735.GB4323@worktop.programming.kicks-ass.net>
References: <20210929185823.499268-1-alex.popov@linux.com>
 <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323d0784-249d-7fef-6c60-e8426d35b083@intel.com>

On Wed, Sep 29, 2021 at 12:03:36PM -0700, Dave Hansen wrote:
> On 9/29/21 11:58 AM, Alexander Popov wrote:
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
> 
> Doesn't this tie into the warning *printing* code?  That's better than
> nothing, for sure.  But, if we're doing this for hardening, I think we
> would want to kill anyone provoking a warning, not just the first one
> that triggered *printing* the warning.

Right, that would be lib/bug.c:report_bug(), for most archs I suppose.
