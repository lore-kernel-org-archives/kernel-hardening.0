Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381279758.23937.42.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Tue, 08 Oct 2013 17:49:18 -0700
In-Reply-To: <5254A034.5020700@gmail.com>
References: <5254A034.5020700@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2013-10-09 at 11:15 +1100, Ryan Mallon wrote:
> Some setuid binaries will allow reading of files which have read
> permission by the real user id. This is problematic with files which
> use %pK because the file access permission is checked at open() time,
> but the kptr_restrict setting is checked at read() time. If a setuid
> binary opens a %pK file as an unprivileged user, and then elevates
> permissions before reading the file, then kernel pointer values may be
> leaked.

I think it should explicitly test 0.

Dan? Might this be any problem?

Otherwise, just style notes:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,10 +1312,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
> -		if (!((kptr_restrict == 0) ||
> -		      (kptr_restrict == 1 &&
> -		       has_capability_noaudit(current, CAP_SYSLOG))))
> -			ptr = NULL;
> +
> +		/*
> +		 * If kptr_restrict is set to 2, then %pK always prints as
> +		 * NULL. If it is set to 1, then only print the real pointer
> +		 * value if the current proccess has CAP_SYSLOG and is running
> +		 * with the same credentials it started with. This is because
> +		 * access to files is checked at open() time, but %pK checks
> +		 * permission at read() time. We don't want to leak pointer
> +		 * values if a binary opens a file using %pK and then elevates
> +		 * privileges before reading it.
> +		 */
> +		{
> +			const struct cred *cred = current_cred();

Please add #include <linux/cred.h>

> +			if (kptr_restrict == 2 || (kptr_restrict == 1 &&
> +			     (!has_capability_noaudit(current, CAP_SYSLOG) ||
> +			      !uid_eq(cred->euid, cred->uid) ||
> +			      !gid_eq(cred->egid, cred->gid))))
> +				ptr = NULL;
> +		}
>  		break;

Also, it might be easier to read as:

		if (kptr_restrict == 0)
			break;
		else if (kptr_restrict == 1) {
			const struct cred *cred = current_cred();

			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
			    !uid_eq(cred->euid, cred->uid) ||
			    !gid_eq(cred->egid, cred->gid))
				ptr = NULL;
		} else {
			ptr = NULL;
		}
		break;

>  	case 'N':
>  		switch (fmt[1]) {
