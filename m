Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 15 Dec 2011 07:48:17 +0100
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20111215064817.GB14237@elte.hu>
References: <20111215004311.GA11049@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215004311.GA11049@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH v2011.2] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

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
> +				     GFP_ATOMIC, AUDIT_AVC);
> +		audit_log_format(ab, "op=follow_link action=denied");
> +		audit_log_d_path(ab, "path=", &nameidata->path);
> +		audit_log_format(ab, " name=");
> +		audit_log_untrustedstring(ab, dentry->d_name.name);
> +		audit_log_format(ab, " dev=%s ino=%lu",
> +				 inode->i_sb->s_id,
> +				 inode->i_ino);
> +		audit_log_end(ab);
> +	}
> +#endif

Hm, is GFP_ATOMIC really necessary here? Why not GFP_KERNEL? 
This is in VFS process context, not in some atomic context that 
has to be careful about allocations, right?

Thanks,

	Ingo
