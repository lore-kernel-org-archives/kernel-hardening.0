Return-Path: <SRS0=O4gx=VJ=lists.openwall.com=kernel-hardening-return-16428-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9D7C742D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 16:46:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B036820850
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 16:46:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B036820850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16428-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14205 invoked by uid 550); 12 Jul 2019 16:46:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14135 invoked from network); 12 Jul 2019 16:46:36 -0000
Date: Fri, 12 Jul 2019 09:45:31 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, oleg@redhat.com, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v1 1/6] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190712164531.GW26519@linux.ibm.com>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712151051.GB235410@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120171

On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 01:11:25PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 11, 2019 at 07:43:56PM -0400, Joel Fernandes (Google) wrote:
> > > +int rcu_read_lock_any_held(void)
> > > +{
> > > +	int lockdep_opinion = 0;
> > > +
> > > +	if (!debug_lockdep_rcu_enabled())
> > > +		return 1;
> > > +	if (!rcu_is_watching())
> > > +		return 0;
> > > +	if (!rcu_lockdep_current_cpu_online())
> > > +		return 0;
> > > +
> > > +	/* Preemptible RCU flavor */
> > > +	if (lock_is_held(&rcu_lock_map))
> > 
> > you forgot debug_locks here.
> 
> Actually, it turns out debug_locks checking is not even needed. If
> debug_locks == 0, then debug_lockdep_rcu_enabled() returns 0 and we would not
> get to this point.
> 
> > > +		return 1;
> > > +
> > > +	/* BH flavor */
> > > +	if (in_softirq() || irqs_disabled())
> > 
> > I'm not sure I'd put irqs_disabled() under BH, also this entire
> > condition is superfluous, see below.
> > 
> > > +		return 1;
> > > +
> > > +	/* Sched flavor */
> > > +	if (debug_locks)
> > > +		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > > +	return lockdep_opinion || !preemptible();
> > 
> > that !preemptible() turns into:
> > 
> >   !(preempt_count()==0 && !irqs_disabled())
> > 
> > which is:
> > 
> >   preempt_count() != 0 || irqs_disabled()
> > 
> > and already includes irqs_disabled() and in_softirq().
> > 
> > > +}
> > 
> > So maybe something lke:
> > 
> > 	if (debug_locks && (lock_is_held(&rcu_lock_map) ||
> > 			    lock_is_held(&rcu_sched_lock_map)))
> > 		return true;
> 
> Agreed, I will do it this way (without the debug_locks) like:
> 
> ---8<-----------------------
> 
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index ba861d1716d3..339aebc330db 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -296,27 +296,15 @@ EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
>  
>  int rcu_read_lock_any_held(void)
>  {
> -	int lockdep_opinion = 0;
> -
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
>  	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> -
> -	/* Preemptible RCU flavor */
> -	if (lock_is_held(&rcu_lock_map))
> -		return 1;
> -
> -	/* BH flavor */
> -	if (in_softirq() || irqs_disabled())
> -		return 1;
> -
> -	/* Sched flavor */
> -	if (debug_locks)
> -		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> -	return lockdep_opinion || !preemptible();
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))

OK, I will bite...  Why not also lock_is_held(&rcu_bh_lock_map)?

							Thanx, Paul

> +		return 1;
> +	return !preemptible();
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
>  
> 
