MIME-Version: 1.0
References: <20180821000444.7004-1-casey.schaufler@intel.com> <20180821000444.7004-4-casey.schaufler@intel.com>
In-Reply-To: <20180821000444.7004-4-casey.schaufler@intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 21 Aug 2018 19:23:58 +0200
Message-ID: <CAG48ez1D-DPBP8ACA1W5=XZLNKUeVj7ZOGUG8uJ2nL1xOSR_9Q@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] LSM: Security module checking for side-channel dangers
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 21, 2018 at 2:05 AM Casey Schaufler
<casey.schaufler@intel.com> wrote:
>
> The sidechannel LSM checks for cases where a side-channel
> attack may be dangerous based on security attributes of tasks.
> This includes:
>         Effective UID of the tasks is different
>         Capablity sets are different
>         Tasks are in different namespaces
> An option is also provided to assert that task are never
> to be considered safe. This is high paranoia, and expensive
> as well.
>
> Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> ---
[...]
> diff --git a/security/sidechannel/Kconfig b/security/sidechannel/Kconfig
> new file mode 100644
> index 000000000000..af9396534128
> --- /dev/null
> +++ b/security/sidechannel/Kconfig
[...]
> +config SECURITY_SIDECHANNEL_CAPABILITIES
> +       bool "Sidechannel check on capability sets"
> +       depends on SECURITY_SIDECHANNEL
> +       default n
> +       help
> +         Assume that tasks with different sets of privilege may be
> +         subject to side-channel attacks. Potential interactions
> +         where the attacker lacks capabilities the attacked has
> +         are blocked.
> +
> +          If you are unsure how to answer this question, answer N.
> +
> +config SECURITY_SIDECHANNEL_NAMESPACES
> +       bool "Sidechannel check on namespaces"
> +       depends on SECURITY_SIDECHANNEL
> +       depends on NAMESPACES
> +       default n
> +       help
> +         Assume that tasks in different namespaces may be
> +         subject to side-channel attacks. User, PID and cgroup
> +         namespaces are checked.
> +
> +          If you are unsure how to answer this question, answer N.
[...]
> diff --git a/security/sidechannel/sidechannel.c b/security/sidechannel/sidechannel.c
> new file mode 100644
> index 000000000000..4da7d6dafdc5
> --- /dev/null
> +++ b/security/sidechannel/sidechannel.c
[...]
> +/*
> + * safe_by_capability - Are task and current sidechannel safe?
> + * @p: task to check on
> + *
> + * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
> + */
> +#ifdef CONFIG_SECURITY_SIDECHANNEL_CAPABILITIES
> +static int safe_by_capability(struct task_struct *p)
> +{
> +       const struct cred *ccred = current_real_cred();
> +       const struct cred *pcred = rcu_dereference_protected(p->real_cred, 1);
> +
> +       /*
> +        * Capabilities checks. Considered safe if:
> +        *      current has all the capabilities p does
> +        */
> +       if (ccred != pcred &&
> +           !cap_issubset(pcred->cap_effective, ccred->cap_effective))
> +               return -EACCES;
> +       return 0;
> +}

On its own (without safe_by_namespace()), this check makes no sense, I
think. You're performing a test on the namespaced capability sets
without looking at which user namespaces they are relative to. Maybe
either introduce a configuration dependency or add an extra namespace
check here?

> +static int safe_by_namespace(struct task_struct *p)
> +{
> +       struct cgroup_namespace *ccgn = NULL;
> +       struct cgroup_namespace *pcgn = NULL;
> +       const struct cred *ccred;
> +       const struct cred *pcred;
> +
> +       /*
> +        * Namespace checks. Considered safe if:
> +        *      cgroup namespace is the same
> +        *      User namespace is the same
> +        *      PID namespace is the same
> +        */
> +       if (current->nsproxy)
> +               ccgn = current->nsproxy->cgroup_ns;
> +       if (p->nsproxy)
> +               pcgn = p->nsproxy->cgroup_ns;
> +       if (ccgn != pcgn)
> +               return -EACCES;
> +
> +       ccred = current_real_cred();
> +       pcred = rcu_dereference_protected(p->real_cred, 1);
> +
> +       if (ccred->user_ns != pcred->user_ns)
> +               return -EACCES;
> +       if (task_active_pid_ns(current) != task_active_pid_ns(p))
> +               return -EACCES;
> +       return 0;
> +}
