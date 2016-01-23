Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<1453502345-30416-2-git-send-email-keescook@chromium.org>
Date: Fri, 22 Jan 2016 21:10:07 -0600
In-Reply-To: <1453502345-30416-2-git-send-email-keescook@chromium.org> (Kees
	Cook's message of "Fri, 22 Jan 2016 14:39:04 -0800")
Message-ID: <87oacdyos0.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of proc_dointvec_minmax_sysadmin
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> Several sysctls expect a state where the highest value (in extra2) is
> locked once set for that boot. Yama does this, and kptr_restrict should
> be doing it. This extracts Yama's logic and adds it to the existing
> proc_dointvec_minmax_sysadmin, taking care to avoid the simple boolean
> states (which do not get locked). Since Yama wants to be checking a
> different capability, we build wrappers for both cases (CAP_SYS_ADMIN
> and CAP_SYS_PTRACE).

Sigh this sysctl appears susceptible to known attacks.

In my quick skim I believe this sysctl implementation that checks
capabilities is susceptible to attacks where the already open file
descriptor is set as stdout on a setuid root application.

Can we come up with an interface that isn't exploitable by an
application that will act as a setuid cat?

Eric

> -#ifdef CONFIG_PRINTK
> -static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
> -				void __user *buffer, size_t *lenp, loff_t *ppos)
> +int proc_dointvec_minmax_cap(int cap, struct ctl_table *table, int write,
> +			     void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
> -	if (write && !capable(CAP_SYS_ADMIN))
> +	struct ctl_table table_copy;
> +	int value;
> +
> +	/* Require init capabilities to make changes. */
> +	if (write && !capable(cap))
>  		return -EPERM;
>  
> -	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +	/*
> +	 * To deal with const sysctl tables, we make a copy to perform
> +	 * the locking. When data is >1 and ==extra2, lock extra1 to
> +	 * extra2 to stop the value from being changed any further at
> +	 * runtime.
> +	 */
> +	table_copy = *table;
> +	value = *(int *)table_copy.data;
> +	if (value > 1 && value == *(int *)table_copy.extra2)
> +		table_copy.extra1 = table_copy.extra2;
> +
> +	return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
>  }
> -#endif
