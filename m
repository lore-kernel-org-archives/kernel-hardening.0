MIME-Version: 1.0
References: <20180815235355.14908-1-casey.schaufler@intel.com> <20180815235355.14908-4-casey.schaufler@intel.com>
In-Reply-To: <20180815235355.14908-4-casey.schaufler@intel.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 16 Aug 2018 16:15:52 +0200
Message-ID: <CAG48ez1kLTcc6aDf7hYXFMw4oD1hp9Dx74-wuAjbQ7hdAQzE=Q@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] LSM: Security module checking for side-channel dangers
Content-Type: text/plain; charset="UTF-8"
To: casey.schaufler@intel.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, SMACK-discuss@lists.01.org, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 16, 2018 at 11:51 AM Casey Schaufler
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
> +static int safe_by_uid(struct task_struct *p)
> +{
> +       const struct cred *ccred = current->cred;
> +       const struct cred *pcred = p->cred;

See below.

[...]
> +static int safe_by_capability(struct task_struct *p)
> +{
> +       const struct cred *ccred = current->cred;
> +       const struct cred *pcred = p->cred;

See below.

[...]
> +       if (current->cred->user_ns != p->cred->user_ns)
> +               return -EACCES;

Shouldn't this access be using one of the rcu_dereference_* helpers?
Something like rcu_dereference_protected(..., 1).

Also, you're looking at ->cred, and you don't want to do that. ->cred
are the *subjective* credentials of the task, meaning the credentials
that should only be used when this task actively performs an access.
Depending on what userspace is doing, an unprivileged process' ->cred
will randomly flake to something with GLOBAL_ROOT_UID because of
override_creds() calls - for example, if you access a file through
overlayfs in certain ways, your ->cred will temporarily be overwritten
by ovl_override_creds(), which mostly switches to the credentials of
the filesystem's creator (iow, normally root). coredumps can also
override the EUID with GLOBAL_ROOT_UID:

    if (__get_dumpable(cprm.mm_flags) == SUID_DUMP_ROOT) {
        /* Setuid core dump mode */
        cred->fsuid = GLOBAL_ROOT_UID;  /* Dump root private */
        need_suid_safe = true;
    }

    retval = coredump_wait(siginfo->si_signo, &core_state);
    if (retval < 0)
        goto fail_creds;

    old_cred = override_creds(cred);

Please use the objective credentials (->real_cred) instead, which are
not subject to random override_creds() effects, and are designed to be
used when looking at the privileges associated with an overall task
(as opposed to the privileges associated with the task's current
syscall context).

At least for the current-> access, you probably want
current_real_cred(), which has been defined for this kind of use.
