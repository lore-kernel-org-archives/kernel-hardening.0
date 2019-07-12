Return-Path: <SRS0=WI1U=VJ=lists.openwall.com=kernel-hardening-return-16441-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36813C742D7
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 19:41:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2B560205C9
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 19:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="bmxPnZXF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B560205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16441-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16380 invoked by uid 550); 12 Jul 2019 19:40:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16357 invoked from network); 12 Jul 2019 19:40:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nAJsR7QXwSJc647spM+sQunAoBzpCrSmQsX27huBu+o=;
        b=bmxPnZXFh5gOCfuOus2gHM6f6oGNgMKP/ji63JlI+bwUXl3Gpe3vjP96TTAKXaJCZC
         zj7Y8eFA2XvcXUe8SUv1NKdUvs12xq4vmo946+SPEoJfJYl3KKJWKjnEQtWp8b/06x77
         32gH3YSvwVXKePdbdirKmPWfh8K3q8ksM+3uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nAJsR7QXwSJc647spM+sQunAoBzpCrSmQsX27huBu+o=;
        b=DPUXIfUmr3t1PBs+0p82bdNE8o02NOHPaGBo2zglsBfUmqPey3d2PShadUqX1Jbe6x
         c7HwVu87O2aKVCo6KcLcbfOgdg5pZR1wFlMBqyJjeWrYrVVcoI3HuYqyteWbRzMXpfps
         kKwphj/fQ8MEdzhSQM4uXA0ExayOhPX3pUD9D/AfJ02S9AKqVF0IA8EcHb7VPI+qJmxm
         XayoYI9Afc5qUr8Lz89sJQa29aZoaHPN+ZlhfE14K2EHnz3h4joqFR/myylJr9Iha/XI
         n7FZ5cknha4EKprMbvQDW2lU42ANMPnrEb5aO+iMOyyNS/wMl0yEs9lwRyt+tmxWJbIb
         aXyQ==
X-Gm-Message-State: APjAAAX+4RlJ68ZlE2jPlJJnR5+aInssqqkAjHZnZiPz0XN05nJ5uc7d
	0rpZRssEqJo2SRK7Ygkmpg8=
X-Google-Smtp-Source: APXvYqxvgkL0vpDAZ6Hy5r4mm056ssuxGSXpd+iPIILPiTDSys89aOnq2iGFem/k4lcJZbyW+r6SIQ==
X-Received: by 2002:a63:2246:: with SMTP id t6mr12863936pgm.209.1562960443485;
        Fri, 12 Jul 2019 12:40:43 -0700 (PDT)
Date: Fri, 12 Jul 2019 15:40:40 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, oleg@redhat.com,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712194040.GA150253@google.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
 <20190712164531.GW26519@linux.ibm.com>
 <20190712170631.GA111598@google.com>
 <20190712174630.GX26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712174630.GX26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 10:46:30AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 12, 2019 at 01:06:31PM -0400, Joel Fernandes wrote:
> > On Fri, Jul 12, 2019 at 09:45:31AM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> > > > On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> > > > > On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > > > > > +int rcu_read_lock_any_held(void)
> > > > > > +{
> > > > > > +	int lockdep_opinion = 0;
> > > > > > +
> > > > > > +	if (!debug_lockdep_rcu_enabled())
> > > > > > +		return 1;
> > > > > > +	if (!rcu_is_watching())
> > > > > > +		return 0;
> > > > > > +	if (!rcu_lockdep_current_cpu_online())
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	/* Preemptible RCU flavor */
> > > > > > +	if (lock_is_held(&rcu_lock_map))
> > > > > 
> > > > > you forgot debug_locks here.
> > > > 
> > > > Actually, it turns out debug_locks checking is not even needed. If
> > > > debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
> > > > get to this point.
> > > > 
> > > > > > +		return 1;
> > > > > > +
> > > > > > +	/* BH flavor */
> > > > > > +	if (in_softirq() || irqs_disabled())
> > > > > 
> > > > > I'm not sure I'd put irqs_disabled() under BH, also this entire
> > > > > condition is superfluous, see below.
> > > > > 
> > > > > > +		return 1;
> > > > > > +
> > > > > > +	/* Sched flavor */
> > > > > > +	if (debug_locks)
> > > > > > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > > > > +	return lockdep_opinion || !preemptible();
> > > > > 
> > > > > that !preemptible() turns into:
> > > > > 
> > > > >   !(preempt_count()==0 && !irqs_disabled())
> > > > > 
> > > > > which is:
> > > > > 
> > > > >   preempt_count() != 0 || irqs_disabled()
> > > > > 
> > > > > and already includes irqs_disabled() and in_softirq().
> > > > > 
> > > > > > +}
> > > > > 
> > > > > So maybe something lke:
> > > > > 
> > > > > 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> > > > > 			    lock_is_held(&rcu_sched_lock_map)))
> > > > > 		return true;
> > > > 
> > > > Agreed, I will do it this way (without the debug_locks) like:
> > > > 
> > > > ---8<-----------------------
> > > > 
> > > > diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > > > index ba861d1716d3..339aebc330db 100644
> > > > --- a/kernel/rcu/update.c
> > > > +++ b/kernel/rcu/update.c
> > > > @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
> > > >  
> > > >  int rcu_read_lock_any_held(void)
> > > >  {
> > > > -	int lockdep_opinion = 0;
> > > > -
> > > >  	if (!debug_lockdep_rcu_enabled())
> > > >  		return 1;
> > > >  	if (!rcu_is_watching())
> > > >  		return 0;
> > > >  	if (!rcu_lockdep_current_cpu_online())
> > > >  		return 0;
> > > > -
> > > > -	/* Preemptible RCU flavor */
> > > > -	if (lock_is_held(&rcu_lock_map))
> > > > -		return 1;
> > > > -
> > > > -	/* BH flavor */
> > > > -	if (in_softirq() || irqs_disabled())
> > > > -		return 1;
> > > > -
> > > > -	/* Sched flavor */
> > > > -	if (debug_locks)
> > > > -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > > -	return lockdep_opinion || !preemptible();
> > > > +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> > > 
> > > OK, I will bite...  Why not also lock_is_held(&rcu_bh_lock_map)?
> > 
> > Hmm, I was borrowing the strategy from rcu_read_lock_bh_held() which does not
> > check for a lock held in this map.
> > 
> > Honestly, even  lock_is_held(&rcu_sched_lock_map) seems unnecessary per-se
> > since !preemptible() will catch that? rcu_read_lock_sched() disables
> > preemption already, so lockdep's opinion of the matter seems redundant there.
> 
> Good point!  At least as long as the lockdep splats list RCU-bh among
> the locks held, which they did last I checked.
> 
> Of course, you could make the same argument for getting rid of
> rcu_sched_lock_map.  Does it make sense to have the one without
> the other?

It probably makes it inconsistent in the least. I will add the check for
the rcu_bh_lock_map in a separate patch, if that's Ok with you - since I also
want to update the rcu_read_lock_bh_held() logic in the same patch.

That rcu_read_lock_bh_held() could also just return !preemptible as Peter
suggested for the bh case.

> > Sorry I already sent out patches again before seeing your comment but I can
> > rework and resend them based on any other suggestions.
> 
> Not a problem!

Thanks. Depending on whether there is any other feedback, I will work on the
bh_ stuff as a separate patch on top of this series, or work it into the next
series revision if I'm reposting. Hopefully that sounds Ok to you.

thanks,

 - Joel


