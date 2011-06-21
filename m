Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 21 Jun 2011 22:28:27 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110621182827.GA8960@albatros>
References: <alpine.LRH.2.00.1106192154220.7503@taiga.selinuxproject.org>
 <alpine.LRH.2.00.1106201455560.6055@tundra.namei.org>
 <20110620103917.GA5230@albatros>
 <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1106202040400.10448@tundra.namei.org>
Subject: [kernel-hardening] Re: [RFC 2/5 v4] procfs: add hidepid= and gid= mount options
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2011 at 20:43 +1000, James Morris wrote:
> On Mon, 20 Jun 2011, Vasiliy Kulikov wrote:
> 
> > > Can you provide evidence that this is a useful feature?  e.g. examples of 
> > > exploits / techniques which would be _usefully_ hampered or blocked.
> > 
> > First, most of these files are usefull in sense of statistics gathering
> > and debugging.  There is no reason to provide this information to the
> > world.
> > 
> > Second, yes, it blocks one source of information used in timing attacks,
> > just use reading the counters as more or less precise time measurement
> > when actual timing measurements are not precise enough.
> 
> Can you provide concrete examples?

This is a PoC of ~user/.ssh/authorized_keys presence infoleak (and
whether it is empty) using taskstats interface:

http://www.openwall.com/lists/oss-security/2011/06/21/12

/proc/PID/io can be used too.

More close interaction with ssh client would gain authorized_keys' size or,
probably, what pam module denied the access.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
