Return-Path: <SRS0=5oOr=VJ=lists.openwall.com=kernel-hardening-return-16426-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A444AC742C8
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 15:11:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0474A206B8
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 15:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="xyHw0p49"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0474A206B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16426-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10101 invoked by uid 550); 12 Jul 2019 15:11:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10083 invoked from network); 12 Jul 2019 15:11:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bpkdGumnCxVJ5QkvopMAKHuDk2Cmi1QHk5zgDoY3xmE=;
        b=xyHw0p49aGG+bHJkAwOFsAyVLIy6ynGQUOVqJSZW2rdYBcMge9BS0dv8b3pXcc+QsB
         52ZjWyLo4eCKwwXkK1MywW+/ICPskgQBpOWaqdYt311VFlay/UvS+NI+iDdRBDC8nfQH
         7iG2DsYxsndMDH8pWwOufpGY4o74/6StEFO8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bpkdGumnCxVJ5QkvopMAKHuDk2Cmi1QHk5zgDoY3xmE=;
        b=Jcc+gaQtMDn95OKRCd3Sr6QFi6yNzDHp9bc3ba8DRFMhZ8rEkti95QMYPXajmz9fGz
         OU2vP5svGd0iR+oB+OoGVTZlQr2iic2M+XTbi4WiHlxJACy1DsRifL7Z1yl85+RzD+C9
         RtH/MIYoBRW71Jsw95lGNx4yqvn042M184izYVLY7ueqlaxYqw59VvP8oc2exJl01KzI
         MPL/pNhqwueJo4QihhjLxnW+u+SkNbx1hVUNNyxLZAUW/dd/f1E9kktusgQJl6+riA1r
         XvMY7dJNFbPgRLV9nBMGVfIm+ZZFDzwTi71j5B7hElSYnVZ0xVCtX/tr0ZMB6T0/uVpG
         EWag==
X-Gm-Message-State: APjAAAXMQUu+OHqUE32F/J9cP2J0cA4xSUsaLN0fwlGvZe04/vMU/8mG
	vBFXnAuL+ezO47jO1/y1FKk=
X-Google-Smtp-Source: APXvYqxJ7Kem+nQt02Z16GBq/vs2O/YsBJDeceBJIv6amPGaj5XayXNv7u5mL3pmC3eI8AkB/Vv2gw==
X-Received: by 2002:a17:902:6a88:: with SMTP id n8mr12077228plk.70.1562944253560;
        Fri, 12 Jul 2019 08:10:53 -0700 (PDT)
Date: Fri, 12 Jul 2019 11:10:51 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
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
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712151051.GB235410@google.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712111125.GT3402@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > +int rcu_read_lock_any_held(void)
> > +{
> > +	int lockdep_opinion = 0;
> > +
> > +	if (!debug_lockdep_rcu_enabled())
> > +		return 1;
> > +	if (!rcu_is_watching())
> > +		return 0;
> > +	if (!rcu_lockdep_current_cpu_online())
> > +		return 0;
> > +
> > +	/* Preemptible RCU flavor */
> > +	if (lock_is_held(&rcu_lock_map))
> 
> you forgot debug_locks here.

Actually, it turns out debug_locks checking is not even needed. If
debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
get to this point.

> > +		return 1;
> > +
> > +	/* BH flavor */
> > +	if (in_softirq() || irqs_disabled())
> 
> I'm not sure I'd put irqs_disabled() under BH, also this entire
> condition is superfluous, see below.
> 
> > +		return 1;
> > +
> > +	/* Sched flavor */
> > +	if (debug_locks)
> > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > +	return lockdep_opinion || !preemptible();
> 
> that !preemptible() turns into:
> 
>   !(preempt_count()==0 && !irqs_disabled())
> 
> which is:
> 
>   preempt_count() != 0 || irqs_disabled()
> 
> and already includes irqs_disabled() and in_softirq().
> 
> > +}
> 
> So maybe something lke:
> 
> 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> 			    lock_is_held(&rcu_sched_lock_map)))
> 		return true;

Agreed, I will do it this way (without the debug_locks) like:

---8<-----------------------

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index ba861d1716d3..339aebc330db 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
 
 int rcu_read_lock_any_held(void)
 {
-	int lockdep_opinion = 0;
-
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
 	if (!rcu_is_watching())
 		return 0;
 	if (!rcu_lockdep_current_cpu_online())
 		return 0;
-
-	/* Preemptible RCU flavor */
-	if (lock_is_held(&rcu_lock_map))
-		return 1;
-
-	/* BH flavor */
-	if (in_softirq() || irqs_disabled())
-		return 1;
-
-	/* Sched flavor */
-	if (debug_locks)
-		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || !preemptible();
+	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
+		return 1;
+	return !preemptible();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
 
