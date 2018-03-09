From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [lustre-devel] [PATCH v2] staging: lustre: Remove VLA usage
Date: Fri, 9 Mar 2018 08:54:29 +0000
Message-ID: <D86B331F-466E-4395-9620-A84349F2DD2E@intel.com>
References: <20180307205444.GA11349@beast>
In-Reply-To: <20180307205444.GA11349@beast>
Content-Type: text/plain; charset="us-ascii"
Content-ID: <256AED917176C643BB96F1916F39FFBC@intel.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, Tycho Andersen <tycho@tycho.ws>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Gargi Sharma <gs051095@gmail.com>, "Drokin,
 Oleg" <oleg.drokin@intel.com>, Lustre Development List <lustre-devel@lists.lustre.org>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

On Mar 7, 2018, at 13:54, Kees Cook <keescook@chromium.org> wrote:
>=20
> The kernel would like to have all stack VLA usage removed[1]. This switch=
es
> to a simple kasprintf() instead, and in the process fixes an off-by-one
> between the allocation and the sprintf (allocation did not include NULL
> byte in calculation).
>=20
> [1] https://lkml.org/lkml/2018/3/7/621
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

This seems better than the VLA_SAFE() macro, at the cost of an extra kmallo=
c.
I don't think these code paths are super performance critical.

Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

> ---
> drivers/staging/lustre/lustre/llite/xattr.c | 19 +++++++++++++------
> 1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/stagin=
g/lustre/lustre/llite/xattr.c
> index 532384c91447..ff6fe81a4ddb 100644
> --- a/drivers/staging/lustre/lustre/llite/xattr.c
> +++ b/drivers/staging/lustre/lustre/llite/xattr.c
> @@ -87,10 +87,10 @@ ll_xattr_set_common(const struct xattr_handler *handl=
er,
> 		    const char *name, const void *value, size_t size,
> 		    int flags)
> {
> -	char fullname[strlen(handler->prefix) + strlen(name) + 1];
> 	struct ll_sb_info *sbi =3D ll_i2sbi(inode);
> 	struct ptlrpc_request *req =3D NULL;
> 	const char *pv =3D value;
> +	char *fullname;
> 	__u64 valid;
> 	int rc;
>=20
> @@ -141,10 +141,13 @@ ll_xattr_set_common(const struct xattr_handler *han=
dler,
> 			return -EPERM;
> 	}
>=20
> -	sprintf(fullname, "%s%s\n", handler->prefix, name);
> +	fullname =3D kasprintf(GFP_KERNEL, "%s%s\n", handler->prefix, name);
> +	if (!fullname)
> +		return -ENOMEM;
> 	rc =3D md_setxattr(sbi->ll_md_exp, ll_inode2fid(inode),
> 			 valid, fullname, pv, size, 0, flags,
> 			 ll_i2suppgid(inode), &req);
> +	kfree(fullname);
> 	if (rc) {
> 		if (rc =3D=3D -EOPNOTSUPP && handler->flags =3D=3D XATTR_USER_T) {
> 			LCONSOLE_INFO("Disabling user_xattr feature because it is not supporte=
d on the server\n");
> @@ -364,11 +367,11 @@ static int ll_xattr_get_common(const struct xattr_h=
andler *handler,
> 			       struct dentry *dentry, struct inode *inode,
> 			       const char *name, void *buffer, size_t size)
> {
> -	char fullname[strlen(handler->prefix) + strlen(name) + 1];
> 	struct ll_sb_info *sbi =3D ll_i2sbi(inode);
> #ifdef CONFIG_FS_POSIX_ACL
> 	struct ll_inode_info *lli =3D ll_i2info(inode);
> #endif
> +	char *fullname;
> 	int rc;
>=20
> 	CDEBUG(D_VFSTRACE, "VFS Op:inode=3D" DFID "(%p)\n",
> @@ -411,9 +414,13 @@ static int ll_xattr_get_common(const struct xattr_ha=
ndler *handler,
> 	if (handler->flags =3D=3D XATTR_ACL_DEFAULT_T && !S_ISDIR(inode->i_mode)=
)
> 		return -ENODATA;
> #endif
> -	sprintf(fullname, "%s%s\n", handler->prefix, name);
> -	return ll_xattr_list(inode, fullname, handler->flags, buffer, size,
> -			     OBD_MD_FLXATTR);
> +	fullname =3D kasprintf(GFP_KERNEL, "%s%s\n", handler->prefix, name);
> +	if (!fullname)
> +		return -ENOMEM;
> +	rc =3D ll_xattr_list(inode, fullname, handler->flags, buffer, size,
> +			   OBD_MD_FLXATTR);
> +	kfree(fullname);
> +	return rc;
> }
>=20
> static ssize_t ll_getxattr_lov(struct inode *inode, void *buf, size_t buf=
_size)
> --=20
> 2.7.4
>=20
>=20
> --=20
> Kees Cook
> Pixel Security
> _______________________________________________
> lustre-devel mailing list
> lustre-devel@lists.lustre.org
> http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org

Cheers, Andreas
--
Andreas Dilger
Lustre Principal Architect
Intel Corporation
