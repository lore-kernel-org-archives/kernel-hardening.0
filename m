Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <52553A8D.4090906@gmail.com>
Date: Wed, 09 Oct 2013 07:14:21 -0400
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
MIME-Version: 1.0
References: <5254A034.5020700@gmail.com>	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>	 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722> <5254BDD0.7040001@gmail.com>
In-Reply-To: <5254BDD0.7040001@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v2] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/08/2013 10:22 PM, Ryan Mallon wrote:
> Ah, I misread it. It does however check when kptr_restrict !=3D 0, not
> just when kptr_restrict is 1. I've left the in_irq test as-is, but used=

> a switch as suggested. I don't really care either way, I think the
> original check is quite readable. Anyway, updated patch below:
>
> ~Ryan

This seems mostly fine to me, except the "proccess" -> "process" nit Joe
already identified.

I think I also prefer Joe's style of having an explicit "case 2" in the
switch statement in addition to the default case for clarity.

Also, isn't the default value of kptr_restrict 0 now, unless I'm missing
something? If I recall it was 1 when originally written, and then
changed to 0 at some point. Could the documentation be updated to
reflect that?

-Dan

> ---
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/ker=
nel.txt
> index 9d4c1d1..eac53d5 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -290,13 +290,15 @@ Default value is "/sbin/hotplug".
>  kptr_restrict:
> =20
>  This toggle indicates whether restrictions are placed on
> -exposing kernel addresses via /proc and other interfaces.  When
> -kptr_restrict is set to (0), there are no restrictions.  When
> -kptr_restrict is set to (1), the default, kernel pointers
> +exposing kernel addresses via /proc and other interfaces.
> +
> +When kptr_restrict is set to (0), there are no restrictions.
> +When kptr_restrict is set to (1), the default, kernel pointers
>  printed using the %pK format specifier will be replaced with 0's
> -unless the user has CAP_SYSLOG.  When kptr_restrict is set to
> -(2), kernel pointers printed using %pK will be replaced with 0's
> -regardless of privileges.
> +unless the user has CAP_SYSLOG and effective user and group ids
> +are equal to the real ids.
> +When kptr_restrict is set to (2), kernel pointers printed using
> +%pK will be replaced with 0's regardless of privileges.
> =20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 26559bd..6dd8c5d 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -27,6 +27,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/ioport.h>
>  #include <linux/dcache.h>
> +#include <linux/cred.h>
>  #include <net/addrconf.h>
> =20
>  #include <asm/page.h>		/* for PAGE_SIZE */
> @@ -1312,11 +1313,36 @@ char *pointer(const char *fmt, char *buf, char =
*end, void *ptr,
>  				spec.field_width =3D default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
> -		if (!((kptr_restrict =3D=3D 0) ||
> -		      (kptr_restrict =3D=3D 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +
> +		switch (kptr_restrict) {
> +		case 0:
> +			/* Always print %pK values */
> +			break;
> +		case 1: {
> +			/*
> +			 * Only print the real pointer value if the current
> +			 * proccess has CAP_SYSLOG and is running with the
> +			 * same credentials it started with. This is because
> +			 * access to files is checked at open() time, but %pK
> +			 * checks permission at read() time. We don't want to
> +			 * leak pointer values if a binary opens a file using
> +			 * %pK and then elevates privileges before reading it.
> +			 */
> +			const struct cred *cred =3D current_cred();
> +
> +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			    !uid_eq(cred->euid, cred->uid) ||
> +			    !gid_eq(cred->egid, cred->gid))
> +				ptr =3D NULL;
> +			break;
> +		}
> +		default:
> +			/* Always print 0's for %pK */
>  			ptr =3D NULL;
> +			break;
> +		}
>  		break;
> +
>  	case 'N':
>  		switch (fmt[1]) {
>  		case 'F':
>
>
>
>
>
