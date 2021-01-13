Return-Path: <SRS0=M8QW=GQ=lists.openwall.com=kernel-hardening-return-20639-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78A2C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Jan 2021 16:33:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A471B23442
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Jan 2021 16:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A471B23442
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20639-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1275 invoked by uid 550); 13 Jan 2021 16:32:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1236 invoked from network); 13 Jan 2021 16:32:57 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Linux Containers <containers@lists.linux-foundation.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Alexey Gladkov <legion@kernel.org>,  Kees Cook <keescook@chromium.org>,  Christian Brauner <christian@brauner.io>,  Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
	<447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
Date: Wed, 13 Jan 2021 10:31:40 -0600
In-Reply-To: <447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Sun, 10 Jan 2021 18:33:40 +0100")
Message-ID: <878s8wdcib.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kzj4d-009Vz0-HQ;;;mid=<878s8wdcib.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX195fKSBqSZ+lYzEZIXlkNCqt38tQhw2MoY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC PATCH v2 1/8] Use atomic type for ucounts reference counting
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

We might want to use refcount_t instead of atomic_t.  Not a big deal
either way.

> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/user_namespace.h |  2 +-
>  kernel/ucount.c                | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 64cf8ebdc4ec..84fefa9247c4 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -92,7 +92,7 @@ struct ucounts {
>  	struct hlist_node node;
>  	struct user_namespace *ns;
>  	kuid_t uid;
> -	int count;
> +	atomic_t count;
>  	atomic_t ucount[UCOUNT_COUNTS];
>  };
>  
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 11b1596e2542..0f2c7c11df19 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -141,7 +141,8 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>  
>  		new->ns = ns;
>  		new->uid = uid;
> -		new->count = 0;
> +
> +		atomic_set(&new->count, 0);
>  
>  		spin_lock_irq(&ucounts_lock);
>  		ucounts = find_ucounts(ns, uid, hashent);
> @@ -152,10 +153,10 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>  			ucounts = new;
>  		}
>  	}
> -	if (ucounts->count == INT_MAX)
> +	if (atomic_read(&ucounts->count) == INT_MAX)
>  		ucounts = NULL;
>  	else
> -		ucounts->count += 1;
> +		atomic_inc(&ucounts->count);
>  	spin_unlock_irq(&ucounts_lock);
>  	return ucounts;
>  }
> @@ -165,8 +166,7 @@ static void put_ucounts(struct ucounts *ucounts)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ucounts_lock, flags);
> -	ucounts->count -= 1;
> -	if (!ucounts->count)
> +	if (atomic_dec_and_test(&ucounts->count))
>  		hlist_del_init(&ucounts->node);
>  	else
>  		ucounts = NULL;


This can become:
static void put_ucounts(struct ucounts *ucounts)
{
	unsigned long flags;

        if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
        	hlist_del_init(&ucounts->node);
                spin_unlock_irqrestore(&ucounts_lock);
                kfree(ucounts);
        }
}

