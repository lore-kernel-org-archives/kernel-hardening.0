Subject: Re: [PATCH v5 5/5] sidechannel: Linux Security Module for sidechannel
References: <20180926203446.2004-1-casey.schaufler@intel.com>
 <20180926203446.2004-6-casey.schaufler@intel.com>
 <alpine.LRH.2.21.1809280744560.8410@namei.org>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <025d4742-5947-545e-f603-502a0c5ee03f@schaufler-ca.com>
Date: Thu, 27 Sep 2018 15:39:54 -0700
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.1809280744560.8410@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: James Morris <jmorris@namei.org>, Casey Schaufler <casey.schaufler@intel.com>
Cc: kristen@linux.intel.com, kernel-hardening@lists.openwall.com, deneen.t.dock@intel.com, linux-kernel@vger.kernel.org, dave.hansen@intel.com, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On 9/27/2018 2:45 PM, James Morris wrote:
> On Wed, 26 Sep 2018, Casey Schaufler wrote:
>
>> +	/*
>> +	 * Namespace checks. Considered safe if:
>> +	 *	cgroup namespace is the same
>> +	 *	User namespace is the same
>> +	 *	PID namespace is the same
>> +	 */
>> +	if (current->nsproxy)
>> +		ccgn = current->nsproxy->cgroup_ns;
>> +	if (p->nsproxy)
>> +		pcgn = p->nsproxy->cgroup_ns;
>> +	if (ccgn != pcgn)
>> +		return -EACCES;
>> +	if (current->cred->user_ns != p->cred->user_ns)
>> +		return -EACCES;
>> +	if (task_active_pid_ns(current) != task_active_pid_ns(p))
>> +		return -EACCES;
>> +	return 0;
> I really don't like the idea of hard-coding namespace security semantics 
> in an LSM.  Also, I'm not sure if these semantics make any sense.

Checks on namespaces where explicitly requested. I think
these are the most sensible, but I'm willing to be educated.
I was also requested to check on potential issues between containers,
but as there is no kernel concept of containers this is the
best I see we can do.

> It least make it user configurable.

Would you have a suggested granularity? I could have a
configuration option for each of cgroups, user and pid
namespaces but that's getting to be a lot of knobs to
twist.
