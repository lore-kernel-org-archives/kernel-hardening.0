Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Jun 2011 09:19:34 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20110620170600.GA25601@albatros>
Message-ID: <alpine.LRH.2.00.1106210918290.14297@tundra.namei.org>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org> <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org> <20110620103917.GA5230@albatros> <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org> <20110620170600.GA25601@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 20 Jun 2011, Vasiliy Kulikov wrote:

> > If they depend on specific permissions, yes.
> 
> Could you please then clarify why does this patch changes
> pid_revalidate() behaviour:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=99f895518368252ba862cc15ce4eb98ebbe1bec6
> 
> It changes files permissions to allow userspace apps to quickly stat
> files, not looking into /proc/PID/status.  So, uid and gid are explicit
> ABI.  Breaking procfs uid/gid attributes would break these apps.
> 

Right, but I'm saying that apps which depend on specific permissions are 
broken, which is not the uid / gid attributes.


-- 
James Morris
<jmorris@namei.org>
