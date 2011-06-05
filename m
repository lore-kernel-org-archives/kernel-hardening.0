Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 23:40:52 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110605194052.GA9370@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros> <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla> <20110604205955.GA5972@openwall.com> <20110605191747.GA6174@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605191747.GA6174@albatros>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 11:17:47PM +0400, Vasiliy Kulikov wrote:
> On Sun, Jun 05, 2011 at 00:59 +0400, Solar Designer wrote:
> > Here's a related thought: if these mount options happen to affect all
> > instances of the filesystem (in the same container), maybe they should
> > be sysctl's instead?
> 
> AFAIR, only net namespaces have their own sysctl sets.  Other sysctls
> are global.  So, implementing pid_namespace-specific sysctl would be a
> bit weird (according to current policies).

Here's what we have immediate need for, in practice:

We need to be able to mount /proc with different permission settings in
different OpenVZ containers (perhaps running different distros, which
have their different defaults - e.g., Owl will use the restricted proc
options by default, but other distros mostly won't).

Since recent versions of OpenVZ build upon the namespaces code that has
been upstream'ed, I guess this will rely on upstream's namespaces code
(once we move to RHEL6'ish OpenVZ kernels and beyond), correct?

Now, leaving sysctl's aside and speaking of mount options only for now,
what happens when a container mounts /proc with umask=007, but then
another container mounts /proc without that option or with umask=0?
Does the first container retain its restricted perms, including for
newly appearing entries under its /proc?  If so, where is this different
setting stored?  Is it per mount (preferable)?  Is it per pid namespace
(OK)?  Or per net namespace (weird)?

Thanks,

Alexander
