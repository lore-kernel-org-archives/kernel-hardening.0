Date: Fri, 24 Nov 2017 09:43:54 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171123224354.GJ12736@eros>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-2-git-send-email-s.mesoraca16@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511337706-8297-2-git-send-email-s.mesoraca16@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v3 1/2] Protected FIFOs and regular
 files
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 22, 2017 at 09:01:45AM +0100, Salvatore Mesoraca wrote:

Please take these comments in all humility, my English is a long way
from perfect. These are English grammar comments only. If this is viewed
as trivial please stop reading now and ignore.

> Disallows open of FIFOs or regular files not owned by the user in world
> writable sticky directories, unless the owner is the same as that of
> the directory or the file is opened without the O_CREAT flag.
> The purpose is to make data spoofing attacks harder.
> This protection can be turned on and off separately for FIFOs and regular
> files via sysctl, just like the symlinks/hardlinks protection.
> This patch is based on Openwall's "HARDEN_FIFO" feature by Solar
> Designer.
> 
> This is a brief list of old vulnerabilities that could have been prevented
> by this feature, some of them even allow for privilege escalation:
> CVE-2000-1134
> CVE-2007-3852
> CVE-2008-0525
> CVE-2009-0416
> CVE-2011-4834
> CVE-2015-1838
> CVE-2015-7442
> CVE-2016-7489
> 
> This list is not meant to be complete. It's difficult to track down
> all vulnerabilities of this kind because they were often reported
> without any mention of this particular attack vector.
> In fact, before symlinks restrictions, fifos/regular files were not the
> favorite vehicle to exploit them.
> 
> Suggested-by: Solar Designer <solar@openwall.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  Documentation/sysctl/fs.txt | 36 ++++++++++++++++++++++++++
>  fs/namei.c                  | 61 ++++++++++++++++++++++++++++++++++++++++++---
>  include/linux/fs.h          |  2 ++
>  kernel/sysctl.c             | 18 +++++++++++++
>  4 files changed, 114 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index 6c00c1e..f3cf2cd 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -34,7 +34,9 @@ Currently, these files are in /proc/sys/fs:
>  - overflowgid
>  - pipe-user-pages-hard
>  - pipe-user-pages-soft
> +- protected_fifos
>  - protected_hardlinks
> +- protected_regular
>  - protected_symlinks
>  - suid_dumpable
>  - super-max
> @@ -182,6 +184,24 @@ applied.
>  
>  ==============================================================
>  
> +protected_fifos:
> +
> +The intent of this protection is to avoid unintentional writes to
> +an attacker-controlled FIFO, where a program expected to create a regular
> +file.
> +
> +When set to "0", FIFOs writing is unrestricted.

 When set to "0", writing to FIFOs is unrestricted.

> +When set to "1" don't allow O_CREAT open on FIFOs that we don't own
> +in world writable sticky directories, unless they are owned by the
> +owner of the directory.
> +
> +When set to "2" it also applies to group writable sticky directories.
> +
> +This protection is based on the restrictions in Openwall.
> +
> +==============================================================
> +
>  protected_hardlinks:
>  
>  A long-standing class of security issues is the hardlink-based
> @@ -202,6 +222,22 @@ This protection is based on the restrictions in Openwall and grsecurity.
>  
>  ==============================================================
>  
> +protected_regular:
> +
> +This protection is similar to protected_fifos, but it
> +avoids writes to an attacker-controlled regular file, where a program
> +expected to create one.
> +
> +When set to "0", regular files writing is unrestricted.

 When set to "0", writing to regular files is unrestricted.

> +When set to "1" don't allow O_CREAT open on regular files that we
> +don't own in world writable sticky directories, unless they are
> +owned by the owner of the directory.
> +
> +When set to "2" it also applies to group writable sticky directories.
> +
> +==============================================================
> +
>  protected_symlinks:
>  
>  A long-standing class of security issues is the symlink-based
> diff --git a/fs/namei.c b/fs/namei.c
> index f0c7a7b..92992ad 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -902,6 +902,8 @@ static inline void put_link(struct nameidata *nd)
>  
>  int sysctl_protected_symlinks __read_mostly = 0;
>  int sysctl_protected_hardlinks __read_mostly = 0;
> +int sysctl_protected_fifos __read_mostly;
> +int sysctl_protected_regular __read_mostly;
>  
>  /**
>   * may_follow_link - Check symlink following for unsafe situations
> @@ -1015,6 +1017,54 @@ static int may_linkat(struct path *link)
>  	return -EPERM;
>  }
>  
> +/**
> + * may_create_in_sticky - Check whether an O_CREAT open in a sticky directory
> + *			  should be allowed or not, when the file already
> + *			  existed.

Perhaps

 + * may_create_in_sticky - Check whether an O_CREAT open, in a sticky directory,
 			 should be allowed, or not, on files that already exist.



Hope this helps,
Tobin.
