Date: Wed, 7 Mar 2018 21:02:05 +1100
From: "Tobin C. Harding" <tobin@apporbit.com>
Subject: Re: [PATCH] staging: lustre: Remove VLA usage
Message-ID: <20180307100205.GF11750@eros>
References: <20180307054608.GA9300@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307054608.GA9300@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Dmitry Eremin <dmitry.eremin@intel.com>, Gargi Sharma <gs051095@gmail.com>, lustre-devel@lists.lustre.org, devel@driverdev.osuosl.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 06, 2018 at 09:46:08PM -0800, Kees Cook wrote:
> The kernel would like to remove all VLA usage. This switches to a
> simple kasprintf() instead.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/staging/lustre/lustre/llite/xattr.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
> index 532384c91447..aab4eab64289 100644
> --- a/drivers/staging/lustre/lustre/llite/xattr.c
> +++ b/drivers/staging/lustre/lustre/llite/xattr.c
> @@ -87,7 +87,7 @@ ll_xattr_set_common(const struct xattr_handler *handler,
>  		    const char *name, const void *value, size_t size,
>  		    int flags)
>  {
> -	char fullname[strlen(handler->prefix) + strlen(name) + 1];
> +	char *fullname;
>  	struct ll_sb_info *sbi = ll_i2sbi(inode);
>  	struct ptlrpc_request *req = NULL;
>  	const char *pv = value;
> @@ -141,10 +141,13 @@ ll_xattr_set_common(const struct xattr_handler *handler,
>  			return -EPERM;
>  	}
>  
> -	sprintf(fullname, "%s%s\n", handler->prefix, name);
> +	fullname = kasprintf(GFP_KERNEL, "%s%s\n", handler->prefix, name);
> +	if (!fullname)
> +		return -ENOMEM;
>  	rc = md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode),
>  			 valid, fullname, pv, size, 0, flags,
>  			 ll_i2suppgid(inode), &req);
> +	kfree(fullname);

This is cool.  We've had kasprintf() since 2007, who knew?!

thanks,
Tobin.
