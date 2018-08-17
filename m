MIME-Version: 1.0
References: <20180817221624.10232-1-casey.schaufler@intel.com> <20180817221624.10232-4-casey.schaufler@intel.com>
In-Reply-To: <20180817221624.10232-4-casey.schaufler@intel.com>
From: Jann Horn <jannh@google.com>
Date: Sat, 18 Aug 2018 01:52:30 +0200
Message-ID: <CAG48ez3aB5X9=hqepovG6L4vQYZjzHZ6fWqdd4Vtzh92u2J5fQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/5] LSM: Security module checking for side-channel dangers
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Aug 18, 2018 at 12:17 AM Casey Schaufler
<casey.schaufler@intel.com> wrote:
>
> From: Casey Schaufler <cschaufler@localhost.localdomain>
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
[...]
> +#ifdef CONFIG_SECURITY_SIDECHANNEL_UIDS
> +static int safe_by_uid(struct task_struct *p)
> +{
> +       const struct cred *ccred = current_real_cred();
> +       const struct cred *pcred = get_task_cred(p);
> +
> +       /*
> +        * Credential checks. Considered safe if:
> +        *      UIDs are the same
> +        */
> +       if (ccred != pcred && ccred->euid.val != pcred->euid.val)
> +               return -EACCES;
> +       return 0;
> +}

This function looks bogus. get_task_cred() bumps the refcount on the
returned cred struct pointer, but you don't drop it. You probably want
to use something that doesn't fiddle with the refcount at all here to
avoid cacheline bouncing - possibly a raw rcu_dereference_protected()
if there are no better helpers.

Same thing for the other get_task_cred() calls further down in the patch.
