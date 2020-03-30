Return-Path: <SRS0=KUEN=5Q=lists.openwall.com=kernel-hardening-return-18328-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C79DC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:39:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB5B120838
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwtNJliu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB5B120838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18328-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3649 invoked by uid 550); 31 Mar 2020 11:39:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7642 invoked from network); 30 Mar 2020 23:21:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585610475;
	bh=3yuZSaQ36wyLBlKdpsQHW3thBDOr3nwmhonGyIIq6BQ=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=GwtNJliugD8mSTia+pLAwHnYuw88NISnmBDSifRCYu8M8RxiQb73Rzdx2oXlg0lzF
	 UsUIushsMgvd5Z83F9KrAsb4kNex+24c7eBETE39ZiNuNB78geEQ6t31td7mmgg5oC
	 tuAlci+SA49SUzt802ziva3EY7/q2NZZaR6bgx3o=
Date: Mon, 30 Mar 2020 16:21:14 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/21] list: Remove superfluous WRITE_ONCE() from
 hlist_nulls implementation
Message-ID: <20200330232114.GC19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-7-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-7-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:28PM +0000, Will Deacon wrote:
> Commit 860c8802ace1 ("rcu: Use WRITE_ONCE() for assignments to ->pprev
> for hlist_nulls") added WRITE_ONCE() invocations to hlist_nulls_add_head()
> and hlist_nulls_del().
> 
> Since these functions should not ordinarily run concurrently with other
> list accessors, restore the plain C assignments so that KCSAN can yell
> if a data race occurs.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

And this means that the lockless uses of hlist_nulls_empty() need
attention, correct?

							Thanx, Paul

> ---
>  include/linux/list_nulls.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> index fa51a801bf32..fd154ceb5b0d 100644
> --- a/include/linux/list_nulls.h
> +++ b/include/linux/list_nulls.h
> @@ -80,10 +80,10 @@ static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
>  	struct hlist_nulls_node *first = h->first;
>  
>  	n->next = first;
> -	WRITE_ONCE(n->pprev, &h->first);
> +	n->pprev = &h->first;
>  	h->first = n;
>  	if (!is_a_nulls(first))
> -		WRITE_ONCE(first->pprev, &n->next);
> +		first->pprev = &n->next;
>  }
>  
>  static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
> @@ -99,7 +99,7 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
>  static inline void hlist_nulls_del(struct hlist_nulls_node *n)
>  {
>  	__hlist_nulls_del(n);
> -	WRITE_ONCE(n->pprev, LIST_POISON2);
> +	n->pprev = LIST_POISON2;
>  }
>  
>  /**
> -- 
> 2.20.1
> 
