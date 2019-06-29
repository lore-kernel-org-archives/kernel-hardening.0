Return-Path: <SRS0=8tx1=U4=lists.openwall.com=kernel-hardening-return-16325-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84880C4321A
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Jun 2019 15:38:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CCF84208E3
	for <kernel-hardening@archiver.kernel.org>; Sat, 29 Jun 2019 15:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="lUU651ei"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCF84208E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16325-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26027 invoked by uid 550); 29 Jun 2019 15:37:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9490 invoked from network); 29 Jun 2019 14:30:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=070cp9I/SRMDJELJ0z/c3XEauBwl1ZxN5yPCygGTCPQ=;
        b=lUU651eipMCT1srkIPR9JOSY5V+6PQStClOz1RjE1XK7KjNH90pZCVnjbVIqaKOuD6
         HkZMsMa8gZBgOa5PveUDDogQfTC8GlJyozuhO2CSaqdIOsR9kFhTTP3yPedz7vDGEqv+
         bc9V4JC7pakYx3Erm+VSwwaocqvCd1k4naIdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=070cp9I/SRMDJELJ0z/c3XEauBwl1ZxN5yPCygGTCPQ=;
        b=ExUMSegcD8MqY7DYyHmEdJsAJt07ogq0Nlo/E997b78ggsxWuv3B7V0zoBYNZlCASL
         ETWNNZ1WyiLKLkzfYS0LXv2CIW5ejmzRz7RTyEOe/190XMjoJnXkoxJHaimsyT/+gchC
         fiM1joCuFm+mBfMr6uCNozMEgpyRe38NEb2CHWBo8khDN1k7G+aQGnPbW4FTpp1W0nZp
         FENeGkNpsgCGnMRf49gnPbfmq/izJGfdjhTs7jrFL9ZpY1mGoT8SeToAd56rty2tXjvO
         RL0Gz5sEwxlBm+w3oC2E44s6srXx7fNx0+2yPRimDyxv11LNtTF+cje0yW7jfb4tqHPh
         pRJw==
X-Gm-Message-State: APjAAAVk4W74DIHsGwJFUMgDUm0J66H9mavhxWQFfRLZbZu6cVZ3CjyQ
	/nZed7YyW3RZxnZWgYibwNFgwQ==
X-Google-Smtp-Source: APXvYqzKG09KKQ/W+bTS7i9nxQvsfETg7bFosDlNb6r3a88XlayWBx4N9262X8Ss4OhYe2mA5pAzew==
X-Received: by 2002:adf:c541:: with SMTP id s1mr11705107wrf.44.1561818630753;
        Sat, 29 Jun 2019 07:30:30 -0700 (PDT)
Date: Sat, 29 Jun 2019 16:30:24 +0200
From: Andrea Parri <andrea.parri@amarulasolutions.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, jannh@google.com, oleg@redhat.com,
	mathieu.desnoyers@efficios.com, willy@infradead.org,
	peterz@infradead.org, will.deacon@arm.com,
	paulmck@linux.vnet.ibm.com, elena.reshetova@intel.com,
	keescook@chromium.org, kernel-team@android.com,
	kernel-hardening@lists.openwall.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Message-ID: <20190629143024.GA6810@andrea>
References: <20190624184534.209896-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624184534.209896-1-joel@joelfernandes.org>
User-Agent: Mutt/1.5.24 (2015-08-30)

On Mon, Jun 24, 2019 at 02:45:34PM -0400, Joel Fernandes (Google) wrote:
> struct pid's count is an atomic_t field used as a refcount. Use
> refcount_t for it which is basically atomic_t but does additional
> checking to prevent use-after-free bugs.
> 
> For memory ordering, the only change is with the following:
>  -	if ((atomic_read(&pid->count) == 1) ||
>  -	     atomic_dec_and_test(&pid->count)) {
>  +	if (refcount_dec_and_test(&pid->count)) {
>  		kmem_cache_free(ns->pid_cachep, pid);
> 
> Here the change is from:
> Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
> This ACQUIRE should take care of making sure the free happens after the
> refcount_dec_and_test().
> 
> The above hunk also removes atomic_read() since it is not needed for the
> code to work and it is unclear how beneficial it is. The removal lets
> refcount_dec_and_test() check for cases where get_pid() happened before
> the object was freed.
> 
> Cc: jannh@google.com
> Cc: oleg@redhat.com
> Cc: mathieu.desnoyers@efficios.com
> Cc: willy@infradead.org
> Cc: peterz@infradead.org
> Cc: will.deacon@arm.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: elena.reshetova@intel.com
> Cc: keescook@chromium.org
> Cc: kernel-team@android.com
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

As always with these matters, it's quite possible that I'm missing
something subtle here; said this, ;-)  the patch does look good to
me: FWIW,

Reviewed-by: Andrea Parri <andrea.parri@amarulasolutions.com>

Thanks,
  Andrea


> 
> ---
> Changed to RFC to get any feedback on the memory ordering.
> 
> 
>  include/linux/pid.h | 5 +++--
>  kernel/pid.c        | 7 +++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 14a9a39da9c7..8cb86d377ff5 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -3,6 +3,7 @@
>  #define _LINUX_PID_H
>  
>  #include <linux/rculist.h>
> +#include <linux/refcount.h>
>  
>  enum pid_type
>  {
> @@ -56,7 +57,7 @@ struct upid {
>  
>  struct pid
>  {
> -	atomic_t count;
> +	refcount_t count;
>  	unsigned int level;
>  	/* lists of tasks that use this pid */
>  	struct hlist_head tasks[PIDTYPE_MAX];
> @@ -69,7 +70,7 @@ extern struct pid init_struct_pid;
>  static inline struct pid *get_pid(struct pid *pid)
>  {
>  	if (pid)
> -		atomic_inc(&pid->count);
> +		refcount_inc(&pid->count);
>  	return pid;
>  }
>  
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..89c4849fab5d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -37,7 +37,7 @@
>  #include <linux/init_task.h>
>  #include <linux/syscalls.h>
>  #include <linux/proc_ns.h>
> -#include <linux/proc_fs.h>
> +#include <linux/refcount.h>
>  #include <linux/sched/task.h>
>  #include <linux/idr.h>
>  
> @@ -106,8 +106,7 @@ void put_pid(struct pid *pid)
>  		return;
>  
>  	ns = pid->numbers[pid->level].ns;
> -	if ((atomic_read(&pid->count) == 1) ||
> -	     atomic_dec_and_test(&pid->count)) {
> +	if (refcount_dec_and_test(&pid->count)) {
>  		kmem_cache_free(ns->pid_cachep, pid);
>  		put_pid_ns(ns);
>  	}
> @@ -210,7 +209,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  	}
>  
>  	get_pid_ns(ns);
> -	atomic_set(&pid->count, 1);
> +	refcount_set(&pid->count, 1);
>  	for (type = 0; type < PIDTYPE_MAX; ++type)
>  		INIT_HLIST_HEAD(&pid->tasks[type]);
>  
> -- 
> 2.22.0.410.gd8fdbe21b5-goog
