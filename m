MIME-Version: 1.0
References: <20180926203446.2004-1-casey.schaufler@intel.com>
 <20180926203446.2004-6-casey.schaufler@intel.com> <alpine.LRH.2.21.1809280744560.8410@namei.org>
 <025d4742-5947-545e-f603-502a0c5ee03f@schaufler-ca.com> <alpine.LRH.2.21.1809280846280.8410@namei.org>
 <99FC4B6EFCEFD44486C35F4C281DC67321463CE3@ORSMSX107.amr.corp.intel.com> <alpine.LRH.2.21.1809280936290.13517@namei.org>
In-Reply-To: <alpine.LRH.2.21.1809280936290.13517@namei.org>
From: Jann Horn <jannh@google.com>
Date: Fri, 28 Sep 2018 01:47:39 +0200
Message-ID: <CAG48ez3Jnao-5z3O8s=RdoAx8=b68C_1pfKNKJSm+6R_HyU_fg@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] sidechannel: Linux Security Module for sidechannel
Content-Type: text/plain; charset="UTF-8"
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey.schaufler@intel.com>, Casey Schaufler <casey@schaufler-ca.com>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, deneen.t.dock@intel.com, kernel list <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 28, 2018 at 1:43 AM James Morris <jmorris@namei.org> wrote:
> On Thu, 27 Sep 2018, Schaufler, Casey wrote:
> > > > On 9/27/2018 2:45 PM, James Morris wrote:
> > > > > On Wed, 26 Sep 2018, Casey Schaufler wrote:
> > > > >
> > > > >> +      /*
> > > > >> +       * Namespace checks. Considered safe if:
> > > > >> +       *      cgroup namespace is the same
> > > > >> +       *      User namespace is the same
> > > > >> +       *      PID namespace is the same
> > > > >> +       */
> > > > >> +      if (current->nsproxy)
> > > > >> +              ccgn = current->nsproxy->cgroup_ns;
> > > > >> +      if (p->nsproxy)
> > > > >> +              pcgn = p->nsproxy->cgroup_ns;
> > > > >> +      if (ccgn != pcgn)
> > > > >> +              return -EACCES;
> > > > >> +      if (current->cred->user_ns != p->cred->user_ns)
> > > > >> +              return -EACCES;
> > > > >> +      if (task_active_pid_ns(current) != task_active_pid_ns(p))
> > > > >> +              return -EACCES;
> > > > >> +      return 0;
> > > > > I really don't like the idea of hard-coding namespace security semantics
> > > > > in an LSM.  Also, I'm not sure if these semantics make any sense.
> > > >
> > > > Checks on namespaces where explicitly requested.
> > >
> > > By whom and what is the rationale?
> >
> > The rationale is to protect containers. Since those closest thing
> > there is to a definition of containers is "uses namespaces" that
> > becomes the focus. Separating them out does not make too much
> > sense as I would expect someone concerned with one to be concerned
> > with all.
>
> A lot of people will not be using user namespaces due to security
> concerns,

Ugh.

> so with this hard-coded logic, you are saying this case is
> 'safe' in a sidechannel context.
>
> Which hints at the deeper issue that containers are a userland
> abstraction.  Protection of containers needs to be defined by userland
> policy.

Or just compare mount namespaces additionally/instead. I think that
containers will always use those, because AFAIK nobody uses chroot()
for containers, given that the kernel makes absolutely no security
guarantees about chroot().
