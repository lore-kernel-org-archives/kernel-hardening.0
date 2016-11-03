Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1478187038-19954-2-git-send-email-wluikil@gmail.com>
References: <1478187038-19954-1-git-send-email-wluikil@gmail.com> <1478187038-19954-2-git-send-email-wluikil@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Nov 2016 10:12:55 -0600
Message-ID: <CAGXu5jLZnkwK3NRV7qy=fi51_W4rP4-jGzeYSwceuvSz7_Ht8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] procfs/tasks: add a simple per-task procfs hidepid= field
To: Lafcadio Wluiki <wluikil@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, Jann Horn <jann@thejh.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 3, 2016 at 9:30 AM, Lafcadio Wluiki <wluikil@gmail.com> wrote:
> (Third, rebased submission, since first two submissions yielded no replie=
s.)
>
> This adds a new per-task hidepid=3D flag that is honored by procfs when
> presenting /proc to the user, in addition to the existing hidepid=3D moun=
t
> option. So far, hidepid=3D was exclusively a per-pidns setting. Locking
> down a set of processes so that they cannot see other user's processes
> without affecting the rest of the system thus currently requires
> creation of a private PID namespace, with all the complexity it brings,
> including maintaining a stub init process as PID 1 and losing the
> ability to see processes of the same user on the rest of the system.
>
> With this patch all acesss and visibility checks in procfs now
> honour two fields:
>
>         a) the existing hide_pid field in the PID namespace
>         b) the new hide_pid in struct task_struct
>
> Access/visibility is only granted if both fields permit it; the more
> restrictive one wins. By default the new task_struct hide_pid value
> defaults to 0, which means behaviour is not changed from the status quo.
>
> Setting the per-process hide_pid value is done via a new PR_SET_HIDEPID
> prctl() option which takes the same three supported values as the
> hidepid=3D mount option. The per-process hide_pid may only be increased,
> never decreased, thus ensuring that once applied, processes can never
> escape such a hide_pid jail.  When a process forks it inherits its
> parent's hide_pid value.
>
> Suggested usecase: let's say nginx runs as user "www-data". After
> dropping privileges it may now call:
>
>         =E2=80=A6
>         prctl(PR_SET_HIDEPID, 2);
>         =E2=80=A6
>
> And from that point on neither nginx itself, nor any of its child
> processes may see processes in /proc anymore that belong to a different
> user than "www-data". Other services running on the same system remain
> unaffected.
>
> This should permit Linux distributions to more comprehensively lock down
> their services, as it allows an isolated opt-in for hidepid=3D for
> specific services. Previously hidepid=3D could only be set system-wide,
> and then specific services had to be excluded by group membership,
> essentially a more complex concept of opt-out.
>
> A test-tool that validates this functionality is available here:
>
>         https://paste.fedoraproject.org/412975/71967605/
>
> Signed-off-by: Lafcadio Wluiki <wluikil@gmail.com>

I like this idea: it meaningfully reduces attack surface, even though
it doesn't ensure the same confinement as a pid namespace (e.g. a
process with this prctl set can still direct syscalls to pids that are
hidden). However, the attack surface in /proc is relatively large
compared to the syscalls that use pids.

For task launchers, this may overlap nicely with no_new_privs too.

Some suggestions/nits below...

> ---
>  fs/proc/array.c            |  3 +++
>  fs/proc/base.c             |  6 ++++--
>  include/linux/init_task.h  |  1 +
>  include/linux/sched.h      |  1 +
>  include/uapi/linux/prctl.h |  4 ++++
>  kernel/fork.c              |  1 +
>  kernel/sys.c               | 10 ++++++++++
>  7 files changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 81818ad..ea801e5 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -163,6 +163,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         const struct cred *cred;
>         pid_t ppid, tpid =3D 0, tgid, ngid;
>         unsigned int max_fds =3D 0;
> +       int hide_pid;
>
>         rcu_read_lock();
>         ppid =3D pid_alive(p) ?
> @@ -183,6 +184,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         task_lock(p);
>         if (p->files)
>                 max_fds =3D files_fdtable(p->files)->max_fds;
> +       hide_pid =3D p->hide_pid;
>         task_unlock(p);
>         rcu_read_unlock();
>
> @@ -201,6 +203,7 @@ static inline void task_state(struct seq_file *m, str=
uct pid_namespace *ns,
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->egid=
));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->sgid=
));
>         seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->fsgi=
d));
> +       seq_put_decimal_ull(m, "\nHidePID:\t", hide_pid);
>         seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
>
>         seq_puts(m, "\nGroups:\t");

This should get an addition to table 1-2 of
Documentation/filesystems/proc.txt that covers the contents of
/proc/$pid/status


> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ae5e13c..6c9a42b 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -709,7 +709,8 @@ static bool has_pid_permissions(struct pid_namespace =
*pid,
>                                  struct task_struct *task,
>                                  int hide_pid_min)
>  {
> -       if (pid->hide_pid < hide_pid_min)
> +       if (pid->hide_pid < hide_pid_min &&
> +           current->hide_pid < hide_pid_min)
>                 return true;
>         if (in_group_p(pid->pid_gid))
>                 return true;
> @@ -730,7 +731,8 @@ static int proc_pid_permission(struct inode *inode, i=
nt mask)
>         put_task_struct(task);
>
>         if (!has_perms) {
> -               if (pid->hide_pid =3D=3D HIDEPID_INVISIBLE) {
> +               if (pid->hide_pid =3D=3D HIDEPID_INVISIBLE ||
> +                   current->hide_pid =3D=3D HIDEPID_INVISIBLE) {
>                         /*
>                          * Let's make getdents(), stat(), and open()
>                          * consistent with each other.  If a process

Instead of open-coding both of these "||" tests, I think it might be
cleaner to just choose the highest protection value, and use that in
both comparisons. e.g.

    int hide_pid =3D max(pid->hide_pid, current->hide_pid);

    if (hide_pid < hide_pid_min) ...

    9if (hide_pid =3D=3D HIDEPID_INVISIBLE) ...


> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> index 325f649..c87de0e 100644
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -250,6 +250,7 @@ extern struct task_group root_task_group;
>         .cpu_timers     =3D INIT_CPU_TIMERS(tsk.cpu_timers),             =
 \
>         .pi_lock        =3D __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),       =
 \
>         .timer_slack_ns =3D 50000, /* 50 usec default slack */           =
 \
> +       .hide_pid       =3D 0,                                           =
 \
>         .pids =3D {                                                      =
 \
>                 [PIDTYPE_PID]  =3D INIT_PID_LINK(PIDTYPE_PID),           =
 \
>                 [PIDTYPE_PGID] =3D INIT_PID_LINK(PIDTYPE_PGID),          =
 \
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 348f51b..3e8ca16 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1572,6 +1572,7 @@ struct task_struct {
>         /* unserialized, strictly 'current' */
>         unsigned in_execve:1; /* bit to tell LSMs we're in execve */
>         unsigned in_iowait:1;
> +       unsigned hide_pid:2; /* per-process procfs hidepid=3D */
>  #if !defined(TIF_RESTORE_SIGMASK)
>         unsigned restore_sigmask:1;
>  #endif
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..ada62b6 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,8 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER          3
>  # define PR_CAP_AMBIENT_CLEAR_ALL      4
>
> +/* Per process, non-revokable procfs hidepid=3D option */
> +#define PR_SET_HIDEPID 48
> +#define PR_GET_HIDEPID 49
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 623259f..d4fe951 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1562,6 +1562,7 @@ static __latent_entropy struct task_struct *copy_pr=
ocess(
>  #endif
>
>         p->default_timer_slack_ns =3D current->timer_slack_ns;
> +       p->hide_pid =3D current->hide_pid;
>
>         task_io_accounting_init(&p->ioac);
>         acct_clear_integrals(p);
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 89d5be4..c0a1d3e 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2270,6 +2270,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long,=
 arg2, unsigned long, arg3,
>         case PR_GET_FP_MODE:
>                 error =3D GET_FP_MODE(me);
>                 break;
> +       case PR_SET_HIDEPID:
> +               if (arg2 < HIDEPID_OFF || arg2 > HIDEPID_INVISIBLE)
> +                       return -EINVAL;
> +               if (arg2 < me->hide_pid)
> +                       return -EPERM;
> +               me->hide_pid =3D arg2;
> +               break;
> +       case PR_GET_HIDEPID:
> +               error =3D put_user((int) me->hide_pid, (int __user *)arg2=
);
> +               break;
>         default:
>                 error =3D -EINVAL;
>                 break;
> --
> 2.7.4
>

Since this adds a new prctl interface, it's best to Cc linux-arch
(which I added now).

Thanks for proposing this!

-Kees

--=20
Kees Cook
Nexus Security
