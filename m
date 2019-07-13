Return-Path: <SRS0=IWUa=VK=lists.openwall.com=kernel-hardening-return-16447-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD9B8C742D2
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Jul 2019 03:02:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D50B20896
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Jul 2019 03:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="bw04Ay0U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D50B20896
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16447-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19933 invoked by uid 550); 13 Jul 2019 03:02:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19906 invoked from network); 13 Jul 2019 03:02:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p6+nGdMMoAyv7FCZrJDVnq6Bce28UfZTF5kGPY0RsIM=;
        b=bw04Ay0UMFt9ke3ViraFjTTPFj69KfioIz2kDu9iThosxnwpoLgu7SKLG4hIRxFIqy
         KrRWGgfWL0xcUlDIw7iLZ5tX+hclnd6IfuCTeOlLadmHAEqoiMpGN+V7xL6DjEvbJKAq
         nM4p5eZKLdUhl/xP3nkE1+7gdBiGtiXeF2kvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=p6+nGdMMoAyv7FCZrJDVnq6Bce28UfZTF5kGPY0RsIM=;
        b=XLmsm7O2OBNoqAdCuXUqFBSvkDTFwka+Z1a7aG2WxWnVoHUkKUKdAauK0ZnwMmA7DO
         VM78+X1T0zxnPjCB3b9tcmJoWcsL3tEVBe6KTpzluQZ+gGVAOCCuznX0a0Ju/EKMHb0q
         P8zUxyC4mkwyvveTsnpOHAVD4crV8YY3wW7KhyLI3hS5qaMa4G0mfPiVP1UXTnZ+kxLP
         IM17IpQzI377oEO0M7oox8FKKRLV1mvLXLlKbMlqRj/+cV/JZO5rhmdBceESaOUjvrcf
         KAk9heWZvNtbAi17/c16OxECcGIxxs0OF3A9bDO7aC9BXGGMx2b/iJ9FxSljbQtUFneG
         3NYg==
X-Gm-Message-State: APjAAAXySydOQPdXpyUTwVLKEc34SUG/ziUBgph6bo2ILxAoZH7GL777
	lIlcUPzl1HVRHzzJ+C2eULk=
X-Google-Smtp-Source: APXvYqwxhma/ZQTGBUi9iGsm/PVlNCuLwqhQ34U5OkmJkH9v4a6NVB+1pbiPSZYIUYdpj2smnrJc9A==
X-Received: by 2002:a17:902:e2:: with SMTP id a89mr15623529pla.210.1562986912505;
        Fri, 12 Jul 2019 20:01:52 -0700 (PDT)
Date: Fri, 12 Jul 2019 23:01:50 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
	edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20190713030150.GA246587@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
 <20190712233206.GZ26519@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712233206.GZ26519@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > The rcu/sync code was doing its own check whether we are in a reader
> > > section. With RCU consolidating flavors and the generic helper added in
> > > this series, this is no longer need. We can just use the generic helper
> > > and it results in a nice cleanup.
> > > 
> > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > Hi Oleg,
> > Slightly unrelated to the patch,
> > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > 
> > I do understand how rcu sync and percpu rwsem works, however the comment
> > below didn't make much sense to me. For one, there's no readers_fast anymore
> > so I did not follow what readers_fast means. Could the comment be updated to
> > reflect latest changes?
> > Also could you help understand how is a writer not able to change
> > sem->state and count the per-cpu read counters at the same time as the
> > comment tries to say?
> > 
> > 	/*
> > 	 * We are in an RCU-sched read-side critical section, so the writer
> > 	 * cannot both change sem->state from readers_fast and start checking
> > 	 * counters while we are here. So if we see !sem->state, we know that
> > 	 * the writer won't be checking until we're past the preempt_enable()
> > 	 * and that once the synchronize_rcu() is done, the writer will see
> > 	 * anything we did within this RCU-sched read-size critical section.
> > 	 */
> > 
> > Also,
> > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > the callbacks are the same now. I will post that as a follow-up patch to this
> > series.
> 
> Hello, Joel,
> 
> Oleg has a set of patches updating this code that just hit mainline
> this week.  These patches get rid of the code that previously handled
> RCU's multiple flavors.  Or are you looking at current mainline and
> me just missing your point?
> 

Hi Paul,
You are right on point. I have a bad habit of not rebasing my trees. In this
case the feature branch of mine in concern was based on v5.1. Needless to
say, I need to rebase my tree.

Yes, this sync clean up patch does conflict when I rebase, but other patches
rebase just fine.

The 2 options I see are:
1. Let us drop this patch for now and I resend it later.
2. I resend all patches based on Linus's master branch.

thanks,

- Joel

