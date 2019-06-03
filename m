Date: Mon, 3 Jun 2019 10:01:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Message-ID: <20190603080128.GA3436@hirez.programming.kicks-ass.net>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601222738.6856-2-joel@joelfernandes.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, linux-pm@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com, "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 01, 2019 at 06:27:33PM -0400, Joel Fernandes (Google) wrote:
> +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> +	if (COUNT_VARGS(cond) != 0) {					\
> +		__list_check_rcu_cond(0, ## cond);			\
> +	} else {							\
> +		__list_check_rcu();					\
> +	}								\
> +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
>  
>  /**
> @@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> +	if (COUNT_VARGS(cond) != 0) {					\
> +		__list_check_rcu_cond(0, ## cond);			\
> +	} else {							\
> +		__list_check_rcu();					\
> +	}								\
>  	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>  			typeof(*(pos)), member);			\
>  		pos;							\


This breaks code like:

	if (...)
		list_for_each_entry_rcu(...);

as they are no longer a single statement. You'll have to frob it into
the initializer part of the for statement.
