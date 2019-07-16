Return-Path: <SRS0=x2EJ=VN=lists.openwall.com=kernel-hardening-return-16490-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2267EC7618F
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 22:02:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7426421743
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 22:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Nj4Apsx7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7426421743
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16490-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26238 invoked by uid 550); 16 Jul 2019 22:02:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26214 invoked from network); 16 Jul 2019 22:02:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2z9KNQXlh1uTspFy4ArQuvTJcR1Rzwr1DildJveu51k=;
        b=Nj4Apsx7+yF16h8Bgn0/aVZptTaAfrLBte4ocvydTpKDQLn5zJH9m64VOqx0AGgMOA
         9HALNTV6H66Ed1+hvZ8A79pTZKqASniWSBiSgJO+3qYxy/a0f7aH4C2yghsLt+aKszer
         Ko+jVULH3Uc8rJuQR+id5tzBt3QHpebPG2tfQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2z9KNQXlh1uTspFy4ArQuvTJcR1Rzwr1DildJveu51k=;
        b=sBe2vlqtbzc9ZnPkSKZkWPcCztEJ+TzAaEy2O+9Qa1kopZ+bD3Rzu9DVNXBsnLnylN
         ZCxTBw2u5827cY2TR4U5aI3n+VBEIKbvH+y2l4U8XPBOLqpTi7dqryfJ7wVPcWGpr8Pn
         pBVGDMkhDmoo0oZ+ymVNKVyOFboDfplJu/0fw6ObHxuCmSrFPuGvCWuc0Ir49CBXsmzc
         8SqcirWYrdDMZZuI4l1dwMavcUT3jGuRP/R9HwajNpei/QK/SZNyh46V+iZDeLZI368T
         HF9p8pR8x7eu8NX+U6LqOLWoBeenNEIRv1dT4RrQXB0BwmL9ypWleTSSwFVbRYlB/YmX
         HFmQ==
X-Gm-Message-State: APjAAAVxPwiKOyQjh5tmZc/6Hv8E6alRVBN4MCC3Plhe/oNX8YahY2E3
	ODao+gIK/UYs7jxFOur3Nws=
X-Google-Smtp-Source: APXvYqxaEDRbasy8NySgdX0n0Gtordok4+zLKu64dtBW+xFIbgsDp3e73uVzAdPXDqTAj25BPb/h3Q==
X-Received: by 2002:a65:500a:: with SMTP id f10mr5773696pgo.105.1563314527534;
        Tue, 16 Jul 2019 15:02:07 -0700 (PDT)
Date: Tue, 16 Jul 2019 18:02:05 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
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
	netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/9] rcu: Add support for consolidated-RCU reader
 checking (v3)
Message-ID: <20190716220205.GB172157@google.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-3-joel@joelfernandes.org>
 <20190716183833.GD14271@linux.ibm.com>
 <20190716184649.GA130463@google.com>
 <20190716185303.GM14271@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716185303.GM14271@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 16, 2019 at 11:53:03AM -0700, Paul E. McKenney wrote:
[snip]
> > > A few more things below.
> > > > ---
> > > >  include/linux/rculist.h  | 28 ++++++++++++++++++++-----
> > > >  include/linux/rcupdate.h |  7 +++++++
> > > >  kernel/rcu/Kconfig.debug | 11 ++++++++++
> > > >  kernel/rcu/update.c      | 44 ++++++++++++++++++++++++----------------
> > > >  4 files changed, 67 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> > > > index e91ec9ddcd30..1048160625bb 100644
> > > > --- a/include/linux/rculist.h
> > > > +++ b/include/linux/rculist.h
> > > > @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
> > > >   */
> > > >  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
> > > >  
> > > > +/*
> > > > + * Check during list traversal that we are within an RCU reader
> > > > + */
> > > > +
> > > > +#ifdef CONFIG_PROVE_RCU_LIST
> > > 
> > > This new Kconfig option is OK temporarily, but unless there is reason to
> > > fear malfunction that a few weeks of rcutorture, 0day, and -next won't
> > > find, it would be better to just use CONFIG_PROVE_RCU.  The overall goal
> > > is to reduce the number of RCU knobs rather than grow them, must though
> > > history might lead one to believe otherwise.  :-/
> > 
> > If you want, we can try to drop this option and just use PROVE_RCU however I
> > must say there may be several warnings that need to be fixed in a short
> > period of time (even a few weeks may be too short) considering the 1000+
> > uses of RCU lists.
> Do many people other than me build with CONFIG_PROVE_RCU?  If so, then
> that would be a good reason for a temporary CONFIG_PROVE_RCU_LIST,
> as in going away in a release or two once the warnings get fixed.

PROVE_RCU is enabled by default with PROVE_LOCKING, so it is used quite
heavilty.

> > But I don't mind dropping it and it may just accelerate the fixing up of all
> > callers.
> 
> I will let you decide based on the above question.  But if you have
> CONFIG_PROVE_RCU_LIST, as noted below, it needs to depend on RCU_EXPERT.

Ok, will make it depend. But yes for temporary purpose, I will leave it as a
config and remove it later.

thanks,

 - Joel
 
