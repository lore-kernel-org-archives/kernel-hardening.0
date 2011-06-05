Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 23:26:41 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110605192641.GA9240@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros> <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla> <20110604205955.GA5972@openwall.com> <20110605182430.GA5789@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605182430.GA5789@albatros>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy, all -

To comment on this in detail (such as on specific source code changes),
I'd need to dive into it myself, effectively duplicating Vasiliy's work.
So I am not doing that, but I'd appreciate it if others in here review
and comment (preferably, folks with more up-to-date experience of
patching these areas of the kernel - such as after the introduction of
namespaces; my own experience is too rusty).  I think it's going to be
similar for other tasks Vasiliy will be working on under this project -
I am happy to provide overall guidance, but I am too rusty on many of
the details involved and I am not going to have time to (re-)learn them
this summer.  So any help is appreciated.

On Sun, Jun 05, 2011 at 10:24:31PM +0400, Vasiliy Kulikov wrote:
> This patch introduces support of procfs mount options and adds mount
> options to restrict access to /proc/PID/ directories and /proc/PID/net/
> contents.  The default backward-compatible behaviour is left untouched.
> 
> The first mount option is called "hidepid" and its value defines how much
> info about processes we want to be available for non-owners:
> 
> hidepid=0 (default) means the current behaviour - anybody may read all
> /proc/PID/* files.

Aren't some /prod/PID/* files restricted by default, in stock kernels?
I think several are (auxv, fd/, mem).  So perhaps re-word this.

> hidepid=1 means all files not running as current user and group are

"... files not running ..." needs to be re-worded.

> TODO/thoughs:
>   - /proc/pid/net/ currently doesn't show ANYTHING, even "." and "..".
>     This is confusing :)

Ouch.  Can't you simply restrict its perms such that this directory
can't be listed unless you have privs?  It should act as a normal mode
550 directory on a regular filesystem.

>   - copy options description to Documenataion/filesystems/procfs.txt

Yes.

>   - need to alter "(inode->i_mode == (S_IFDIR|S_IRUGO|S_IXUGO))" checks
>     to honour non-pid directories.

I see this in the patch, but can't really comment without reviewing the
code in full context myself.

>   - what if one keeps open /proc/PID/ while executing set*id/capable
>     binary?

Then they deliberately grant this privilege to this process (and maybe
to its heirs).  I see no problem with that.

However, if a set*id/capable binary can be tricked into opening
/proc/PID/ or a /proc/PID/* entry on its own, and would leave the fd
open for whatever other program(s) it invokes, then we have a problem.
But that should probably be regarded as an issue of that specific
program, unless the underlying cause enabling the specific attack is in
the kernel or in a library.  I find it unlikely that an issue like that
would be specific to just /proc/PID; it'd probably be usable on other
restricted-perms directories and/or files as well.

>   - maybe hidenet belongs to net namespace, not pid?  However, it is
>     seen through procfs, which is per-pid_namespace.

I am not the right person to comment on that.

> +	if (pid->hide_net &&
> +	    (!capable(CAP_NET_ADMIN) && !in_group_p(pid->pid_gid)))

capable() sets a flag when it makes use of the capability (or at least
it used to), visible via pacct.  So, unless anything has changed in this
area, it is best to check capable() last, such that it's only reached
when it actually makes a difference.  Thus, I'd write:

	if (pid->hide_net && !in_group_p(pid->pid_gid) &&
	    !capable(CAP_NET_ADMIN))

Also, what did you mean by the extra braces?  Just separating the
setting check from the permissions check for readability?  I don't think
this helps.

Thanks,

Alexander
