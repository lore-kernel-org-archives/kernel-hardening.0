Return-Path: <SRS0=97WM=VK=lists.openwall.com=kernel-hardening-return-16448-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8815AC742D2
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Jul 2019 03:10:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADE3E217D4
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Jul 2019 03:10:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="lOqMuQRe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADE3E217D4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16448-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29729 invoked by uid 550); 13 Jul 2019 03:10:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29708 invoked from network); 13 Jul 2019 03:10:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Yj0KzWPPj2wTNOobGgks3QqTli1sq+vFUwn/IZyvMdc=;
        b=lOqMuQRexi/hVxa/4p77SbaQvlMGoDh5aaBC9i1MTtOwCN7njvsbB5lQDbBmriZ1WA
         FWWHLnYwSi1u/Badms6e151ITEB+l7THYTAcQrSxD3Gt/lUVga9IZ5YlpJa+tNPnpYnH
         zxZrbWgIwEXHbV94dqGpKtSAH3ynqx9mn/E50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Yj0KzWPPj2wTNOobGgks3QqTli1sq+vFUwn/IZyvMdc=;
        b=Yq3uFTpsPQUvsHCWjtkcKuwSIV5MXU6UC87fMdPmGFpcroWtukOke/ZXe8NU6ZtE7n
         SYYPKEg17SgQpdiw6h8/uuzFaMbJEvqSDKjL4wWAlq0enId53xdgqF2uvrXwszPZQBZN
         q1ccdNezdb89CypkGuTvPCuQy16mEsdeNJdadvFBSDlz8LL1lR/13SDLC+KyRy8YhgGJ
         AlYxJcnmARdgtvJFdHzzGOZIyX1OT8OXFS5l0VwsmdmGNMyF2VWPF4YtWHRqgYm9lA4e
         0p3kBWIkebKuloEEc+JosIzsmuiBpfN3QNMQzp6UmIAKM84FwFlCvpKpJJXvKS2ypurF
         ZH7w==
X-Gm-Message-State: APjAAAUPKlV35Qv4XEHlg/SyBQm4sF4dFfu8NPHWw2Z84W+MawTahChT
	yaghXCBRGHagBWdW5IOgOOA=
X-Google-Smtp-Source: APXvYqzYmXDx79APPhOf6U2U81XcESDp7O9GeiDZBYQYdv6r3PCBBKB8Rg1+OBGlaGf1FYhUnpz+lQ==
X-Received: by 2002:a17:902:704a:: with SMTP id h10mr15163948plt.337.1562987410632;
        Fri, 12 Jul 2019 20:10:10 -0700 (PDT)
Date: Fri, 12 Jul 2019 23:10:08 -0400
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
Message-ID: <20190713031008.GA248225@google.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-4-joel@joelfernandes.org>
 <20190712213559.GA175138@google.com>
 <20190712233206.GZ26519@linux.ibm.com>
 <20190713030150.GA246587@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190713030150.GA246587@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jul 12, 2019 at 11:01:50PM -0400, Joel Fernandes wrote:
> On Fri, Jul 12, 2019 at 04:32:06PM -0700, Paul E. McKenney wrote:
> > On Fri, Jul 12, 2019 at 05:35:59PM -0400, Joel Fernandes wrote:
> > > On Fri, Jul 12, 2019 at 01:00:18PM -0400, Joel Fernandes (Google) wrote:
> > > > The rcu/sync code was doing its own check whether we are in a reader
> > > > section. With RCU consolidating flavors and the generic helper added in
> > > > this series, this is no longer need. We can just use the generic helper
> > > > and it results in a nice cleanup.
> > > > 
> > > > Cc: Oleg Nesterov <oleg@redhat.com>
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > > 
> > > Hi Oleg,
> > > Slightly unrelated to the patch,
> > > I tried hard to understand this comment below in percpu_down_read() but no dice.
> > > 
> > > I do understand how rcu sync and percpu rwsem works, however the comment
> > > below didn't make much sense to me. For one, there's no readers_fast anymore
> > > so I did not follow what readers_fast means. Could the comment be updated to
> > > reflect latest changes?
> > > Also could you help understand how is a writer not able to change
> > > sem->state and count the per-cpu read counters at the same time as the
> > > comment tries to say?
> > > 
> > > 	/*
> > > 	 * We are in an RCU-sched read-side critical section, so the writer
> > > 	 * cannot both change sem->state from readers_fast and start checking
> > > 	 * counters while we are here. So if we see !sem->state, we know that
> > > 	 * the writer won't be checking until we're past the preempt_enable()
> > > 	 * and that once the synchronize_rcu() is done, the writer will see
> > > 	 * anything we did within this RCU-sched read-size critical section.
> > > 	 */
> > > 
> > > Also,
> > > I guess we could get rid of all of the gp_ops struct stuff now that since all
> > > the callbacks are the same now. I will post that as a follow-up patch to this
> > > series.
> > 
> > Hello, Joel,
> > 
> > Oleg has a set of patches updating this code that just hit mainline
> > this week.  These patches get rid of the code that previously handled
> > RCU's multiple flavors.  Or are you looking at current mainline and
> > me just missing your point?
> > 
> 
> Hi Paul,
> You are right on point. I have a bad habit of not rebasing my trees. In this
> case the feature branch of mine in concern was based on v5.1. Needless to
> say, I need to rebase my tree.
> 
> Yes, this sync clean up patch does conflict when I rebase, but other patches
> rebase just fine.
> 
> The 2 options I see are:
> 1. Let us drop this patch for now and I resend it later.
> 2. I resend all patches based on Linus's master branch.

Below is the updated patch based on Linus master branch:

---8<-----------------------

From 5f40c9a07fcf3d6dafc2189599d0ba9443097d0f Mon Sep 17 00:00:00 2001
From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Date: Fri, 12 Jul 2019 12:13:27 -0400
Subject: [PATCH v2.1 3/9] rcu/sync: Remove custom check for reader-section

The rcu/sync code was doing its own check whether we are in a reader
section. With RCU consolidating flavors and the generic helper added in
this series, this is no longer need. We can just use the generic helper
and it results in a nice cleanup.

Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 include/linux/rcu_sync.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
index 9b83865d24f9..0027d4c8087c 100644
--- a/include/linux/rcu_sync.h
+++ b/include/linux/rcu_sync.h
@@ -31,9 +31,7 @@ struct rcu_sync {
  */
 static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
-			 !rcu_read_lock_bh_held() &&
-			 !rcu_read_lock_sched_held(),
+	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
 			 "suspicious rcu_sync_is_idle() usage");
 	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
 }
-- 
2.22.0.510.g264f2c817a-goog

