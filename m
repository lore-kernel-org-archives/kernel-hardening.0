Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2012 01:21:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20120106012120.32c3f370.akpm@linux-foundation.org>
In-Reply-To: <20120106073635.GC14188@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
	<20120105091704.GB3249@elte.hu>
	<CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
	<20120106073635.GC14188@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Ingo Molnar <mingo@elte.hu>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 6 Jan 2012 08:36:35 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Kees Cook <keescook@chromium.org> wrote:
> 
> > On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > > * Kees Cook <keescook@chromium.org> wrote:
> > >
> > >> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
> > >>  #endif
> > >>  #endif
> > >>       {
> > >> +             .procname       = "protected_sticky_symlinks",
> > >> +             .data           = &protected_sticky_symlinks,
> > >> +             .maxlen         = sizeof(int),
> > >> +             .mode           = 0644,
> > >> +             .proc_handler   = proc_dointvec_minmax,
> > >> +             .extra1         = &zero,
> > >> +             .extra2         = &one,
> > >> +     },
> > >
> > > Small detail:
> > >
> > > Might make sense to change the .mode to 0600, to make it 
> > > harder for unprivileged attack code to guess whether this 
> > > protection (and the resulting audit warning to the 
> > > administrator) is enabled on a system or not.
> > 
> > Sure, I have no problem with that. In addition to this change, 
> > what's the best next step for this patch?
> 
> Al and Linus's call I guess. Maybe ask Andrew whether he'd put 
> it into -mm?

Sure, I can babysit it for Viro and get it a bit of testing meanwhile.

However, you've now made me go and look at it...


On Wed, 4 Jan 2012 12:18:00 -0800 Kees Cook <keescook@chromium.org> wrote:

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
>
> ...
>
> +config PROTECTED_STICKY_SYMLINKS
> +	bool "Protect symlink following in sticky world-writable directories"
> +	default y
> +	help
> +	  A long-standing class of security issues is the symlink-based
> +	  time-of-check-time-of-use race, most commonly seen in
> +	  world-writable directories like /tmp. The common method of
> +	  exploitation of this flaw is to cross privilege boundaries
> +	  when following a given symlink (i.e. a root process follows
> +	  a malicious symlink belonging to another user).
> +
> +	  Enabling this solves the problem by permitting symlinks to be
> +	  followed only when outside a sticky world-writable directory,
> +	  or when the uid of the symlink and follower match, or when
> +	  the directory and symlink owners match.

This is all quite misleading.  One would expect that
CONFIG_PROTECTED_STICKY_SYMLINKS turns the entire feature on or off
permanently.  ie, it controls whether the code is generated into
vmlinux in the usual fashion.  But it's not that at all - the user
gets the feature whether or not he wants it, and this variable only
sets the initial value.

Why are we forcing the user to have the feature if he doesn't want it,
btw?

And we appear to be enabling the feature if CONFIG_PROC_FS=n, which
might not be terribly useful?

> diff --git a/fs/namei.c b/fs/namei.c
> index 5008f01..b826d2e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -624,10 +624,80 @@ static inline void put_link(struct nameidata *nd, struct path *link, void *cooki
>  	path_put(link);
>  }
>  
> +int protected_sticky_symlinks  read_mostly =

A nice convention is to prefix these globals with sysctl_.

	grep ".data.*&sysctl_" kernel/sysctl.c

has examples.

> +#ifdef CONFIG_PROTECTED_STICKY_SYMLINKS
> +				1;
> +#else
> +				0;
> +#endif

I have this niggling feeling that there's a trick to avoid this ugly,
and that Matt Mackall was involved.  But I think I misremember.  Maybe
the trick is to ensure (within Kconfig) that CONFIG_foo is always
defined, to either 0 or 1.  Still.  Ugly :)

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
> + * It will permit symlinks to be followed only when outside a sticky
> + * world-writable directory, or when the uid of the symlink and follower
> + * match, or when the directory owner matches the symlink's owner.
> + *
> + * Returns 0 if following the symlink is allowed, -ve on error.
> + */
> +static inline int
> +may_follow_link(struct dentry *dentry, struct nameidata *nameidata)

Setting aside the issue that gcc will cheerily ignore the inline
directive, is it prudent to inline this?  Doing so will pork up the
follow_link() cache footprint.  Perhaps it should actually be noinline?

> +{
> +	int error = 0;
> +	const struct inode *parent;
> +	const struct inode *inode;
> +	const struct cred *cred;
> +
> +	if (!protected_sticky_symlinks)
> +		return 0;
> +
> +	/* Allowed if owner and follower match. */
> +	cred = current_cred();
> +	inode = dentry->d_inode;
> +	if (cred->fsuid == inode->i_uid)
> +		return 0;
> +
> +	/* Check parent directory mode and owner. */
> +	spin_lock(&dentry->d_lock);
> +	parent = dentry->d_parent->d_inode;
> +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +	    parent->i_uid != inode->i_uid) {
> +		error = -EACCES;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +
> +#ifdef CONFIG_AUDIT
> +	if (error) {
> +		struct audit_buffer *ab;
> +
> +		ab = audit_log_start(current->audit_context,
> +				     GFP_KERNEL, AUDIT_AVC);
> +		audit_log_format(ab, "op=follow_link action=denied");
> +		audit_log_format(ab, " pid=%d comm=", current->pid);

The same pid can exist in multiple namespaces.  Now whatcha gonna do?

> +		audit_log_untrustedstring(ab, current->comm);
> +		audit_log_d_path(ab, "path=", &nameidata->path);
> +		audit_log_format(ab, " name=");
> +		audit_log_untrustedstring(ab, dentry->d_name.name);
> +		audit_log_format(ab, " dev=%s ino=%lu",
> +				 inode->i_sb->s_id,

Can s_id contain characters which audit_log_untrustedstring() would
have escaped?  I suspect so.

> +				 inode->i_ino);
> +		audit_log_end(ab);
> +	}
> +#endif
> +	return error;
> +}
> +
>  static  always_inline int
> -follow_link(struct path *link, struct nameidata *nd, void **p)
> +follow_link(struct path *link, struct nameidata *nd, void **p, bool sensitive)
>  {
> -	int error;
> +	int error = 0;
>  	struct dentry *dentry = link->dentry;
>  
>  	BUG_ON(nd->flags & LOOKUP_RCU);
> @@ -646,7 +716,10 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
>  	touch_atime(link->mnt, dentry);
>  	nd_set_link(nd, NULL);
>  
> -	error = security_inode_follow_link(link->dentry, nd);
> +	if (sensitive)
> +		error = may_follow_link(link->dentry, nd);
> +	if (!error)
> +		error = security_inode_follow_link(link->dentry, nd);
>  	if (error) {
>  		*p = ERR_PTR(error); /* no ->put_link(), please */
>  		path_put(&nd->path);
> @@ -1339,7 +1412,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
>  		struct path link = *path;
>  		void *cookie;
>  
> -		res = follow_link(&link, nd, &cookie);
> +		res = follow_link(&link, nd, &cookie, 0);

follow_link() takes a bool, so this 0 should anally be "false". 
Multiple instances of this.

>  		if (!res)
>  			res = walk_component(nd, path, &nd->last,
>  					     nd->last_type, LOOKUP_FOLLOW);
> @@ -1612,7 +1685,8 @@ static int path_lookupat(int dfd, const char *name,
>  			void *cookie;
>  			struct path link = path;
>  			nd->flags |= LOOKUP_PARENT;
> -			err = follow_link(&link, nd, &cookie);
> +
> +			err = follow_link(&link, nd, &cookie, 1);
>  			if (!err)
>  				err = lookup_last(nd, &path);
>  			put_link(nd, &link, cookie);
>
> ...
>
