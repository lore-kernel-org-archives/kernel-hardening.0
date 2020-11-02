Return-Path: <SRS0=WkLC=EI=lists.openwall.com=kernel-hardening-return-20320-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A9AC00A89
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 18:03:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 99EEC21D91
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 18:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99EEC21D91
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubuntu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20320-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11464 invoked by uid 550); 2 Nov 2020 18:03:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11427 invoked from network); 2 Nov 2020 18:03:18 -0000
Date: Mon, 2 Nov 2020 19:03:01 +0100
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [RFC PATCH v1 1/4] Increase size of ucounts to atomic_long_t
Message-ID: <20201102180301.dup2cmbqdyrexp22@wittgenstein>
References: <cover.1604335819.git.gladkov.alexey@gmail.com>
 <f3c95ffedbab07f05e0e6e4e5a8bdd6c358194e7.1604335819.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3c95ffedbab07f05e0e6e4e5a8bdd6c358194e7.1604335819.git.gladkov.alexey@gmail.com>

On Mon, Nov 02, 2020 at 05:50:30PM +0100, Alexey Gladkov wrote:
> In order to be able to use ucounts for rlimits, the size must be increased.
> For example user_struct.mq_bytes (RLIMIT_MSGQUEUE) is unsigned long.

I don't have any issues with this change I just wonder what the exact
reason is. It's not immediately obvious to me.

> 
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/user_namespace.h |  4 ++--
>  kernel/ucount.c                | 14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 6ef1c7109fc4..fc75af812d73 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -86,7 +86,7 @@ struct user_namespace {
>  	struct ctl_table_header *sysctls;
>  #endif
>  	struct ucounts		*ucounts;
> -	int ucount_max[UCOUNT_COUNTS];
> +	long ucount_max[UCOUNT_COUNTS];
>  } __randomize_layout;
>  
>  struct ucounts {
> @@ -94,7 +94,7 @@ struct ucounts {
>  	struct user_namespace *ns;
>  	kuid_t uid;
>  	int count;
> -	atomic_t ucount[UCOUNT_COUNTS];
> +	atomic_long_t ucount[UCOUNT_COUNTS];
>  };
>  
>  extern struct user_namespace init_user_ns;
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 11b1596e2542..7b2bca8582ef 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -175,14 +175,14 @@ static void put_ucounts(struct ucounts *ucounts)
>  	kfree(ucounts);
>  }
>  
> -static inline bool atomic_inc_below(atomic_t *v, int u)
> +static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
>  {
> -	int c, old;
> -	c = atomic_read(v);
> +	long c, old;
> +	c = atomic_long_read(v);
>  	for (;;) {
>  		if (unlikely(c >= u))
>  			return false;
> -		old = atomic_cmpxchg(v, c, c+1);
> +		old = atomic_long_cmpxchg(v, c, c+1);
>  		if (likely(old == c))
>  			return true;
>  		c = old;
> @@ -199,14 +199,14 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
>  		int max;
>  		tns = iter->ns;
>  		max = READ_ONCE(tns->ucount_max[type]);
> -		if (!atomic_inc_below(&iter->ucount[type], max))
> +		if (!atomic_long_inc_below(&iter->ucount[type], max))
>  			goto fail;
>  	}
>  	return ucounts;
>  fail:
>  	bad = iter;
>  	for (iter = ucounts; iter != bad; iter = iter->ns->ucounts)
> -		atomic_dec(&iter->ucount[type]);
> +		atomic_long_dec(&iter->ucount[type]);
>  
>  	put_ucounts(ucounts);
>  	return NULL;
> @@ -216,7 +216,7 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
>  {
>  	struct ucounts *iter;
>  	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
> -		int dec = atomic_dec_if_positive(&iter->ucount[type]);
> +		int dec = atomic_long_dec_if_positive(&iter->ucount[type]);
>  		WARN_ON_ONCE(dec < 0);
>  	}
>  	put_ucounts(ucounts);
> -- 
> 2.25.4
> 
