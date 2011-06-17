Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 19:50:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617155058.GB22588@albatros>
References: <20110617152912.GA21885@albatros>
 <4DFB7605.9000909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB7605.9000909@redhat.com>
Subject: [kernel-hardening] Re: [RFC v1] security: introduce ptrace_task_access_check()
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 11:43 -0400, Eric Paris wrote:
> >Please help me to figure out how such patch should be divided to be
> >applied.  I think about such scheme:
> >
> >1) add generic security/* functions.
> >2-4) add ptrace_task_access_check() for SMACK, AppArmor and SELinux.
> >5) change ptrace_access_check() in security ops and all LSMs to
> >     ptrace_task_access_check().
> >
> >But I'd like to hear maintainers' oppinions not to put useless efforts.
> 
> Not a real review, but I didn't instantly grok the need for the new
> cap functions.

It is needed because of capable(CAP_SYS_PTRACE) and similar inside of
ptrace_may_access() implementations.

>  So maybe that's it's own patch with it's own change
> log.  After that you should just add the 'parent' task to
> ptrace_access_check() and fix all of the LSMs to handle the new
> semantics at once.  No need to rename the function or do a bunch of
> seperate patchs.

I thought it would represent function's semantic changes more strongly.

>  All of us LSM authors can just ACK our little part
> and James can take the patch when everyone has their say.  I think
> that will make history the cleanest.....

Great!  It would be much simple for me too :)

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
