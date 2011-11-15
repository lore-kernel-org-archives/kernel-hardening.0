Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EC2D568.4040001@xenotime.net>
Date: Tue, 15 Nov 2011 13:11:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
References: <20111115112208.GC3002@albatros>
In-Reply-To: <20111115112208.GC3002@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 3/3] procfs: add documentation for procfs mount options
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/15/2011 03:22 AM, Vasiliy Kulikov wrote:
> Signed-off-by: Vasiliy Kulikov <seooon@openwall.com>
> --
>  Documentation/filesystems/proc.txt |   39 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index 0ec91f0..518987e 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -1542,3 +1544,40 @@ a task to set its own or one of its thread siblings comm value. The comm value
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
> +	gid=		Set the group authorized to learn processes information.
> +
> +hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
> +(default).
> +
> +hidepid=1 means users may not access any /proc/<pid>/ directories, but their

                                                         directories but their
(drop comma)

> +own.  Sensitive files like cmdline, sched*, status are now protected against
> +other users.  This makes impossible to learn whether any user runs

                 This makes it impossible

> +specific program (given the program doesn't reveal itself by its behaviour).
> +As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
> +poorly written programs passing sensitive information via program arguments are
> +now protected against local eavesdroppers.
> +
> +hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
> +users.  It doesn't mean that it hides a fact whether a process with a specific
> +pid value exists (it can be learned by other means, e.g. by "kill -0 $PID"),
> +but it hides process' uid and gid, which may be learned by stat()'ing
> +/proc/<pid>/ otherwise.  It greatly complicates intruder's task of gathering info

                                       complicates an intruder's task of gathering information
(or data) [+ fix line length]


> +about running processes, whether some daemon runs with elevated privileges,
> +whether other user runs some sensitive program, whether other users run any
> +program at all, etc.
> +
> +gid= defines a group authorized to learn processes information otherwise
> +prohibited by hidepid=.  If you use some daemon like identd which have to learn

                                                               which has to learn
or                                                             which must learn
or                                                             which needs to learn

> +information about processes information, just add identd to this group.
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
