Return-Path: <SRS0=DYDt=XZ=lists.openwall.com=kernel-hardening-return-16971-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE97C35280
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:44:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 670C3215EA
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F01dMsFz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 670C3215EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16971-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18332 invoked by uid 550); 30 Sep 2019 22:44:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18299 invoked from network); 30 Sep 2019 22:44:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z5BK7lybWACG3fwtngPux26HjD2mVhQ3lWW2sAdqtrM=;
        b=F01dMsFzZQKrAYU9aFzsc4OvXahK2yaS+Q0iGiQHOlBvVfWzfHn3zUA067wqMGVQ5b
         Svg6G2np2SyBgK0BwQE/Sa1VszRo3zMDfu2MQLGOxAzuIQOwrOtwR+4ccSjsDuwfcPr5
         bXAsnhCdo7ZbxexTsfIt45ywfvtRCzV38/jR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z5BK7lybWACG3fwtngPux26HjD2mVhQ3lWW2sAdqtrM=;
        b=RE+CWpdpFsl5DtOSrd7Q20awB0k3DvkOH8tJTDzD4K1mh8RSw5SZJnaW7dGt9rx4oB
         W6xgMxbvF4ToSvheMa5FngGy+yexo+gbJNuET8kMMBHV6kzpV3iE0/MyWWYrUeCSwdn1
         UhSnBSKnS+orlX8oeLyxP2ur6crmtOeyYQ7jV2ygJNMyyYNnPYNPP06fm1NjLKEOFLl2
         gdGI6kG6Ru1GIYkksNmgKZnlPPNagob4hTWvHF7pISFRJxtZYLu/NoFkgg3xyEI28c3j
         ZkwJB1Ast7B1lyBenrmNoBEtY7L39meF/EKBj57UIzVk6UkV7F2TFHcSq6tlqeN/w9NO
         NS5w==
X-Gm-Message-State: APjAAAWF3TsVAtlENMgz6DDQLmC577awZ3PfeZaqoI4bjQk0rT1kfuvg
	Hc1dJshYcPs9AuWBaJB9aYEkCeBSaAk=
X-Google-Smtp-Source: APXvYqwIOZI5Ct8eZ6rKd5B4LiQRWLtmQ0bGaOwK3lzLmJZvSulZtjpGOMrzDiBM7BUDPsZbGnUMBQ==
X-Received: by 2002:a17:902:9896:: with SMTP id s22mr22225615plp.207.1569883475144;
        Mon, 30 Sep 2019 15:44:35 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:44:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 12/16] tasklet: Pass tasklet_struct pointer as
 .data in DECLARE_TASKLET
Message-ID: <201909301538.CEA6C827@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-13-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-13-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:24PM +0200, Romain Perier wrote:
> Now that all tasklet initializations have been replaced, this updates
> the core of the DECLARE_TASKLET macros by passing the pointer of the
> tasklet structure as .data, so current static tasklets will continue to
> work by deadling with the tasklet_struct pointer in their handler,

typo: dealing

> without have to change the API of the macro. It also updates all
> callbacks of all tasklets statically allocated via DECLARE_TASKLET() for
> extracting the the parent data structure of the tasklet by using
> from_tasklet().

I think this patch needs to be broken up... the users of
DECLARE_TASKLET() shouldn't need to be changed along with
DECLARE_TASKLET() since there are casts protecting the arguments.

> [...]
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index f5332ae2dbeb..949bbaeaff0e 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -598,11 +598,14 @@ struct tasklet_struct
>  	unsigned long data;
>  };
>  
> +#define TASKLET_DATA_TYPE		unsigned long
> +#define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
> +
>  #define DECLARE_TASKLET(name, func, data) \
> -struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
> +struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
>  
>  #define DECLARE_TASKLET_DISABLED(name, func, data) \
> -struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
> +struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
>  
>  
>  enum
> @@ -673,9 +676,6 @@ extern void tasklet_kill_immediate(struct tasklet_struct *t, unsigned int cpu);
>  extern void tasklet_init(struct tasklet_struct *t,
>  			 void (*func)(unsigned long), unsigned long data);
>  
> -#define TASKLET_DATA_TYPE		unsigned long
> -#define TASKLET_FUNC_TYPE		void (*)(TASKLET_DATA_TYPE)
> -

This patch feels like it should be combined with the first one, and only
make the changes to the macros. (And keep them one place: we shouldn't
have to move them later.)

>  #define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
>  	container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
>  
> diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
> index a2a97fa3071b..b5b9e16f0083 100644
> --- a/kernel/backtracetest.c
> +++ b/kernel/backtracetest.c
> @@ -23,7 +23,7 @@ static void backtrace_test_normal(void)
>  
>  static DECLARE_COMPLETION(backtrace_work);
>  
> -static void backtrace_test_irq_callback(unsigned long data)
> +static void backtrace_test_irq_callback(struct tasklet_struct *unused)
>  {
>  	dump_stack();
>  	complete(&backtrace_work);

And all these other changes should be separated out in a different pass.

-- 
Kees Cook
