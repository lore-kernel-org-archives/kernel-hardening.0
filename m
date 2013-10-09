Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381356014.2050.28.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Wed, 09 Oct 2013 15:00:14 -0700
In-Reply-To: <5255D023.2030907@gmail.com>
References: <5255D023.2030907@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2013-10-10 at 08:52 +1100, Ryan Mallon wrote:
> Some setuid binaries will allow reading of files which have read
> permission by the real user id. This is problematic with files which
> use %pK because the file access permission is checked at open() time,
> but the kptr_restrict setting is checked at read() time. If a setuid
> binary opens a %pK file as an unprivileged user, and then elevates
> permissions before reading the file, then kernel pointer values may be
> leaked.

Please review the patch I sent you a little more.

> Fix this by adding a check that in addition to the current process
> having CAP_SYSLOG, that effective user and group ids are equal to the
> real ids. If a setuid binary reads the contents of a file which uses
> %pK then the pointer values will be printed as NULL if the real user
> is unprivileged.

[]

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,11 +1313,37 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}

Move the interrupt tests and pK-error printk
into case 1:

It's the only case where CAP_SYSLOG needs to be
tested so it doesn't need to be above the switch.


> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> +
> +		switch (kptr_restrict) {
> +		case 0:
> +			/* Always print %pK values */
> +			break;
> +		case 1: {
> +			/*
> +			 * Only print the real pointer value if the current
> +			 * process has CAP_SYSLOG and is running with the
> +			 * same credentials it started with. This is because
> +			 * access to files is checked at open() time, but %pK
> +			 * checks permission at read() time. We don't want to
> +			 * leak pointer values if a binary opens a file using
> +			 * %pK and then elevates privileges before reading it.
> +			 */
> +			const struct cred *cred = current_cred();
> +
> +			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			    !uid_eq(cred->euid, cred->uid) ||
> +			    !gid_eq(cred->egid, cred->gid))
> +				ptr = NULL;
> +			break;
> +		}
> +		case 2:
> +		default:
> +			/* Always print 0's for %pK */
>  			ptr = NULL;
> +			break;
> +		}
>  		break;
> +
>  	case 'N':
>  		switch (fmt[1]) {
>  		case 'F':
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
