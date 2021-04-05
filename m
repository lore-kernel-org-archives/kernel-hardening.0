Return-Path: <SRS0=InOM=JC=lists.openwall.com=kernel-hardening-return-21145-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE44C433B4
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Apr 2021 17:02:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33673613AE
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Apr 2021 17:02:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33673613AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21145-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8029 invoked by uid 550); 5 Apr 2021 17:02:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8005 invoked from network); 5 Apr 2021 17:01:59 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
	<54956fd06ab4a9938421f345ecf2e1518161cb38.1616533074.git.gladkov.alexey@gmail.com>
Date: Mon, 05 Apr 2021 12:01:41 -0500
In-Reply-To: <54956fd06ab4a9938421f345ecf2e1518161cb38.1616533074.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Tue, 23 Mar 2021 21:59:12 +0100")
Message-ID: <m1eefoll6y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lTSbh-0008Vo-Ta;;;mid=<m1eefoll6y.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/6QFidO/5lE0s5jY0UtdtqKB+He4MOhKY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v9 3/8] Use atomic_t for ucounts reference counting
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> The current implementation of the ucounts reference counter requires the
> use of spin_lock. We're going to use get_ucounts() in more performance
> critical areas like a handling of RLIMIT_SIGPENDING.
>
> Now we need to use spin_lock only if we want to change the hashtable.
>
> v9:
> * Use a negative value to check that the ucounts->count is close to
>   overflow.


Overall this looks good, one small issue below.

Eric

> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 50cc1dfb7d28..7bac19bb3f1e 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -11,7 +11,7 @@
>  struct ucounts init_ucounts = {
>  	.ns    = &init_user_ns,
>  	.uid   = GLOBAL_ROOT_UID,
> -	.count = 1,
> +	.count = ATOMIC_INIT(1),
>  };
>  
>  #define UCOUNTS_HASHTABLE_BITS 10
> @@ -139,6 +139,15 @@ static void hlist_add_ucounts(struct ucounts *ucounts)
>  	spin_unlock_irq(&ucounts_lock);
>  }
>  
> +struct ucounts *get_ucounts(struct ucounts *ucounts)
> +{
> +	if (ucounts && atomic_add_negative(1, &ucounts->count)) {
> +		atomic_dec(&ucounts->count);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^

To handle the pathological case of all of the other uses calling
put_ucounts after the value goes negative, the above should
be put_ucounts intead of atomic_dec.


> +		ucounts = NULL;
> +	}
> +	return ucounts;
> +}
> +
>  struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  {
>  	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
> @@ -155,7 +164,7 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  
>  		new->ns = ns;
>  		new->uid = uid;
> -		new->count = 0;
> +		atomic_set(&new->count, 1);
>  
>  		spin_lock_irq(&ucounts_lock);
>  		ucounts = find_ucounts(ns, uid, hashent);
> @@ -163,33 +172,12 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  			kfree(new);
>  		} else {
>  			hlist_add_head(&new->node, hashent);
> -			ucounts = new;
> +			spin_unlock_irq(&ucounts_lock);
> +			return new;
>  		}
>  	}
> -	if (ucounts->count == INT_MAX)
> -		ucounts = NULL;
> -	else
> -		ucounts->count += 1;
>  	spin_unlock_irq(&ucounts_lock);
> -	return ucounts;
> -}
> -
> -struct ucounts *get_ucounts(struct ucounts *ucounts)
> -{
> -	unsigned long flags;
> -
> -	if (!ucounts)
> -		return NULL;
> -
> -	spin_lock_irqsave(&ucounts_lock, flags);
> -	if (ucounts->count == INT_MAX) {
> -		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
> -		ucounts = NULL;
> -	} else {
> -		ucounts->count += 1;
> -	}
> -	spin_unlock_irqrestore(&ucounts_lock, flags);
> -
> +	ucounts = get_ucounts(ucounts);
>  	return ucounts;
>  }
>  
> @@ -197,15 +185,12 @@ void put_ucounts(struct ucounts *ucounts)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&ucounts_lock, flags);
> -	ucounts->count -= 1;
> -	if (!ucounts->count)
> +	if (atomic_dec_and_test(&ucounts->count)) {
> +		spin_lock_irqsave(&ucounts_lock, flags);
>  		hlist_del_init(&ucounts->node);
> -	else
> -		ucounts = NULL;
> -	spin_unlock_irqrestore(&ucounts_lock, flags);
> -
> -	kfree(ucounts);
> +		spin_unlock_irqrestore(&ucounts_lock, flags);
> +		kfree(ucounts);
> +	}
>  }
>  
>  static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
