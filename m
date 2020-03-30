Return-Path: <SRS0=88OH=5Q=lists.openwall.com=kernel-hardening-return-18330-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671CDC2D0E8
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:40:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BB69020838
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 11:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3uI88bT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB69020838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18330-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5576 invoked by uid 550); 31 Mar 2020 11:39:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7990 invoked from network); 30 Mar 2020 23:25:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585610705;
	bh=CW5W2odPF+X6jORiftGFOScxeCEkL8MSvWI5irb+e0o=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=S3uI88bTqKZzYLy91vMNO4bJJddG5wvwNkFYadqaAnLjdYEI1HOJpNNh5J3gcaMC/
	 fy1/ClnNa5Z/pAnSs+HlhN4Krzrb31JVlXehWbfGMx2Gtay+NQuLppE85lYZHzvlAq
	 ydJTWEGKQA5K4jY4Ot9epYlD8hijT2IaSAolkQW8=
Date: Mon, 30 Mar 2020 16:25:05 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/21] Revert "list: Use WRITE_ONCE() when
 initializing list_head structures"
Message-ID: <20200330232505.GD19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-9-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-9-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:30PM +0000, Will Deacon wrote:
> This reverts commit 2f073848c3cc8aff2655ab7c46d8c0de90cf4e50.
> 
> There is no need to use WRITE_ONCE() to initialise a non-RCU 'list_head'.
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

And attention to lockless uses of list_empty() here, correct?

Depending on the outcome of discussions on 3/21, I should have added in
all three cases.

							Thanx, Paul

> ---
>  include/linux/list.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index c7331c259792..b86a3f9465d4 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -32,7 +32,7 @@
>   */
>  static inline void INIT_LIST_HEAD(struct list_head *list)
>  {
> -	WRITE_ONCE(list->next, list);
> +	list->next = list;
>  	list->prev = list;
>  }
>  
> -- 
> 2.20.1
> 
