Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1387133834-31966-3-git-send-email-tixxdz@opendz.org>
References: <1387133834-31966-1-git-send-email-tixxdz@opendz.org> <1387133834-31966-3-git-send-email-tixxdz@opendz.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Dec 2013 17:52:01 -0800
Message-ID: <CALCETrUPz=v4AeRsOobj9JY+evDbjKib0P32O0NjdvrVQumijw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 2/2] procfs: make /proc/*/pagemap 0400
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 15, 2013 at 10:57 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> The /proc/*/pagemap contain sensitive information and currently its
> mode is 0444. Change this to 0400, so the VFS will prevent unprivileged
> processes from getting file descriptors on arbitrary privileged
> /proc/*/pagemap files.
>

Looks good.

Acked-by: Andy Lutomirski <luto@amacapital.net>

> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index e69df4b..081d055 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2616,7 +2616,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>         REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>         REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
> -       REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +       REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>         DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> @@ -2954,7 +2954,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>         REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>         REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
> -       REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +       REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>         DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> --
> 1.7.11.7
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
