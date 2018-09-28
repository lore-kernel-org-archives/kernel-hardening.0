From: "Schaufler, Casey" <casey.schaufler@intel.com>
Subject: RE: [PATCH v5 5/5] sidechannel: Linux Security Module for
 sidechannel
Date: Fri, 28 Sep 2018 17:40:52 +0000
Message-ID: <99FC4B6EFCEFD44486C35F4C281DC6732146466E@ORSMSX107.amr.corp.intel.com>
References: <20180926203446.2004-1-casey.schaufler@intel.com>
 <20180926203446.2004-6-casey.schaufler@intel.com>
 <alpine.LRH.2.21.1809280744560.8410@namei.org>
 <025d4742-5947-545e-f603-502a0c5ee03f@schaufler-ca.com>
 <alpine.LRH.2.21.1809280846280.8410@namei.org>
 <99FC4B6EFCEFD44486C35F4C281DC67321463CE3@ORSMSX107.amr.corp.intel.com>
 <alpine.LRH.2.21.1809280936290.13517@namei.org>
 <CAG48ez3Jnao-5z3O8s=RdoAx8=b68C_1pfKNKJSm+6R_HyU_fg@mail.gmail.com>
 <alpine.LRH.2.21.1809290233130.15725@namei.org>
In-Reply-To: <alpine.LRH.2.21.1809290233130.15725@namei.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, kernel list <linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

> -----Original Message-----
> From: James Morris [mailto:jmorris@namei.org]
> Sent: Friday, September 28, 2018 9:33 AM
> To: Jann Horn <jannh@google.com>
> Cc: Schaufler, Casey <casey.schaufler@intel.com>; Casey Schaufler
> <casey@schaufler-ca.com>; kristen@linux.intel.com; Kernel Hardening
> <kernel-hardening@lists.openwall.com>; Dock, Deneen T
> <deneen.t.dock@intel.com>; kernel list <linux-kernel@vger.kernel.org>;
> Hansen, Dave <dave.hansen@intel.com>; linux-security-module <linux-securi=
ty-
> module@vger.kernel.org>; selinux@tycho.nsa.gov; Arjan van de Ven
> <arjan@linux.intel.com>
> Subject: Re: [PATCH v5 5/5] sidechannel: Linux Security Module for sidech=
annel
>=20
> On Fri, 28 Sep 2018, Jann Horn wrote:
>=20
> > > so with this hard-coded logic, you are saying this case is
> > > 'safe' in a sidechannel context.
> > >
> > > Which hints at the deeper issue that containers are a userland
> > > abstraction.  Protection of containers needs to be defined by userlan=
d
> > > policy.
> >
> > Or just compare mount namespaces additionally/instead. I think that
> > containers will always use those, because AFAIK nobody uses chroot()
> > for containers, given that the kernel makes absolutely no security
> > guarantees about chroot().
>=20
> We can't define this in the kernel. It has no concept of containers.
>=20
> People utilize some combination of namespaces and cgroups and call them
> containers,

There is an amazing variety of things called containers out there.
I cite them as a use case, not a requirement.

> but we can't make assumptions from the kernel on what any of
> this means from a security point of view, and hard-code kernel policy
> based on those assumptions.

We can assume that namespaces are being used as a separation mechanism.
That makes processes in different namespaces potentially vulnerable to
side-channel attacks. That's true regardless of whether or not someone is
using namespaces to implement containers.=20

> This is violating the principal of separating mechanism and policy, and
> also imposing semantics across the kernel/user boundary. The latter
> creates an ABI which we can then never break.

The effects of the sidechannel security module are not API visible.
The potential impact is on performance. This implementation of
PTRACE_MODE_SCHED does not change what happens, but may affect
when it happens. It is intended to aid in optimizing the use of expensive
anti-side-channel countermeasures.
