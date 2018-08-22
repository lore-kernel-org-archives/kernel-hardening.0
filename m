MIME-Version: 1.0
References: <20180821000444.7004-1-casey.schaufler@intel.com>
 <20180821000444.7004-4-casey.schaufler@intel.com> <CAG48ez1D-DPBP8ACA1W5=XZLNKUeVj7ZOGUG8uJ2nL1xOSR_9Q@mail.gmail.com>
 <99FC4B6EFCEFD44486C35F4C281DC673214402D3@ORSMSX107.amr.corp.intel.com>
 <CAG48ez3bh5cFgZ5ZY63pszTV+KX+KC4utRCm7E8en+uF5w6vKw@mail.gmail.com> <99FC4B6EFCEFD44486C35F4C281DC67321440770@ORSMSX107.amr.corp.intel.com>
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC67321440770@ORSMSX107.amr.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 22 Aug 2018 19:03:45 +0200
Message-ID: <CAG48ez3OkpcrC34LJTWAvH4ZvREW7jDVkeMBZrLQe6cRSEBheg@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] LSM: Security module checking for side-channel dangers
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 22, 2018 at 6:39 PM Schaufler, Casey
<casey.schaufler@intel.com> wrote:
>
> > -----Original Message-----
> > From: Jann Horn [mailto:jannh@google.com]
> > Sent: Tuesday, August 21, 2018 6:01 PM
> > To: Schaufler, Casey <casey.schaufler@intel.com>
> > Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>; kernel list
> > <linux-kernel@vger.kernel.org>; linux-security-module <linux-security-
> > module@vger.kernel.org>; selinux@tycho.nsa.gov; Hansen, Dave
> > <dave.hansen@intel.com>; Dock, Deneen T <deneen.t.dock@intel.com>;
> > kristen@linux.intel.com; Arjan van de Ven <arjan@linux.intel.com>
> > Subject: Re: [PATCH v3 3/5] LSM: Security module checking for side-channel
> > dangers
> >
> > On Wed, Aug 22, 2018 at 1:44 AM Schaufler, Casey
> > <casey.schaufler@intel.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Jann Horn [mailto:jannh@google.com]
> > > > Sent: Tuesday, August 21, 2018 10:24 AM
> > > > To: Schaufler, Casey <casey.schaufler@intel.com>
> > > > Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>; kernel list
> > > > <linux-kernel@vger.kernel.org>; linux-security-module <linux-security-
> > > > module@vger.kernel.org>; selinux@tycho.nsa.gov; Hansen, Dave
> > > > <dave.hansen@intel.com>; Dock, Deneen T <deneen.t.dock@intel.com>;
> > > > kristen@linux.intel.com; Arjan van de Ven <arjan@linux.intel.com>
> > > > Subject: Re: [PATCH v3 3/5] LSM: Security module checking for side-channel
> > > > dangers
> > > >
> > > > On Tue, Aug 21, 2018 at 2:05 AM Casey Schaufler
> > > > <casey.schaufler@intel.com> wrote:
> > > > >
> > > > > The sidechannel LSM checks for cases where a side-channel
> > > > > attack may be dangerous based on security attributes of tasks.
> > > > > This includes:
> > > > >         Effective UID of the tasks is different
> > > > >         Capablity sets are different
> > > > >         Tasks are in different namespaces
> > > > > An option is also provided to assert that task are never
> > > > > to be considered safe. This is high paranoia, and expensive
> > > > > as well.
> > > > >
> > > > > Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> > > > > ---
> > > > [...]
> > > > > diff --git a/security/sidechannel/Kconfig b/security/sidechannel/Kconfig
> > > > > new file mode 100644
> > > > > index 000000000000..af9396534128
> > > > > --- /dev/null
> > > > > +++ b/security/sidechannel/Kconfig
> > > > [...]
> > > > > +config SECURITY_SIDECHANNEL_CAPABILITIES
> > > > > +       bool "Sidechannel check on capability sets"
> > > > > +       depends on SECURITY_SIDECHANNEL
> > > > > +       default n
> > > > > +       help
> > > > > +         Assume that tasks with different sets of privilege may be
> > > > > +         subject to side-channel attacks. Potential interactions
> > > > > +         where the attacker lacks capabilities the attacked has
> > > > > +         are blocked.
> > > > > +
> > > > > +          If you are unsure how to answer this question, answer N.
> > > > > +
> > > > > +config SECURITY_SIDECHANNEL_NAMESPACES
> > > > > +       bool "Sidechannel check on namespaces"
> > > > > +       depends on SECURITY_SIDECHANNEL
> > > > > +       depends on NAMESPACES
> > > > > +       default n
> > > > > +       help
> > > > > +         Assume that tasks in different namespaces may be
> > > > > +         subject to side-channel attacks. User, PID and cgroup
> > > > > +         namespaces are checked.
> > > > > +
> > > > > +          If you are unsure how to answer this question, answer N.
> > > > [...]
> > > > > diff --git a/security/sidechannel/sidechannel.c
> > > > b/security/sidechannel/sidechannel.c
> > > > > new file mode 100644
> > > > > index 000000000000..4da7d6dafdc5
> > > > > --- /dev/null
> > > > > +++ b/security/sidechannel/sidechannel.c
> > > > [...]
> > > > > +/*
> > > > > + * safe_by_capability - Are task and current sidechannel safe?
> > > > > + * @p: task to check on
> > > > > + *
> > > > > + * Returns 0 if the tasks are sidechannel safe, -EACCES otherwise.
> > > > > + */
> > > > > +#ifdef CONFIG_SECURITY_SIDECHANNEL_CAPABILITIES
> > > > > +static int safe_by_capability(struct task_struct *p)
> > > > > +{
> > > > > +       const struct cred *ccred = current_real_cred();
> > > > > +       const struct cred *pcred = rcu_dereference_protected(p->real_cred,
> > 1);
> > > > > +
> > > > > +       /*
> > > > > +        * Capabilities checks. Considered safe if:
> > > > > +        *      current has all the capabilities p does
> > > > > +        */
> > > > > +       if (ccred != pcred &&
> > > > > +           !cap_issubset(pcred->cap_effective, ccred->cap_effective))
> > > > > +               return -EACCES;
> > > > > +       return 0;
> > > > > +}
> > > >
> > > > On its own (without safe_by_namespace()), this check makes no sense, I
> > > > think. You're performing a test on the namespaced capability sets
> > > > without looking at which user namespaces they are relative to. Maybe
> > > > either introduce a configuration dependency or add an extra namespace
> > > > check here?
> > >
> > > If you don't have namespaces the check is correct. If you do, and use
> > > safe_by_namespace() you're also correct. If you use namespaces and
> > > care about side-channel attacks you should enable the namespace checks.
> >
> > By "use namespaces", you mean "have CONFIG_USER_NS=y set in the kernel
> > config", right?
>
> That's correct.
>
> > It doesn't matter much whether processes on your system are
> > intentionally using namespaces;
>
> Also correct.
>
> > what matters is whether some random
> > process can just use unshare(CLONE_NEWUSER) to increase its apparent
> > capabilities and bypass the checks performed by this LSM.
>
> Which puts it in a new user namespace, which gets caught by the
> safe_by_namespace() check.
>
> > My expectation is that unshare(CLONE_NEWUSER) should not increase the
> > caller's abilities. Your patch seems to violate that expectation.
>
> If you have CONFIG_USER_NS and not
> CONFIG_SECURITY_SIDECHANNEL_NAMESPACES you do not increase the
> caller's abilities from what you have without safesidechannel. If you have
> CONFIG_SECURITY_SIDECHANNEL_NAMESPACES you have additional
> restriction (assuming one considers setting the barrier a restriction) that
> the tasks must be in the same namespace(s). As I said, if you care about
> namespace implications you should configure the system accordingly.
>
> > > I don't see real value in adding namespace checks in the capability checks
> > > for the event where someone has said they don't want namespace checks.
> >
> > Capabilities are meaningless if you don't consider the namespaces
> > relative to which they are effective.
>
> Agreed. But if CONFIG_NAMESPACES is off you are always in the same
> namespace and if it is on you should use the sidechannel namespace check.
>
> > Anyone can get CAP_SYS_ADMIN or
> > whatever other capabilities they want, by design - just not relative
> > to objects they don't own. Look:
> >
> > $ grep ^Cap /proc/self/status
> > CapInh: 0000000000000000
> > CapPrm: 0000000000000000
> > CapEff: 0000000000000000
> > CapBnd: 0000003fffffffff
> > CapAmb: 0000000000000000
> > $ unshare -Ur grep ^Cap /proc/self/status
> > CapInh: 0000000000000000
> > CapPrm: 0000003fffffffff
> > CapEff: 0000003fffffffff
> > CapBnd: 0000003fffffffff
> > CapAmb: 0000000000000000
> >
> > Ta-daa! Full capability set.
>
> Yes, but in a different namespace. Hence the namespace check.
>
> What I hear you saying is that you don't want the capability check
> to be independent of the namespace check.

The capability check doesn't always require a namespace match, and I
don't care about non-user namespaces here, but I would prefer it if
A->B with A having some capabilities required A's user namespace to be
ancestor-or-self of B's user namespace. But alternatively:

> This conflicts with the
> strong desire expressed to me when I started this that the configuration
> should be flexible. I can beef up the description of the various options.
> Would that address the issue?

It seems to me that it would make sense to express this as something
like a Kconfig dependency. But I guess if you document that the
combination of CONFIG_USER_NS=y,
CONFIG_SECURITY_SIDECHANNEL_NAMESPACES=n and
SECURITY_SIDECHANNEL_CAPABILITIES=y is nonsensical, that works too. I
just don't see why you'd want to provide such a footgun?
Configurability is nice, but if we know that one of the possible
configurations doesn't make sense, it seems like a good idea to just
not allow the system to be configured that way.

You say that you were asked to make the configuration flexible. Did
whoever told you that actually want the ability to compare raw
capability sets on a system with CONFIG_USER_NS=y, and understand what
semantics that has (and doesn't have)? Or was their intent more along
the lines of "we want to flush if the new task has higher privileges,
capability-wise, than the old task; but we don't explicitly care about
namespaces"?

> > > I got early feedback that configurability was considered important.
> > > This is the correct behavior if you want namespace checks to be
> > > separately configurable from capability checks. You could ask for
> > > distinct configuration options for each kind of namespace, but, well, yuck.
> > >
> > > > > +static int safe_by_namespace(struct task_struct *p)
> > > > > +{
> > > > > +       struct cgroup_namespace *ccgn = NULL;
> > > > > +       struct cgroup_namespace *pcgn = NULL;
> > > > > +       const struct cred *ccred;
> > > > > +       const struct cred *pcred;
> > > > > +
> > > > > +       /*
> > > > > +        * Namespace checks. Considered safe if:
> > > > > +        *      cgroup namespace is the same
> > > > > +        *      User namespace is the same
> > > > > +        *      PID namespace is the same
> > > > > +        */
> > > > > +       if (current->nsproxy)
> > > > > +               ccgn = current->nsproxy->cgroup_ns;
> > > > > +       if (p->nsproxy)
> > > > > +               pcgn = p->nsproxy->cgroup_ns;
> > > > > +       if (ccgn != pcgn)
> > > > > +               return -EACCES;
> > > > > +
> > > > > +       ccred = current_real_cred();
> > > > > +       pcred = rcu_dereference_protected(p->real_cred, 1);
> > > > > +
> > > > > +       if (ccred->user_ns != pcred->user_ns)
> > > > > +               return -EACCES;
> > > > > +       if (task_active_pid_ns(current) != task_active_pid_ns(p))
> > > > > +               return -EACCES;
> > > > > +       return 0;
> > > > > +}
