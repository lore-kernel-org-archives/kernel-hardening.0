Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Feb 2012 21:56:26 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <20120218205626.GA26880@joi.lan>
References: <20120218193857.GA30985@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120218193857.GA30985@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] fs: hardlink creation restrictions
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 18, 2012 at 11:38:57AM -0800, Kees Cook wrote:
> @@ -3052,6 +3119,9 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
>  	error = mnt_want_write(new_path.mnt);
>  	if (error)
>  		goto out_dput;
> +	error = may_linkat(&old_path);
> +	if (error)
> +		goto out_dput;
>  	error = security_path_link(old_path.dentry, &new_path, new_dentry);
>  	if (error)
>  		goto out_drop_write;

You should give up write access after check failure (i.e. goto out_drop_write).

Marcin
