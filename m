Return-Path: <SRS0=YhYk=GQ=lists.openwall.com=kernel-hardening-return-20640-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC75C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Jan 2021 18:02:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0B0E521534
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Jan 2021 18:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B0E521534
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20640-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11582 invoked by uid 550); 13 Jan 2021 18:02:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11550 invoked from network); 13 Jan 2021 18:02:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2yOASqLXCFmH8rHiDFY5aK5IF9dZ2OI5aQ21Vbh1eP8=;
        b=gHtUHzUPG5nr4qeM6RqXwHoa31eiMAo2G3XbBdMPhPetpWhM+8FxJcVQrQckAjJOts
         a+PuAK+iIngRm+Yp1MRDCVK0BKRkRO9ogHvQh8O/VHesI2z8n5+VeisZVKsjgEqjLV5k
         U3cHR0de4KgfDQBMl4Uj4g9/NyiGrIcwhViN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2yOASqLXCFmH8rHiDFY5aK5IF9dZ2OI5aQ21Vbh1eP8=;
        b=L5Xj8Mr0H0UHzm1fiK7JIBglX5yjWuxiDyQDWJKBReq+oVHHyAVG4rZYz/nrx6HAkX
         +zutx2gBIS7qbDS2Wkk8LuAhA4tEiFPjXSlWSgSdR9SzSMasmiWbdVAPewI65aBm7EEd
         VDmo5vr5mbZgdi39QIzgvag2Y1HnuGmgzwgPIhXhQ9+5ujUcT61V9bQQWl9BIgHZqoxA
         uemkh/bSm0tnUbD4Cz81TaWUY38xhSnzj4doHXuIhcpcpUmUU3GGKvMakAMMrqCYTPag
         IXLNjdfn0x7988uCkgulOT8qNNMZOtKbE4VMH+eSXgBz81LedSl7c7gDwtIaenDyzB+7
         irfg==
X-Gm-Message-State: AOAM533RHJM98ALhpcnm1fqWPruQpCvZ90S/q1B9ScEb6X6LyDwzgaF2
	c3QcDSUKiszIDKBZFiHd39SGAg==
X-Google-Smtp-Source: ABdhPJy/l5JCoFPdFR12hWOnKrP/lLjwYszhjP/WNJBh99XAQ0ifkW1xWHqHas6EDvPBSGX8HpJRMQ==
X-Received: by 2002:a63:8f19:: with SMTP id n25mr3154262pgd.17.1610560917380;
        Wed, 13 Jan 2021 10:01:57 -0800 (PST)
Date: Wed, 13 Jan 2021 10:01:55 -0800
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Alexey Gladkov <legion@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v2 1/8] Use atomic type for ucounts reference counting
Message-ID: <202101131001.BF1108F90@keescook>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
 <447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
 <878s8wdcib.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s8wdcib.fsf@x220.int.ebiederm.org>

On Wed, Jan 13, 2021 at 10:31:40AM -0600, Eric W. Biederman wrote:
> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
> 
> We might want to use refcount_t instead of atomic_t.  Not a big deal
> either way.

Yes, please use refcount_t, and don't use _read() since that introduces
races.

-Kees

> 
> > Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> > ---
> >  include/linux/user_namespace.h |  2 +-
> >  kernel/ucount.c                | 10 +++++-----
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> > index 64cf8ebdc4ec..84fefa9247c4 100644
> > --- a/include/linux/user_namespace.h
> > +++ b/include/linux/user_namespace.h
> > @@ -92,7 +92,7 @@ struct ucounts {
> >  	struct hlist_node node;
> >  	struct user_namespace *ns;
> >  	kuid_t uid;
> > -	int count;
> > +	atomic_t count;
> >  	atomic_t ucount[UCOUNT_COUNTS];
> >  };
> >  
> > diff --git a/kernel/ucount.c b/kernel/ucount.c
> > index 11b1596e2542..0f2c7c11df19 100644
> > --- a/kernel/ucount.c
> > +++ b/kernel/ucount.c
> > @@ -141,7 +141,8 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
> >  
> >  		new->ns = ns;
> >  		new->uid = uid;
> > -		new->count = 0;
> > +
> > +		atomic_set(&new->count, 0);
> >  
> >  		spin_lock_irq(&ucounts_lock);
> >  		ucounts = find_ucounts(ns, uid, hashent);
> > @@ -152,10 +153,10 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
> >  			ucounts = new;
> >  		}
> >  	}
> > -	if (ucounts->count == INT_MAX)
> > +	if (atomic_read(&ucounts->count) == INT_MAX)
> >  		ucounts = NULL;
> >  	else
> > -		ucounts->count += 1;
> > +		atomic_inc(&ucounts->count);
> >  	spin_unlock_irq(&ucounts_lock);
> >  	return ucounts;
> >  }
> > @@ -165,8 +166,7 @@ static void put_ucounts(struct ucounts *ucounts)
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&ucounts_lock, flags);
> > -	ucounts->count -= 1;
> > -	if (!ucounts->count)
> > +	if (atomic_dec_and_test(&ucounts->count))
> >  		hlist_del_init(&ucounts->node);
> >  	else
> >  		ucounts = NULL;
> 
> 
> This can become:
> static void put_ucounts(struct ucounts *ucounts)
> {
> 	unsigned long flags;
> 
>         if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
>         	hlist_del_init(&ucounts->node);
>                 spin_unlock_irqrestore(&ucounts_lock);
>                 kfree(ucounts);
>         }
> }
> 

-- 
Kees Cook
