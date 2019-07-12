Return-Path: <SRS0=Q/I0=VJ=lists.openwall.com=kernel-hardening-return-16427-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E08DC742CF
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 16:00:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 688E0206B8
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Jul 2019 16:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OJmluq10"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 688E0206B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16427-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11670 invoked by uid 550); 12 Jul 2019 16:00:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11652 invoked from network); 12 Jul 2019 16:00:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=tyTl1YbLBKPDWZGZvgKJMIcMQjGDx2jzfk/EinyXaGw=; b=OJmluq10NP9ipXVsYrmwopFcf
	do+lSJThkEy+P/MV/f2o9QPEWNc0Gh7X0FBRZSWSNdmGaYj4is98cT3u0ezQl96GDgZSt+jAi7LUF
	dgmWzIepmiPHhH4mZYRWfi7kxUTmjmcDJz7hlYH60YSSdmd3Hw0IttJOqjQ1kbRyE1tIxZJk8srJB
	IlCUyCp9dTm7j7m3hz11ELDmm4StRo9BXM8WcqhoSdEXy+QlzQMk2rwFn7NYspxNWjPesn9gCPQWU
	Iq/HoBQSN9wY4c/HLnRVXbE/JfP0y4ilrxP/RMaRHC4JdB7795AK+0L93m59yddMBltlvPsbIJi/Z
	DkwYvlJSQ==;
Date: Fri, 12 Jul 2019 17:58:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Fernandes <joel@joelfernandes.org>
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
Message-ID: <20190712155859.GV3419@hirez.programming.kicks-ass.net>
References: <20190711234401.220336-1-joel@joelfernandes.org>
 <20190711234401.220336-2-joel@joelfernandes.org>
 <20190712111125.GT3402@hirez.programming.kicks-ass.net>
 <20190712151051.GB235410@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712151051.GB235410@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 11:10:51AM -0400, Joel Fernandes wrote:
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
>  	if (!debug_lockdep_rcu_enabled())
>  		return 1;
>  	if (!rcu_is_watching())
>  		return 0;
>  	if (!rcu_lockdep_current_cpu_online())
>  		return 0;
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> +		return 1;
> +	return !preemptible();
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);

OK, that looks sane. Thanks!
