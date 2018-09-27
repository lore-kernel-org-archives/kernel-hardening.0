Date: Fri, 28 Sep 2018 08:47:13 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v5 5/5] sidechannel: Linux Security Module for
 sidechannel
In-Reply-To: <025d4742-5947-545e-f603-502a0c5ee03f@schaufler-ca.com>
Message-ID: <alpine.LRH.2.21.1809280846280.8410@namei.org>
References: <20180926203446.2004-1-casey.schaufler@intel.com> <20180926203446.2004-6-casey.schaufler@intel.com> <alpine.LRH.2.21.1809280744560.8410@namei.org> <025d4742-5947-545e-f603-502a0c5ee03f@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Casey Schaufler <casey.schaufler@intel.com>, kristen@linux.intel.com, kernel-hardening@lists.openwall.com, deneen.t.dock@intel.com, linux-kernel@vger.kernel.org, dave.hansen@intel.com, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 27 Sep 2018, Casey Schaufler wrote:

> On 9/27/2018 2:45 PM, James Morris wrote:
> > On Wed, 26 Sep 2018, Casey Schaufler wrote:
> >
> >> +	/*
> >> +	 * Namespace checks. Considered safe if:
> >> +	 *	cgroup namespace is the same
> >> +	 *	User namespace is the same
> >> +	 *	PID namespace is the same
> >> +	 */
> >> +	if (current->nsproxy)
> >> +		ccgn = current->nsproxy->cgroup_ns;
> >> +	if (p->nsproxy)
> >> +		pcgn = p->nsproxy->cgroup_ns;
> >> +	if (ccgn != pcgn)
> >> +		return -EACCES;
> >> +	if (current->cred->user_ns != p->cred->user_ns)
> >> +		return -EACCES;
> >> +	if (task_active_pid_ns(current) != task_active_pid_ns(p))
> >> +		return -EACCES;
> >> +	return 0;
> > I really don't like the idea of hard-coding namespace security semantics 
> > in an LSM.  Also, I'm not sure if these semantics make any sense.
> 
> Checks on namespaces where explicitly requested.

By whom and what is the rationale?


-- 
James Morris
<jmorris@namei.org>
