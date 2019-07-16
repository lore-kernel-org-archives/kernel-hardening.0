Return-Path: <SRS0=pM4v=VN=lists.openwall.com=kernel-hardening-return-16474-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A9EAC7618F
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:24:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E4032145D
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:24:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E4032145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16474-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11673 invoked by uid 550); 16 Jul 2019 18:23:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11651 invoked from network); 16 Jul 2019 18:23:54 -0000
Date: Tue, 16 Jul 2019 11:22:37 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH v2 2/9] rcu: Add support for consolidated-RCU reader
 checking
Message-ID: <20190716182237.GA22819@linux.ibm.com>
References: <20190712170024.111093-1-joel@joelfernandes.org>
 <20190712170024.111093-3-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712170024.111093-3-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160225

On Fri, Jul 12, 2019 at 01:00:17PM -0400, Joel Fernandes (Google) wrote:
> This patch adds support for checking RCU reader sections in list
> traversal macros. Optionally, if the list macro is called under SRCU or
> other lock/mutex protection, then appropriate lockdep expressions can be
> passed to make the checks pass.
> 
> Existing list_for_each_entry_rcu() invocations don't need to pass the
> optional fourth argument (cond) unless they are under some non-RCU
> protection and needs to make lockdep check pass.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

If you fold in the checks for extra parameters, I will take this
one and also 1/9.

							Thanx, Paul

> ---
>  include/linux/rculist.h  | 28 +++++++++++++++++++++++-----
>  include/linux/rcupdate.h |  7 +++++++
>  kernel/rcu/Kconfig.debug | 11 +++++++++++
>  kernel/rcu/update.c      | 14 ++++++++++++++
>  4 files changed, 55 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e91ec9ddcd30..1048160625bb 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -40,6 +40,20 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
>  
> +/*
> + * Check during list traversal that we are within an RCU reader
> + */
> +
> +#ifdef CONFIG_PROVE_RCU_LIST
> +#define __list_check_rcu(dummy, cond, ...)				\
> +	({								\
> +	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),		\
> +			 "RCU-list traversed in non-reader section!");	\
> +	 })
> +#else
> +#define __list_check_rcu(dummy, cond, ...) ({})
> +#endif
> +
>  /*
>   * Insert a new entry between two known consecutive entries.
>   *
> @@ -343,14 +357,16 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
>   * @pos:	the type * to use as a loop cursor.
>   * @head:	the head for your list.
>   * @member:	the name of the list_head within the struct.
> + * @cond:	optional lockdep expression if called from non-RCU protection.
>   *
>   * This list-traversal primitive may safely run concurrently with
>   * the _rcu list-mutation primitives such as list_add_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> -#define list_for_each_entry_rcu(pos, head, member) \
> -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
> -		&pos->member != (head); \
> +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> +	for (__list_check_rcu(dummy, ## cond, 0),			\
> +	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
>  
>  /**
> @@ -616,13 +632,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * @pos:	the type * to use as a loop cursor.
>   * @head:	the head for your list.
>   * @member:	the name of the hlist_node within the struct.
> + * @cond:	optional lockdep expression if called from non-RCU protection.
>   *
>   * This list-traversal primitive may safely run concurrently with
>   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> -#define hlist_for_each_entry_rcu(pos, head, member)			\
> -	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> +	for (__list_check_rcu(dummy, ## cond, 0),			\
> +	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>  			typeof(*(pos)), member);			\
>  		pos;							\
>  		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 922bb6848813..712b464ab960 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -223,6 +223,7 @@ int debug_lockdep_rcu_enabled(void);
>  int rcu_read_lock_held(void);
>  int rcu_read_lock_bh_held(void);
>  int rcu_read_lock_sched_held(void);
> +int rcu_read_lock_any_held(void);
>  
>  #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
> @@ -243,6 +244,12 @@ static inline int rcu_read_lock_sched_held(void)
>  {
>  	return !preemptible();
>  }
> +
> +static inline int rcu_read_lock_any_held(void)
> +{
> +	return !preemptible();
> +}
> +
>  #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  #ifdef CONFIG_PROVE_RCU
> diff --git a/kernel/rcu/Kconfig.debug b/kernel/rcu/Kconfig.debug
> index 0ec7d1d33a14..b20d0e2903d1 100644
> --- a/kernel/rcu/Kconfig.debug
> +++ b/kernel/rcu/Kconfig.debug
> @@ -7,6 +7,17 @@ menu "RCU Debugging"
>  config PROVE_RCU
>  	def_bool PROVE_LOCKING
>  
> +config PROVE_RCU_LIST
> +	bool "RCU list lockdep debugging"
> +	depends on PROVE_RCU
> +	default n
> +	help
> +	  Enable RCU lockdep checking for list usages. By default it is
> +	  turned off since there are several list RCU users that still
> +	  need to be converted to pass a lockdep expression. To prevent
> +	  false-positive splats, we keep it default disabled but once all
> +	  users are converted, we can remove this config option.
> +
>  config TORTURE_TEST
>  	tristate
>  	default n
> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> index bb961cd89e76..0cc7be0fb6b5 100644
> --- a/kernel/rcu/update.c
> +++ b/kernel/rcu/update.c
> @@ -294,6 +294,20 @@ int rcu_read_lock_bh_held(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
>  
> +int rcu_read_lock_any_held(void)
> +{
> +	if (!debug_lockdep_rcu_enabled())
> +		return 1;
> +	if (!rcu_is_watching())
> +		return 0;
> +	if (!rcu_lockdep_current_cpu_online())
> +		return 0;
> +	if (lock_is_held(&rcu_lock_map) || lock_is_held(&rcu_sched_lock_map))
> +		return 1;
> +	return !preemptible();
> +}
> +EXPORT_SYMBOL_GPL(rcu_read_lock_any_held);
> +
>  #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
>  
>  /**
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
