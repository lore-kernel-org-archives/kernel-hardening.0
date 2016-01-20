Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453255778.25071.26.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 19 Jan 2016 18:09:38 -0800
In-Reply-To: <1453226922-16831-3-git-send-email-keescook@chromium.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	 <1453226922-16831-3-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v4 2/8] lib: add "on" and "off" to strtobool
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, "H. Peter
 Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-01-19 at 10:08 -0800, Kees Cook wrote:
> Several places in the kernel expect to use "on" and "off" for their
> boolean signifiers, so add them to strtobool.

Several places in the kernel use a char address like
fs/cifs/cifs_debug.c


	char c;
	...


	if (strtobool(&c, ...))

Using s[1] might cause problems for those uses.
> diff --git a/lib/string.c b/lib/string.c
[]
> @@ -635,12 +635,15 @@ EXPORT_SYMBOL(sysfs_streq);
>   * @s: input string
>   * @res: result
>   *
> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
> - * Otherwise it will return -EINVAL.  Value pointed to by res is
> - * updated upon finding a match.
> + * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
> + * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
> + * pointed to by res is updated upon finding a match.
>   */
>  int strtobool(const char *s, bool *res)
>  {
> +	if (!s)
> +		return -EINVAL;
> +
>  	switch (s[0]) {
>  	case 'y':
>  	case 'Y':
> @@ -652,6 +655,21 @@ int strtobool(const char *s, bool *res)
>  	case '0':
>  		*res = false;
>  		break;
> +	case 'o':
> +	case 'O':
> +		switch (s[1]) {
> +		case 'n':
> +		case 'N':
> +			*res = true;
> +			break;
> +		case 'f':
> +		case 'F':

Perhaps
		switch (tolower(s[1])) {
is more readable

> +			*res = false;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +		break;

or maybe /* fallthrough */

>  	default:
>  		return -EINVAL;
>  	}
