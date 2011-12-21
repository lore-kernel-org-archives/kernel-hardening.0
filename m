Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EF16DE1.8010909@canonical.com>
Date: Tue, 20 Dec 2011 21:25:53 -0800
From: John Johansen <john.johansen@canonical.com>
MIME-Version: 1.0
References: <1324333066-12452-1-git-send-email-keescook@chromium.org> <1324333066-12452-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1324333066-12452-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>, James Morris <jmorris@namei.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/19/2011 02:17 PM, Kees Cook wrote:
> This adds the Yama Linux Security Module to collect DAC security
> improvements (specifically just ptrace restrictions for now) that have
> existed in various forms over the years and have been carried outside the
> mainline kernel by other Linux distributions like Openwall and grsecurity.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v9:
>  - Remove pid_ns feature. Touches too many core kernel areas at the moment.
> v8:
>  - Updated RCU usage and locking, thanks to Mandeep Singh Baines.
> v7:
>  - Merge ptrace restrictions, which include various fixes from
>    Vasiliy Kulikov, Solar Designer, Ming Lei, Tetsuo Handa, and Eric Paris.
>  - Merge pid_ns feature from Vasiliy Kulikov.
>  - Rip out link restrictions for initial upstreaming.
> v6:
>  - Fix interaction with overlayfs, thanks to Andy Whitcroft and Leann
>    Ogasawara.
>  - Clarify rationale for LSM.
>  - Move documentation under security subdirectory.
> v5:
>  - resend, with ptrace relationship interface
> v4:
>  - drop accidentally included fs/exec.c chunk.
> v3:
>  - drop needless cap_ callbacks.
>  - fix usage of get_task_comm.
>  - drop CONFIG_ of sysctl defaults, as recommended by Andi Kleen.
>  - require SYSCTL.
> v2:
>  - add rcu locking, thanks to Tetsuo Handa.
>  - add Documentation/Yama.txt for summary of features.

This is looking really good.  I have a few notes inlined below but I didn't
find any problems.

I am happy giving it an
Acked-by: John Johansen <john.johansen@canonical.com>

or Reviewed-by: if that is more appropriate here

<snip>

> index 0000000..1029fcd
> --- /dev/null
> +++ b/security/yama/yama_lsm.c
> @@ -0,0 +1,315 @@
> +/*
> + * Yama Linux Security Module
> + *
> + * Author: Kees Cook <keescook@chromium.org>
> + *
> + * Copyright (C) 2010 Canonical, Ltd.
> + * Copyright (C) 2011 The Chromium OS Authors.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/security.h>
> +#include <linux/sysctl.h>
> +#include <linux/ptrace.h>
> +#include <linux/prctl.h>
> +#include <linux/ratelimit.h>
> +
> +static int ptrace_scope = 1;
> +
> +/* describe a ptrace relationship for potential exception */
> +struct ptrace_relation {
> +	struct task_struct *tracer;
> +	struct task_struct *tracee;
> +	struct list_head node;
> +};
> +
> +static LIST_HEAD(ptracer_relations);
> +static DEFINE_SPINLOCK(ptracer_relations_lock);
> +
> +/**
> + * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
> + * @tracer: the task_struct of the process doing the ptrace
> + * @tracee: the task_struct of the process to be ptraced
> + *
> + * Returns 0 if relationship was added, -ve on error.
> + */
It might be good to add a note here, or a more explicit note in the Yama
Documentation that a tracee can only have a single tracer (+ its descendants).

In the documentation
  An inferior can declare which other process (and its descendents) are allowed
  to call PTRACE_ATTACH against it

Its real easy to not catch its process instead of processes

> +static int yama_ptracer_add(struct task_struct *tracer,
> +			    struct task_struct *tracee)
> +{
> +	int rc = 0;
> +	struct ptrace_relation *added;
> +	struct ptrace_relation *entry, *relation = NULL;
> +
> +	added = kmalloc(sizeof(*added), GFP_KERNEL);
> +	spin_lock_bh(&ptracer_relations_lock);
> +	list_for_each_entry(entry, &ptracer_relations, node)
> +		if (entry->tracee == tracee) {
> +			relation = entry;
> +			break;
> +		}
> +	if (!relation) {
> +		relation = added;
> +		if (!relation) {
> +			rc = -ENOMEM;
> +			goto unlock_out;
> +		}
> +		relation->tracee = tracee;
> +		list_add(&relation->node, &ptracer_relations);
> +	}
> +	relation->tracer = tracer;
> +
> +unlock_out:
> +	spin_unlock_bh(&ptracer_relations_lock);
> +	if (added && added != relation)
> +		kfree(added);
> +
> +	return rc;
> +}
> +
I think pulling the out of the locking makes the fn a little easier to
read.
static int yama_ptracer_add(struct task_struct *tracer,
			    struct task_struct *tracee)
{
	int rc = 0;
	struct ptrace_relation *added;
	struct ptrace_relation *entry, *relation = NULL;

	added = kmalloc(sizeof(*added), GFP_KERNEL);
	if (!added)
		return -ENOMEM;

	spin_lock_bh(&ptracer_relations_lock);
	list_for_each_entry(entry, &ptracer_relations, node)
		if (entry->tracee == tracee) {
			relation = entry;
			break;
		}
	if (!relation) {
		relation = added;
		relation->tracee = tracee;
		list_add(&relation->node, &ptracer_relations);
	}
	relation->tracer = tracer;

	spin_unlock_bh(&ptracer_relations_lock);
	if (added != relation)
		kfree(added);

	return rc;
}

or if you prefer to keep a single exit point

static int yama_ptracer_add(struct task_struct *tracer,
			    struct task_struct *tracee)
{
	int rc = -ENOMEM;
	struct ptrace_relation *added;
	struct ptrace_relation *entry, *relation = NULL;

	added = kmalloc(sizeof(*added), GFP_KERNEL);
	if (!added)
		goto out;

	spin_lock_bh(&ptracer_relations_lock);
	list_for_each_entry(entry, &ptracer_relations, node)
		if (entry->tracee == tracee) {
			relation = entry;
			break;
		}
	if (!relation) {
		relation = added;
		relation->tracee = tracee;
		list_add(&relation->node, &ptracer_relations);
	}
	relation->tracer = tracer;

	spin_unlock_bh(&ptracer_relations_lock);
	if (added != relation)
		kfree(added);

	rc = 0;
out:
	return rc;
}

> +/**
> + * yama_ptracer_del - remove exceptions related to the given tasks
> + * @tracer: remove any relation where tracer task matches
> + * @tracee: remove any relation where tracee task matches
> + */
> +static void yama_ptracer_del(struct task_struct *tracer,
> +			     struct task_struct *tracee)
> +{
> +	struct ptrace_relation *relation;
> +	struct list_head *list, *safe;
> +
> +	spin_lock_bh(&ptracer_relations_lock);
> +	list_for_each_safe(list, safe, &ptracer_relations) {
> +		relation = list_entry(list, struct ptrace_relation, node);
You could use list_for_each_entry_safe here
	list_for_each_entry_safe(relation, safe, &ptracer_relations, node)

> +		if (relation->tracee == tracee ||
> +		    relation->tracer == tracer) {
> +			list_del(&relation->node);
> +			kfree(relation);
> +		}
> +	}
> +	spin_unlock_bh(&ptracer_relations_lock);
> +}
> +
> +/**
> + * yama_task_free - check for task_pid to remove from exception list
> + * @task: task being removed
> + */
> +static void yama_task_free(struct task_struct *task)
> +{
> +	yama_ptracer_del(task, task);
> +}
> +
> +/**
> + * yama_task_prctl - check for Yama-specific prctl operations
> + * @option: operation
> + * @arg2: argument
> + * @arg3: argument
> + * @arg4: argument
> + * @arg5: argument
> + *
> + * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
> + * does not handle the given option.
> + */
So maybe add a note here about why the tracee is being stored via the
group_leader, but that the tracer isn't.  Its not really a problem but I
tripped over this at first as I was going through the code.
