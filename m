Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 20 Jun 2011 19:44:29 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110620154429.GA12879@albatros>
References: <20110617171152.GA1389@albatros>
 <4DFF5795.9080609@redhat.com>
 <20110620150001.GF12469@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620150001.GF12469@mail.hallyn.com>
Subject: [kernel-hardening] Re: [RFC v2] security: intoduce ptrace_task_may_access_current
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com, serge@hallyn.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2011 at 10:00 -0500, Serge Hallyn wrote:
> > >diff --git a/kernel/capability.c b/kernel/capability.c
> > >index 283c529..bc9b07f 100644
> > >--- a/kernel/capability.c
> > >+++ b/kernel/capability.c
> > >@@ -356,6 +356,30 @@ bool capable(int cap)
> > >  }
> > >  EXPORT_SYMBOL(capable);
> > >
> > >+bool task_capable(struct task_struct *task, int cap)
> > >+{
> > >+	return ns_task_capable(task,&init_user_ns, cap);
> > >+}
> > >+EXPORT_SYMBOL(task_capable);
> > 
> > Why do we keep adding things like task_capable?  Can't we just stop
> > adding non-lsm functions and just call the right LSM functions from
> > now on?  This is my original comments mostly directed at Serge.  I'm
> > to the point where I want to NAK anything new in kernel/capability.c
> > (and yes, I know i'm guilty in the paste)
> > 
> > >+bool ns_task_capable(struct task_struct *task, struct user_namespace *ns, int cap)
> 
> Can you just use has_ns_capability() at the places where you wanted to
> use your new ns_task_capable()?  It won't set PF_SUPERPRIV, but you
> can't set that on another task anyway IIRC.

has_ns_capability() doesn't touch LSMs, but ns_task_capable() uses
security_task_capable() which uses LSMs.

Actually, I'm a bit confused in sense of what capable functions should
be used in specific cases.  Where we need to inform LSM and where not.
I don't want to bypass LSMs where it should not do it otherwise.  In the
patch I've copied alredy existing behaviour leaving LSM iteraction
as-is.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
