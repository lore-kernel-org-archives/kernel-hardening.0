Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 19:34:24 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617153424.GA22220@albatros>
References: <20110617152912.GA21885@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617152912.GA21885@albatros>
Subject: [kernel-hardening] Re: [RFC v1] security: introduce ptrace_task_access_check()
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 19:29 +0400, Vasiliy Kulikov wrote:
> diff --git a/security/commoncap.c b/security/commoncap.c
> index a93b3b7..aa76791 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -155,6 +155,26 @@ out:
>  	return ret;
>  }
>  
> +int cap_ptrace_task_access_check(struct task_struct *task, struct task_struct *child,
> +	unsigned int mode)
> +{
> +	int ret = 0;
> +	const struct cred *cred, *child_cred;
> +
> +	rcu_read_lock();
> +	cred = __task_cred(task);
> +	child_cred = __task_cred(child);
> +	if (cred->user->user_ns == child_cred->user->user_ns &&
> +	    cap_issubset(child_cred->cap_permitted, cred->cap_permitted))
> +		goto out;
> +	if (ns_task_capable(task, child_cred->user->user_ns, CAP_SYS_PTRACE))
> +		goto out;
> +	ret = -EPERM;
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +

Actually cap_ptrace_access_check() may just call
cap_ptrace_task_access_check().

>  /**
>   * cap_ptrace_traceme - Determine whether another process may trace the current
>   * @parent: The task proposed to be the tracer

> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index 9637e10..f6582a7 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -200,6 +200,49 @@ out_audit:
>  	return rc;
>  }
>  
> +int smk_taskacc(struct task_struct *task, char *obj_label, u32 mode, struct smk_audit_info *a)
> +{
> +	struct task_smack *tsp = task_cred_xxx(task, security);
> +	char *subject_label = smk_of_task(tsp);
> +	int may;
> +	int rc;
> +
> +	/*
> +	 * Check the global rule list
> +	 */
> +	rc = smk_access(subject_label, obj_label, mode, NULL);
> +	if (rc == 0) {
> +		/*
> +		 * If there is an entry in the task's rule list
> +		 * it can further restrict access.
> +		 */
> +		may = smk_access_entry(subject_label, obj_label, &tsp->smk_rules);
> +		if (may < 0)
> +			goto out_audit;
> +		if ((mode & may) == mode)
> +			goto out_audit;
> +		rc = -EACCES;
> +	}
> +
> +	/*
> +	 * Return if a specific label has been designated as the
> +	 * only one that gets privilege and current does not
> +	 * have that label.
> +	 */
> +	if (smack_onlycap != NULL && smack_onlycap != subject_label)
> +		goto out_audit;
> +
> +	if (task_capable(task, CAP_MAC_OVERRIDE))
> +		rc = 0;
> +
> +out_audit:
> +#ifdef CONFIG_AUDIT
> +	if (a)
> +		smack_log(subject_label, obj_label, mode, rc, a);
> +#endif
> +	return rc;
> +}
> +

And smk_curacc() is a variant of smk_taskacc().

>  /**
>   * smk_curacc - determine if current has a specific access to an object
>   * @obj_label: a pointer to the object's Smack label

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
