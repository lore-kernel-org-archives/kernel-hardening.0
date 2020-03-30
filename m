Return-Path: <SRS0=TE6W=5Q=lists.openwall.com=kernel-hardening-return-18331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6011C2D0EE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:40:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3801A20838
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ds1bkViW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3801A20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5917 invoked by uid 550); 31 Mar 2020 11:39:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9683 invoked from network); 30 Mar 2020 23:30:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585611020;
	bh=Y7ER3dlZBrPi+ataV+7Z5F/+VEyWcrrMDkj9J6vpEeU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=ds1bkViWG00jIm0WOighGk47cdO0TnLYGidI+AR+O21BLBm/VPEqpAxTjktw+sJlH
	 x9QL3QfVErtrrCYvtfJbYmhb7l4+qbGZQlYkAKeVMOYTlGdCfEw/EJHQMuE7u+0zwj
	 XFmg4lmF+NaXqODR3IIMw7HO9ZOSFLW4iSwVvajY=
Date: Mon, 30 Mar 2020 16:30:20 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 09/21] list: Remove unnecessary WRITE_ONCE() from
 hlist_bl_add_before()
Message-ID: <20200330233020.GF19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-10-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-10-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:31PM +0000, Will Deacon wrote:
> There is no need to use WRITE_ONCE() when inserting into a non-RCU
> protected list.
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

OK, I will bite...  Why "unsigned long" instead of "uintptr_t"?

Not that it matters in the context of the Linux kernel, so:

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

							Thanx, Paul

> ---
>  include/linux/list_bl.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> index 1804fdb84dda..c93e7e3aa8fc 100644
> --- a/include/linux/list_bl.h
> +++ b/include/linux/list_bl.h
> @@ -91,15 +91,15 @@ static inline void hlist_bl_add_before(struct hlist_bl_node *n,
>  				       struct hlist_bl_node *next)
>  {
>  	struct hlist_bl_node **pprev = next->pprev;
> +	unsigned long val;
>  
>  	n->pprev = pprev;
>  	n->next = next;
>  	next->pprev = &n->next;
>  
>  	/* pprev may be `first`, so be careful not to lose the lock bit */
> -	WRITE_ONCE(*pprev,
> -		   (struct hlist_bl_node *)
> -			((uintptr_t)n | ((uintptr_t)*pprev & LIST_BL_LOCKMASK)));
> +	val = (unsigned long)n | ((unsigned long)*pprev & LIST_BL_LOCKMASK);
> +	*pprev = (struct hlist_bl_node *)val;
>  }
>  
>  static inline void hlist_bl_add_behind(struct hlist_bl_node *n,
> -- 
> 2.20.1
> 
