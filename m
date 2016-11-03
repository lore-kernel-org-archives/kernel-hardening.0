Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Nov 2016 19:24:41 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161103182441.GA29904@laptop.thejh.net>
References: <1478187038-19954-2-git-send-email-wluikil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478187038-19954-2-git-send-email-wluikil@gmail.com>
Subject: [kernel-hardening] Re: [2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: Lafcadio Wluiki <wluikil@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 03, 2016 at 09:30:38AM -0600, Lafcadio Wluiki wrote:
> This adds a new per-task hidepid= flag that is honored by procfs when
> presenting /proc to the user, in addition to the existing hidepid= mount
> option. So far, hidepid= was exclusively a per-pidns setting. Locking
> down a set of processes so that they cannot see other user's processes
> without affecting the rest of the system thus currently requires
> creation of a private PID namespace, with all the complexity it brings,
> including maintaining a stub init process as PID 1 and losing the
> ability to see processes of the same user on the rest of the system.
[...]
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 89d5be4..c0a1d3e 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2270,6 +2270,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  	case PR_GET_FP_MODE:
>  		error = GET_FP_MODE(me);
>  		break;
> +	case PR_SET_HIDEPID:
> +		if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE)
> +			return -EINVAL;
> +		if (arg2 < me->hide_pid)
> +			return -EPERM;
> +		me->hide_pid = arg2;
> +		break;

Should we test for ns_capable(CAP_SYS_ADMIN)||no_new_privs here?
I think it wouldn't hurt, and I'd like to avoid adding new ways in which
the execution of setuid programs can be influenced. OTOH, people already
use hidepid now, and it's not an issue... I'm not sure. Opinions?

@Lafcadio: Do you think that requiring no_new_privs to be set would
break your usecase? Would nginx need to still be able to execute setuid
binaries?

Aside from this, and the comments Kees already made, this looks good
to me.
