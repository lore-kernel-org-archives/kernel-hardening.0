Return-Path: <SRS0=wSrn=VJ=lists.openwall.com=kernel-hardening-return-16444-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FFFC742D7
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 23:33:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0951B217D4
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 23:33:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0951B217D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16444-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5688 invoked by uid 550); 12 Jul 2019 23:33:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5644 invoked from network); 12 Jul 2019 23:33:13 -0000
Date: Fri, 12 Jul 2019 16:32:06 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 3/9] rcu/sync: Remove custom check for reader-section
Message-ID: <20190712233206.GZ26519@linux.ibm.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712213559.GA175138@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120242

On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > The rcu/sync code was doing its own check whether we are in a reader
> > section. With RCU consolidating flavors and the generic helper added in
> > this series, this is no longer need. We can just use the generic helper
> > and it results in a nice cleanup.
> > 
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> Hi Oleg,
> Slightly unrelated to the patch,
> I tried hard to understand this comment below in percpu_down_read() but no dice.
> 
> I do understand how rcu sync and percpu rwsem works, however the comment
> below didn't make much sense to me. For one, there's no readers_fast anymore
> so I did not follow what readers_fast means. Could the comment be updated to
> reflect latest changes?
> Also could you help understand how is a writer not able to change
> sem->state and count the per-cpu read counters at the same time as the
> comment tries to say?
> 
> 	/*
> 	 * We are in an RCU-sched read-side critical section, so the writer
> 	 * cannot both change sem->state from readers_fast and start checking
> 	 * counters while we are here. So if we see !sem->state, we know that
> 	 * the writer won't be checking until we're past the preempt_enable()
> 	 * and that once the synchronize_rcu() is done, the writer will see
> 	 * anything we did within this RCU-sched read-size critical section.
> 	 */
> 
> Also,
> I guess we could get rid of all of the gp_ops struct stuff now that since all
> the callbacks are the same now. I will post that as a follow-up patch to this
> series.

Hello, Joel,

Oleg has a set of patches updating this code that just hit mainline
this week.  These patches get rid of the code that previously handled
RCU's multiple flavors.  Or are you looking at current mainline and
me just missing your point?

							Thanx, Paul

> thanks!
> 
>  - Joel
> 
> 
> > ---
> > Please note: Only build and boot tested this particular patch so far.
> > 
> >  include/linux/rcu_sync.h |  5 ++---
> >  kernel/rcu/sync.c        | 22 ----------------------
> >  2 files changed, 2 insertions(+), 25 deletions(-)
> > 
> > diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> > index 6fc53a1345b3..c954f1efc919 100644
> > --- a/include/linux/rcu_sync.h
> > +++ b/include/linux/rcu_sync.h
> > @@ -39,9 +39,8 @@ extern void rcu_sync_lockdep_assert(struct rcu_sync *);
> >   */
> >  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
> >  {
> > -#ifdef CONFIG_PROVE_RCU
> > -	rcu_sync_lockdep_assert(rsp);
> > -#endif
> > +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
> > +			 "suspicious rcu_sync_is_idle() usage");
> >  	return !rsp->gp_state; /* GP_IDLE */
> >  }
> >  
> > diff --git a/kernel/rcu/sync.c b/kernel/rcu/sync.c
> > index a8304d90573f..535e02601f56 100644
> > --- a/kernel/rcu/sync.c
> > +++ b/kernel/rcu/sync.c
> > @@ -10,37 +10,25 @@
> >  #include <linux/rcu_sync.h>
> >  #include <linux/sched.h>
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -#define __INIT_HELD(func)	.held = func,
> > -#else
> > -#define __INIT_HELD(func)
> > -#endif
> > -
> >  static const struct {
> >  	void (*sync)(void);
> >  	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> >  	void (*wait)(void);
> > -#ifdef CONFIG_PROVE_RCU
> > -	int  (*held)(void);
> > -#endif
> >  } gp_ops[] = {
> >  	[RCU_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_held)
> >  	},
> >  	[RCU_SCHED_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_sched_held)
> >  	},
> >  	[RCU_BH_SYNC] = {
> >  		.sync = synchronize_rcu,
> >  		.call = call_rcu,
> >  		.wait = rcu_barrier,
> > -		__INIT_HELD(rcu_read_lock_bh_held)
> >  	},
> >  };
> >  
> > @@ -49,16 +37,6 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
> >  
> >  #define	rss_lock	gp_wait.lock
> >  
> > -#ifdef CONFIG_PROVE_RCU
> > -void rcu_sync_lockdep_assert(struct rcu_sync *rsp)
> > -{
> > -	RCU_LOCKDEP_WARN(!gp_ops[rsp->gp_type].held(),
> > -			 "suspicious rcu_sync_is_idle() usage");
> > -}
> > -
> > -EXPORT_SYMBOL_GPL(rcu_sync_lockdep_assert);
> > -#endif
> > -
> >  /**
> >   * rcu_sync_init() - Initialize an rcu_sync structure
> >   * @rsp: Pointer to rcu_sync structure to be initialized
> > -- 
> > 2.22.0.510.g264f2c817a-goog
> > 
> 
