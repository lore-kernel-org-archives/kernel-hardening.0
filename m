Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 30 Jun 2012 10:14:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20120630091422.GE14083@ZenIV.linux.org.uk>
References: <1340658327-2932-1-git-send-email-keescook@chromium.org>
 <1340658327-2932-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340658327-2932-2-git-send-email-keescook@chromium.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 1/2] fs: add link restrictions
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Eric Paris <eparis@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Doug Ledford <dledford@redhat.com>, Joe Korty <joe.korty@ccur.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>, James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 25, 2012 at 02:05:26PM -0700, Kees Cook wrote:

> +config PROTECTED_LINKS
> +	bool "Evaluate vulnerable link conditions"
> +	default y

Remember Linus' rants about 'default y' in general?

> +#ifdef CONFIG_PROTECTED_LINKS
> +int sysctl_protected_symlinks __read_mostly =
> +	CONFIG_PROTECTED_SYMLINKS_SYSCTL;
> +int sysctl_protected_hardlinks __read_mostly =
> +	CONFIG_PROTECTED_HARDLINKS_SYSCTL;
> +
> +/**
> + * may_follow_link - Check symlink following for unsafe situations
> + * @link: The path of the symlink
> + *
> + * In the case of the sysctl_protected_symlinks sysctl being enabled,
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
> +static inline int may_follow_link(struct path *link)
> +{
> +	int error = 0;
> +	const struct inode *parent;
> +	const struct inode *inode;
> +	const struct cred *cred;
> +	struct dentry *dentry;
> +
> +	if (!sysctl_protected_symlinks)
> +		return 0;

Um.  What this says to me is "this function should be outside of ifdef, with
#else of that ifdef defining sysctl_protected_symlinks to 0".

> +	/* Check parent directory mode and owner. */

I suspect that we ought to simply pass that parent directory as argument - caller
*does* have a reference to it, so we don't need to mess with ->d_lock, etc.

> +	mode_t mode = inode->i_mode;

umode_t, please.

> +static int may_linkat(struct path *link)
> +{
> +	const struct cred *cred;
> +	struct inode *inode;
> +
> +	if (!sysctl_protected_hardlinks)
> +		return 0;

Ditto about taking it outside of ifdef.

> +			err = may_follow_link(&link);
> +			if (unlikely(err))
> +				break;

No.  This is definitely wrong - you are leaking dentries and vfsmount here.
> +		error = may_follow_link(&link);
> +		if (unlikely(error))
> +			break;

Ditto.
