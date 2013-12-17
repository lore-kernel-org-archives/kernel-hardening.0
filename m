Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1387133834-31966-2-git-send-email-tixxdz@opendz.org>
References: <1387133834-31966-1-git-send-email-tixxdz@opendz.org> <1387133834-31966-2-git-send-email-tixxdz@opendz.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Dec 2013 17:49:53 -0800
Message-ID: <CALCETrUmYxrd0nU+9oZvgJf7Lp0QgSXM3vRfoWshHYb1v_Sc9g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: make /proc/*/{stack,syscall,personality} 0400
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 15, 2013 at 10:57 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> These procfs files contain sensitive information and currently their
> mode is 0444. Change this to 0400, so the VFS will be able to block
> unprivileged processes from getting file descriptors on arbitrary
> privileged /proc/*/{stack,syscall,personality} files.

Looks good.  It's hard to imagine this breaking anything that deserves to work.

Acked-by: Andy Lutomirski <luto@amacapital.net>

>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Acked-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 5150706..e69df4b 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2587,7 +2587,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>         REG("environ",    S_IRUSR, proc_environ_operations),
>         INF("auxv",       S_IRUSR, proc_pid_auxv),
>         ONE("status",     S_IRUGO, proc_pid_status),
> -       ONE("personality", S_IRUGO, proc_pid_personality),
> +       ONE("personality", S_IRUSR, proc_pid_personality),
>         INF("limits",     S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>         REG("sched",      S_IRUGO|S_IWUSR, proc_pid_sched_operations),
> @@ -2597,7 +2597,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #endif
>         REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> -       INF("syscall",    S_IRUGO, proc_pid_syscall),
> +       INF("syscall",    S_IRUSR, proc_pid_syscall),
>  #endif
>         INF("cmdline",    S_IRUGO, proc_pid_cmdline),
>         ONE("stat",       S_IRUGO, proc_tgid_stat),
> @@ -2625,7 +2625,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>         INF("wchan",      S_IRUGO, proc_pid_wchan),
>  #endif
>  #ifdef CONFIG_STACKTRACE
> -       ONE("stack",      S_IRUGO, proc_pid_stack),
> +       ONE("stack",      S_IRUSR, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>         INF("schedstat",  S_IRUGO, proc_pid_schedstat),
> @@ -2926,14 +2926,14 @@ static const struct pid_entry tid_base_stuff[] = {
>         REG("environ",   S_IRUSR, proc_environ_operations),
>         INF("auxv",      S_IRUSR, proc_pid_auxv),
>         ONE("status",    S_IRUGO, proc_pid_status),
> -       ONE("personality", S_IRUGO, proc_pid_personality),
> +       ONE("personality", S_IRUSR, proc_pid_personality),
>         INF("limits",    S_IRUGO, proc_pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>         REG("sched",     S_IRUGO|S_IWUSR, proc_pid_sched_operations),
>  #endif
>         REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
>  #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> -       INF("syscall",   S_IRUGO, proc_pid_syscall),
> +       INF("syscall",   S_IRUSR, proc_pid_syscall),
>  #endif
>         INF("cmdline",   S_IRUGO, proc_pid_cmdline),
>         ONE("stat",      S_IRUGO, proc_tid_stat),
> @@ -2963,7 +2963,7 @@ static const struct pid_entry tid_base_stuff[] = {
>         INF("wchan",     S_IRUGO, proc_pid_wchan),
>  #endif
>  #ifdef CONFIG_STACKTRACE
> -       ONE("stack",      S_IRUGO, proc_pid_stack),
> +       ONE("stack",      S_IRUSR, proc_pid_stack),
>  #endif
>  #ifdef CONFIG_SCHEDSTATS
>         INF("schedstat", S_IRUGO, proc_pid_schedstat),
> --
> 1.7.11.7
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
