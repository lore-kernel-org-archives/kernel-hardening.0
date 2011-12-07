Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4EDFAECF.9010407@xenotime.net>
Date: Wed, 07 Dec 2011 10:22:07 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
References: <20111206235815.GA21764@www.outflux.net>
In-Reply-To: <20111206235815.GA21764@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2011.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/06/2011 03:58 PM, Kees Cook wrote:
>  Documentation/sysctl/fs.txt |   21 ++++++++++++
>  fs/Kconfig                  |   15 ++++++++
>  fs/namei.c                  |   77 +++++++++++++++++++++++++++++++++++++++---
>  kernel/sysctl.c             |   10 +++++
>  4 files changed, 117 insertions(+), 6 deletions(-)


> diff --git a/fs/Kconfig b/fs/Kconfig
> index 5f4c45d..74b9e49 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -278,3 +278,18 @@ source "fs/nls/Kconfig"
>  source "fs/dlm/Kconfig"
>  
>  endmenu
> +
> +config PROTECTED_STICKY_SYMLINKS
> +	bool "Protect symlink following in sticky world-writable directories"
> +	help
> +	  A long-standing class of security issues is the symlink-based
> +	  time-of-check-time-of-use race, most commonly seen in
> +	  world-writable directories like /tmp. The common method of
> +	  exploitation of this flaw is to cross privilege boundaries
> +	  when following a given symlink (i.e. a root process follows
> +	  a malicious symlink belonging to another user).
> +
> +	  Enabling this solves the problem by permitting symlinks to only

better:

	  Enabling this solves the problem by permitting symlinks to be followed
	  only when the uid ...

> +	  be followed when outside a sticky world-writable directory,
> +	  or when the uid of the symlink and follower match, or when
> +	  the directory and symlink owners match.
> diff --git a/fs/namei.c b/fs/namei.c
> index 5008f01..c4d0bfc 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -624,10 +625,69 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
> +
> +/**
> + * may_follow_link - Check symlink following for unsafe situations
> + * @dentry: The inode/dentry of the symlink
> + * @nameidata: The path data of the symlink
> + *
> + * In the case of the protected_sticky_symlinks sysctl being enabled,
> + * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
> + * in a sticky world-writable directory. This is to protect privileged
> + * processes from failing races against path names that may change out
> + * from under them by way of other users creating malicious symlinks.
> + * It will permit symlinks to only be followed when outside a sticky

similar:

      It will permit symlinks to be followed only when outside a sticky

> + * world-writable directory, or when the uid of the symlink and follower
> + * match, or when the directory owner matches the symlink's owner.
> + *
> + * Returns 0 if following the symlink is allowed, -ve on error.
> + */
> +static inline int
> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
