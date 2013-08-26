Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<1377534240-13227-2-git-send-email-tixxdz@opendz.org>
Date: Mon, 26 Aug 2013 09:50:42 -0700
In-Reply-To: <1377534240-13227-2-git-send-email-tixxdz@opendz.org> (Djalal
	Harouni's message of "Mon, 26 Aug 2013 17:24:00 +0100")
Message-ID: <87wqn8pfa5.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 2/2] procfs: restore 0400 permissions on /proc/*/pagemap
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Djalal Harouni <tixxdz@opendz.org> writes:

> Do not give an fd on privileged /proc/*/pagemap files for free.

The same objections apply to this patch as it's predecessor so I won't
repeat them.

Eric

> Restore the previous 0400 mode
>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6b162cd..93a1c89 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2605,7 +2605,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",      S_IRUGO, proc_pid_smaps_operations),
> -	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>  	DIR("attr",       S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
> @@ -2943,7 +2943,7 @@ static const struct pid_entry tid_base_stuff[] = {
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  	REG("clear_refs", S_IWUSR, proc_clear_refs_operations),
>  	REG("smaps",     S_IRUGO, proc_tid_smaps_operations),
> -	REG("pagemap",    S_IRUGO, proc_pagemap_operations),
> +	REG("pagemap",    S_IRUSR, proc_pagemap_operations),
>  #endif
>  #ifdef CONFIG_SECURITY
>  	DIR("attr",      S_IRUGO|S_IXUGO, proc_attr_dir_inode_operations, proc_attr_dir_operations),
