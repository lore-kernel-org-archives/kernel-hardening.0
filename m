Return-Path: <SRS0=KCM2=XZ=lists.openwall.com=kernel-hardening-return-16975-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3912C32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:52:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41D852168B
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:52:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CI4+0r8I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41D852168B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16975-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29847 invoked by uid 550); 30 Sep 2019 22:52:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29810 invoked from network); 30 Sep 2019 22:52:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AIzezZGZlEqDpT6gWQrT0q98ZV0Penit5a9WymGkkAg=;
        b=CI4+0r8IEsB/c98SOLVvWoBWjzwBVPTYpLwviJ9jHuyxEmJQLLP4SawNZ6udjs3Ypb
         f9hb7YuwKhm+SQ9m6AtCP1psb8sDCIaRfuaEdKwp53fsis31dvgzTXOLvvojwZy2vgka
         c9BJg/SOH83aS6jkbZC45dBFWwrjXKHD29JoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AIzezZGZlEqDpT6gWQrT0q98ZV0Penit5a9WymGkkAg=;
        b=OU4n6NIRsgO0lOJBNBbE32Myk1enxZr08PtQEiuhuuOTT7maRoDoZLNmJ7lmAQRVdA
         QmNrT5rLZzHZjcRO/KGJb6YWuc7idUqrCfCRR+5Xexxz5yZI4RSJ5mkD7FQyTJAHB8xs
         NA6bvbu8PTz95+TRxRnetb5J/VDYucXoRWjJbF2z2+tSNWwLqYpoEkchDhEkprZEQO+E
         muLnz8alRjXTmmdCSy2SlsNcnwj612mGlb5NYBYKCGL+M8yry+hP8DK0iPs9A5xqKtiL
         khww79NWFTnzi0T3ivvmRaJCGQ0uEvHYHVpfnuDxX9JdsSTRapHkcvjmc0mbdSXD55bk
         OkTA==
X-Gm-Message-State: APjAAAUX3Tvo81guZpTQ7l+UFAaOXDRpn6M+1cLfMNgVJPvdHjMj2efg
	zlmi/36K5OXKe8ZCTsjziQ1PlA==
X-Google-Smtp-Source: APXvYqxqGQ7XG8PDM8TffnxjfT9yJ9Jhx+mEmpN3v2ANzGUfFBpTr1zJ7NrL2RVt+XcojQ0hn9DRog==
X-Received: by 2002:a63:e907:: with SMTP id i7mr26364062pgh.84.1569883941437;
        Mon, 30 Sep 2019 15:52:21 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:52:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 16/16] tasklet: Add the new initialization
 function permanently
Message-ID: <201909301551.ECF10DFB66@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-17-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-17-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:28PM +0200, Romain Perier wrote:
> Now that everything has been converted to the new API, we can remove
> tasklet_init() and replace it by tasklet_setup().
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>

If this is the last user of TASKLET_*_TYPE casts, those should get
dropped here too.

-Kees

> ---
>  include/linux/interrupt.h | 9 +--------
>  kernel/softirq.c          | 4 ++--
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 506300396db9..0e8f6bca45a4 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -672,18 +672,11 @@ static inline void tasklet_enable(struct tasklet_struct *t)
>  
>  extern void tasklet_kill(struct tasklet_struct *t);
>  extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
> -extern void tasklet_init(struct tasklet_struct *t,
> +extern void tasklet_setup(struct tasklet_struct *t,
>  			 void (*func)(struct tasklet_struct *));
>  
>  #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
>  	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
> -
> -static inline void tasklet_setup(struct tasklet_struct *t,
> -				 void (*callback)(struct tasklet_struct *))
> -{
> -	tasklet_init(t, (TASKLET_FUNC_TYPE)callback);
> -}
> -
>  /*
>   * Autoprobing for irqs:
>   *
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 7415a7c4b494..179dce78fff8 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -546,7 +546,7 @@ static __latent_entropy void tasklet_hi_action(struct softirq_action *a)
>  	tasklet_action_common(a, this_cpu_ptr(&tasklet_hi_vec), HI_SOFTIRQ);
>  }
>  
> -void tasklet_init(struct tasklet_struct *t,
> +void tasklet_setup(struct tasklet_struct *t,
>  		  void (*func)(struct tasklet_struct *))
>  {
>  	t->next = NULL;
> @@ -554,7 +554,7 @@ void tasklet_init(struct tasklet_struct *t,
>  	atomic_set(&t->count, 0);
>  	t->func = func;
>  }
> -EXPORT_SYMBOL(tasklet_init);
> +EXPORT_SYMBOL(tasklet_setup);
>  
>  void tasklet_kill(struct tasklet_struct *t)
>  {
> -- 
> 2.23.0
> 

-- 
Kees Cook
