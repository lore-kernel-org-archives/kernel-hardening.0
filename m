Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381285806.23937.51.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Tue, 08 Oct 2013 19:30:06 -0700
In-Reply-To: <5254BDD0.7040001@gmail.com>
References: <5254A034.5020700@gmail.com>
	 <1381279758.23937.42.camel@joe-AO722> <1381282200.23937.45.camel@joe-AO722>
		 <5254B787.6080700@gmail.com> <1381284056.23937.49.camel@joe-AO722>
	 <5254BDD0.7040001@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2013-10-09 at 13:22 +1100, Ryan Mallon wrote:

> Anyway, updated patch below:

nit:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1312,11 +1313,36 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				spec.field_width = default_width;
>  			return string(buf, end, "pK-error", spec);
>  		}
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
> +			 * proccess has CAP_SYSLOG and is running with the

s/proccess/process/ typo
