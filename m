Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4DFB7605.9000909@redhat.com>
Date: Fri, 17 Jun 2011 11:43:01 -0400
From: Eric Paris <eparis@redhat.com>
MIME-Version: 1.0
References: <20110617152912.GA21885@albatros>
In-Reply-To: <20110617152912.GA21885@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC v1] security: introduce ptrace_task_access_check()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>, John Johansen <john.johansen@canonical.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 06/17/2011 11:29 AM, Vasiliy Kulikov wrote:
> Hi,
>
> This patch introduces ptrace_task_access_check() to be able to check
> whether a specific task (not current) is able to ptrace another task
> (might be current).  I need it to call "reversed" ptrace_may_access()
> with swapped current and target task.
>
> Specifically, I need it to filter taskstats and proc connector requests
> for a restriction of getting other processes' information:
>
> http://permalink.gmane.org/gmane.linux.kernel/1155354
>
>
> Please help me to figure out how such patch should be divided to be
> applied.  I think about such scheme:
>
> 1) add generic security/* functions.
> 2-4) add ptrace_task_access_check() for SMACK, AppArmor and SELinux.
> 5) change ptrace_access_check() in security ops and all LSMs to
>      ptrace_task_access_check().
>
> But I'd like to hear maintainers' oppinions not to put useless efforts.

Not a real review, but I didn't instantly grok the need for the new cap 
functions.  So maybe that's it's own patch with it's own change log.  
After that you should just add the 'parent' task to 
ptrace_access_check() and fix all of the LSMs to handle the new 
semantics at once.  No need to rename the function or do a bunch of 
seperate patchs.  All of us LSM authors can just ACK our little part and 
James can take the patch when everyone has their say.  I think that will 
make history the cleanest.....

-Eric
