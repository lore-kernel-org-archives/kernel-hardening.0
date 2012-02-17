Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Feb 2012 15:24:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120217152432.112fdace.akpm@linux-foundation.org>
In-Reply-To: <20120107185548.GA30748@outflux.net>
References: <20120107185548.GA30748@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 7 Jan 2012 10:55:48 -0800
Kees Cook <keescook@chromium.org> wrote:

> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user). For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
> 
> The solution is to permit symlinks to only be followed when outside
> a sticky world-writable directory, or when the uid of the symlink and
> follower match, or when the directory owner matches the symlink's owner.
> 
> Some pointers to the history of earlier discussion that I could find:
> 
>  1996 Aug, Zygo Blaxell
>   http://marc.info/?l=bugtraq&m=87602167419830&w=2
>  1996 Oct, Andrew Tridgell
>   http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
>  1997 Dec, Albert D Cahalan
>   http://lkml.org/lkml/1997/12/16/4
>  2005 Feb, Lorenzo Hern__ndez Garc__a-Hierro
>   http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
>  2010 May, Kees Cook
>   https://lkml.org/lkml/2010/5/30/144
> 
> Past objections and rebuttals could be summarized as:
> 
>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.
>  - Might break unknown applications that use this feature.
>    - Applications that break because of the change are easy to spot and
>      fix. Applications that are vulnerable to symlink ToCToU by not having
>      the change aren't. Additionally, no applications have yet been found
>      that rely on this behavior.
>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>    - True, but applications are not perfect, and new software is written
>      all the time that makes these mistakes; blocking this flaw at the
>      kernel is a single solution to the entire class of vulnerability.
>  - This should live in the core VFS.
>    - This should live in an LSM. (https://lkml.org/lkml/2010/5/31/135)
>  - This should live in an LSM.
>    - This should live in the core VFS. (https://lkml.org/lkml/2010/8/2/188)
> 
> This patch is based on the patch in Openwall and grsecurity, along with
> suggestions from Al Viro. I have added a sysctl to enable the protected
> behavior, documentation, and an audit notification.

Looks reasonable to me.

It's a viropatch.  I shall merge it into 3.4-rc1 if nothing happens to
prevent that.

> ...
>
> +config PROTECTED_STICKY_SYMLINKS
> +	bool "Evaluate vulnerable symlink conditions"
> +	default y
> +	help
> +	  A long-standing class of security issues is the symlink-based
> +	  time-of-check-time-of-use race, most commonly seen in
> +	  world-writable directories like /tmp. The common method of
> +	  exploitation of this flaw is to cross privilege boundaries
> +	  when following a given symlink (i.e. a root process follows
> +	  a malicious symlink belonging to another user).
> +
> +	  Enabling this adds the logic to examine these dangerous symlink
> +	  conditions. Whether or not the dangerous symlink situations are
> +	  allowed is controlled by PROTECTED_STICKY_SYMLINKS_ENABLED.
> +
> +config PROTECTED_STICKY_SYMLINKS_ENABLED
> +	depends on PROTECTED_STICKY_SYMLINKS
> +	bool "Disallow symlink following in sticky world-writable dirs"
> +	default y
> +	help
> +	  Solve ToCToU symlink race vulnerablities by permitting symlinks
> +	  to be followed only when outside a sticky world-writable directory,
> +	  or when the uid of the symlink and follower match, or when the
> +	  directory and symlink owners match.
> +
> +	  When PROC_SYSCTL is enabled, this setting can also be controlled
> +	  via /proc/sys/kernel/protected_sticky_symlinks.

I think I disagree with this.  If the person compiling the kernel
includes the feature in his kernel via the time-honoured process of
"wtf is that thing?  Yeah, whatev", it gets turned on by default.  This
could easily result in weird failures which would take a *long* time
for an unsuspecting person to debug.

Would it not be kinder to our users to start this out as
turned-off-at-runtime unless the kernel configurer has deliberately
gone in and enabled it?

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
>  #ifdef CONFIG_BLOCK
>  extern int blk_iopoll_enabled;
>  #endif
> +#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
> +extern int sysctl_protected_sticky_symlinks;
> +#endif
>  

Grumble.  Yes, it's a site of much badness.  Let's not worsen things.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-symlink-restrictions-on-sticky-directories-fix

move sysctl_protected_sticky_symlinks declaration into .h

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

--- a/kernel/sysctl.c~fs-symlink-restrictions-on-sticky-directories-fix
+++ a/kernel/sysctl.c
@@ -109,9 +109,6 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
-#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
-extern int sysctl_protected_sticky_symlinks;
-#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
--- a/include/linux/fs.h~fs-symlink-restrictions-on-sticky-directories-fix
+++ a/include/linux/fs.h
@@ -422,6 +422,7 @@ extern unsigned long get_max_files(void)
 extern int sysctl_nr_open;
 extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
+extern int sysctl_protected_sticky_symlinks;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
_
