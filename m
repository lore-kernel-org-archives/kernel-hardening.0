Return-Path: <SRS0=O0a0=JC=lists.openwall.com=kernel-hardening-return-21144-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3DEC433ED
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Apr 2021 16:59:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C688F613AF
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Apr 2021 16:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C688F613AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21144-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5779 invoked by uid 550); 5 Apr 2021 16:59:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5758 invoked from network); 5 Apr 2021 16:59:08 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
	<9c8b24db40a030347652ee58f44028ca1081acfa.1616533074.git.gladkov.alexey@gmail.com>
Date: Mon, 05 Apr 2021 11:58:51 -0500
In-Reply-To: <9c8b24db40a030347652ee58f44028ca1081acfa.1616533074.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Tue, 23 Mar 2021 21:59:15 +0100")
Message-ID: <m1r1jollbo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lTSYw-000Z25-OY;;;mid=<m1r1jollbo.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/lRCz+abrVYSdzhXtMBllzyd5yG1jeH8w=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v9 6/8] Reimplement RLIMIT_SIGPENDING on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


A small bug below.

Eric


> diff --git a/kernel/signal.c b/kernel/signal.c
> index f2a1b898da29..1b537d9de447 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -413,49 +413,44 @@ void task_join_group_stop(struct task_struct *task)
>  static struct sigqueue *
>  __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
>  {
> -	struct sigqueue *q = NULL;
> -	struct user_struct *user;
> -	int sigpending;
> +	struct sigqueue *q = kmem_cache_alloc(sigqueue_cachep, flags);
>  
> -	/*
> -	 * Protect access to @t credentials. This can go away when all
> -	 * callers hold rcu read lock.
> -	 *
> -	 * NOTE! A pending signal will hold on to the user refcount,
> -	 * and we get/put the refcount only when the sigpending count
> -	 * changes from/to zero.
> -	 */
> -	rcu_read_lock();
> -	user = __task_cred(t)->user;
> -	sigpending = atomic_inc_return(&user->sigpending);
> -	if (sigpending == 1)
> -		get_uid(user);
> -	rcu_read_unlock();
> +	if (likely(q != NULL)) {
> +		bool overlimit;
>  
> -	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
> -		q = kmem_cache_alloc(sigqueue_cachep, flags);
> -	} else {
> -		print_dropped_signal(sig);
> -	}
> -
> -	if (unlikely(q == NULL)) {
> -		if (atomic_dec_and_test(&user->sigpending))
> -			free_uid(user);
> -	} else {
>  		INIT_LIST_HEAD(&q->list);
>  		q->flags = 0;
> -		q->user = user;
> +
> +		/*
> +		 * Protect access to @t credentials. This can go away when all
> +		 * callers hold rcu read lock.
> +		 */
> +		rcu_read_lock();
> +		q->ucounts = get_ucounts(task_ucounts(t));
> +		if (q->ucounts) {
> +			overlimit = inc_rlimit_ucounts_and_test(q->ucounts, UCOUNT_RLIMIT_SIGPENDING,
> +					1, task_rlimit(t, RLIMIT_SIGPENDING));
> +
> +			if (override_rlimit || likely(!overlimit)) {
> +				rcu_read_unlock();
> +				return q;
> +			}
> +		}
> +		rcu_read_unlock();

I believe you need to call __sigqueue_free here.

>  	}
>  
> -	return q;
> +	print_dropped_signal(sig);
> +	return NULL;
>  }
>  
>  static void __sigqueue_free(struct sigqueue *q)
>  {
>  	if (q->flags & SIGQUEUE_PREALLOC)
>  		return;
> -	if (atomic_dec_and_test(&q->user->sigpending))
> -		free_uid(q->user);
> +	if (q->ucounts) {
> +		dec_rlimit_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING, 1);
> +		put_ucounts(q->ucounts);
> +	}
>  	kmem_cache_free(sigqueue_cachep, q);
>  }
>  

Eric
