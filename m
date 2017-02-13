MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1484572984-13388-2-git-send-email-djalal@gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com> <1484572984-13388-2-git-send-email-djalal@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 14:16:30 -0800
Message-ID: <CAGXu5jLKqKso-FGDfr=2_xu+k15Lz-T9CgT_4ZvEEeZ9G1+LzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v4 1/2] procfs: use an enum for possible hidepid values
To: Djalal Harouni <tixxdz@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Lafcadio Wluiki <wluikil@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 5:23 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> From: Lafcadio Wluiki <wluikil@gmail.com>
>
> Previously, the hidepid parameter was checked by comparing literal
> integers 0, 1, 2. Let's add a proper enum for this, to make the checking
> more expressive:
>
>         0 =E2=86=92 HIDEPID_OFF
>         1 =E2=86=92 HIDEPID_NO_ACCESS
>         2 =E2=86=92 HIDEPID_INVISIBLE
>
> This changes the internal labelling only, the userspace-facing interface
> remains unmodified, and still works with literal integers 0, 1, 2.
>
> No functional changes.
>
> Acked-by: Kees Cook <keescook@chromium.org>
> Acked-by: Djalal Harouni <tixxdz@gmail.com>
> Signed-off-by: Lafcadio Wluiki <wluikil@gmail.com>

Andrew, can you take this? It's a sensible cleanup to drop literals in
favor of defines.

-Kees

> ---
>  fs/proc/base.c                | 8 ++++----
>  fs/proc/inode.c               | 2 +-
>  fs/proc/root.c                | 3 ++-
>  include/linux/pid_namespace.h | 6 ++++++
>  4 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8e7e61b..cd8dd15 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -729,11 +729,11 @@ static int proc_pid_permission(struct inode *inode,=
 int mask)
>         task =3D get_proc_task(inode);
>         if (!task)
>                 return -ESRCH;
> -       has_perms =3D has_pid_permissions(pid, task, 1);
> +       has_perms =3D has_pid_permissions(pid, task, HIDEPID_NO_ACCESS);
>         put_task_struct(task);
>
>         if (!has_perms) {
> -               if (pid->hide_pid =3D=3D 2) {
> +               if (pid->hide_pid =3D=3D HIDEPID_INVISIBLE) {
>                         /*
>                          * Let's make getdents(), stat(), and open()
>                          * consistent with each other.  If a process
> @@ -1725,7 +1725,7 @@ int pid_getattr(struct vfsmount *mnt, struct dentry=
 *dentry, struct kstat *stat)
>         stat->gid =3D GLOBAL_ROOT_GID;
>         task =3D pid_task(proc_pid(inode), PIDTYPE_PID);
>         if (task) {
> -               if (!has_pid_permissions(pid, task, 2)) {
> +               if (!has_pid_permissions(pid, task, HIDEPID_INVISIBLE)) {
>                         rcu_read_unlock();
>                         /*
>                          * This doesn't prevent learning whether PID exis=
ts,
> @@ -3179,7 +3179,7 @@ int proc_pid_readdir(struct file *file, struct dir_=
context *ctx)
>              iter.tgid +=3D 1, iter =3D next_tgid(ns, iter)) {
>                 char name[PROC_NUMBUF];
>                 int len;
> -               if (!has_pid_permissions(ns, iter.task, 2))
> +               if (!has_pid_permissions(ns, iter.task, HIDEPID_INVISIBLE=
))
>                         continue;
>
>                 len =3D snprintf(name, sizeof(name), "%d", iter.tgid);
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 842a5ff..5d9bafb 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -106,7 +106,7 @@ static int proc_show_options(struct seq_file *seq, st=
ruct dentry *root)
>
>         if (!gid_eq(pid->pid_gid, GLOBAL_ROOT_GID))
>                 seq_printf(seq, ",gid=3D%u", from_kgid_munged(&init_user_=
ns, pid->pid_gid));
> -       if (pid->hide_pid !=3D 0)
> +       if (pid->hide_pid !=3D HIDEPID_OFF)
>                 seq_printf(seq, ",hidepid=3D%u", pid->hide_pid);
>
>         return 0;
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 1988440..b90da88 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -58,7 +58,8 @@ int proc_parse_options(char *options, struct pid_namesp=
ace *pid)
>                 case Opt_hidepid:
>                         if (match_int(&args[0], &option))
>                                 return 0;
> -                       if (option < 0 || option > 2) {
> +                       if (option < HIDEPID_OFF ||
> +                           option > HIDEPID_INVISIBLE) {
>                                 pr_err("proc: hidepid value must be betwe=
en 0 and 2.\n");
>                                 return 0;
>                         }
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.=
h
> index 34cce96..c2a989d 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -21,6 +21,12 @@ struct pidmap {
>
>  struct fs_pin;
>
> +enum { /* definitions for pid_namespace's hide_pid field */
> +       HIDEPID_OFF       =3D 0,
> +       HIDEPID_NO_ACCESS =3D 1,
> +       HIDEPID_INVISIBLE =3D 2,
> +};
> +
>  struct pid_namespace {
>         struct kref kref;
>         struct pidmap pidmap[PIDMAP_ENTRIES];
> --
> 2.5.5
>



--=20
Kees Cook
Pixel Security
