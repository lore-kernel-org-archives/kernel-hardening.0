Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2011 09:22:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Message-Id: <20110615092221.b143c45a.rdunlap@xenotime.net>
In-Reply-To: <1308146299-13015-1-git-send-email-segoon@openwall.com>
References: <1308146299-13015-1-git-send-email-segoon@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 5/5 v3] procfs: add documentation for procfs mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>, Nikanth Karthikesan <knikanth@suse.de>, David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 15 Jun 2011 17:58:19 +0400 Vasiliy Kulikov wrote:

> Add documentation for procfs mount options.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Documentation/filesystems/proc.txt |   51 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index f481780..327a640 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -41,6 +41,8 @@ Table of Contents
>    3.5	/proc/<pid>/mountinfo - Information about mounts
>    3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
>  
> +  4	Configuring procfs
> +  4.1	Mount options
>  
>  ------------------------------------------------------------------------------
>  Preface
> @@ -1541,3 +1543,52 @@ a task to set its own or one of its thread siblings comm value. The comm value
>  is limited in size compared to the cmdline value, so writing anything longer
>  then the kernel's TASK_COMM_LEN (currently 16 chars) will result in a truncated
>  comm value.
> +
> +
> +------------------------------------------------------------------------------
> +Configuring procfs
> +------------------------------------------------------------------------------
> +
> +4.1	Mount options
> +---------------------
> +
> +The following mount options are supported:
> +
> +	hidepid=	Set /proc/<pid>/ access mode.
> +	hidenet		Hide /proc/<pid>/net/ from nonauthorized users.
> +	nohidenet	Don't hide /proc/<pid>/net/ from nonauthorized users.
> +	gid=		Set the group authorized to learn processes and
> +			networking information.
> +
> +hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
> +(default).
> +
> +hidepid=1 means users may not access any /proc/<pid>/ directories, but their

comma not needed above.

> +own.  Sensitive files like cmdline, io, sched*, status, wchan are now protected
> +against other users.  This makes impossible to learn whether any user runs

                              makes it impossible

> +specific program (given the program doesn't reveal itself by its behaviour).
> +As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
> +poorly written programs passing sensitive information via program arguments are
> +now protected against local eavesdroppers.
> +
> +hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
> +users.  It doesn't mean that it hides a fact whether a process with a specific

                           that it hides whether a process

> +pid value exists (it can be learned by other means, e.g. by sending signals),
> +but it hides process' uid and gid, which may be learned by stat()'ing
> +/proc/<pid>/ otherwise.  It greatly complicates intruder's task of gathering info

                                                   an intruder's

I would also prefer "information" instead of "info" (globally).

> +about running processes, whether some daemon runs with elevated privileges,
> +whether other user runs some sensitive program, whether other users run any

   whether another user runs

> +program at all, etc.
> +
> +hidenet means /proc/<pid>/net/ will be accessible to processes with
> +CAP_NET_ADMIN capability or to members of a special group.  It means
> +nonauthorized users may not learn any networking connections information.  If
> +network namespaces support is enabled (CONFIG_NET_NS=y) then common users would
> +obtain net directory, but all files would indicate no networking activity at
> +all.  If network namespaces are disabled, net directory is unaccessible to
> +common users.
> +
> +gid= means group authorized to learn processes information prohibited by
> +hidepid= and networking information prohibited by hidenet.  If you use some
> +daemon like identd which have to learn information about net/processes

                      which has to learn

> +information, just add identd to this group.
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
