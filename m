Date: Tue, 16 May 2017 13:58:11 +0200
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20170516115811.GA7297@pathway.suse.cz>
References: <20170506040641.GA32707@kroah.com>
 <20170506040656.GB32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040656.GB32707@kroah.com>
Subject: [kernel-hardening] Re: [RFC 1/6] lib: vsprintf: additional kernel pointer filtering
 options
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 2017-05-05 21:06:56, Greg KH wrote:
> From: Dave Weinstein <olorin@google.com>
> 
> Add the kptr_restrict setting of 3 which results in both
> %p and %pK values being replaced by zeros.
> 
> Add an additional %pP value inspired by the Grsecurity
> option which explicitly whitelists pointers for output.
> 
> This patch is based on work by William Roberts
> <william.c.roberts@intel.com>
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index e3bf4e0f10b5..f4e11dade1ab 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -395,6 +395,16 @@ struct printf_spec {
>  #define FIELD_WIDTH_MAX ((1 << 23) - 1)
>  #define PRECISION_MAX ((1 << 15) - 1)
>  
> +int kptr_restrict __read_mostly;
> +
> +/*
> + * Always cleanse %p and %pK specifiers
> + */
> +static inline int kptr_restrict_always_cleanse_pointers(void)

The name of the function is very long and still confusing.
It uses the word "always" but there are many types of pointers
that are not cleared with this condition, for example %pP, %pa.

Do we need this helper function at all? It is used
a weird way, see below.

> +{
> +	return kptr_restrict >= 3;
> +}
> +
>  static noinline_for_stack
>  char *number(char *buf, char *end, unsigned long long num,
>  	     struct printf_spec spec)
> @@ -1576,7 +1588,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  {
>  	const int default_width = 2 * sizeof(void *);
>  
> -	if (!ptr && *fmt != 'K') {
> +	if (!ptr && *fmt != 'K' && !kptr_restrict_always_cleanse_pointers()) {
>  		/*
>  		 * Print (null) with the same width as a pointer so it makes
>  		 * tabular output look nice.
> @@ -1657,10 +1669,43 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			va_end(va);
>  			return buf;
>  		}
> +	case 'N':
> +		return netdev_bits(buf, end, ptr, fmt);
> +	case 'a':
> +		return address_val(buf, end, ptr, fmt);
> +	case 'd':
> +		return dentry_name(buf, end, ptr, spec, fmt);
> +	case 'C':
> +		return clock(buf, end, ptr, spec, fmt);
> +	case 'D':
> +		return dentry_name(buf, end,
> +				   ((const struct file *)ptr)->f_path.dentry,
> +				   spec, fmt);
> +#ifdef CONFIG_BLOCK
> +	case 'g':
> +		return bdev_name(buf, end, ptr, spec, fmt);
> +#endif
> +
> +	case 'G':
> +		return flags_string(buf, end, ptr, fmt);
> +	case 'P':
> +		/*
> +		 * an explicitly whitelisted kernel pointer should never be
> +		 * cleansed
> +		 */
> +		break;
> +	default:
> +		/*
> +		 * plain %p, no extension, check if we should always cleanse and
> +		 * treat like %pK.
> +		 */
> +		if (!kptr_restrict_always_cleanse_pointers())
> +			break;
> +		/* fallthrough */

Using default: in the middle of other cases is pretty confusing
and a call for troubles.

>  	case 'K':
>  		switch (kptr_restrict) {
>  		case 0:
> -			/* Always print %pK values */
> +			/* Always print %p values */

And this is one example. We are never here for %p because we
called break in the "default:" case above for kptr_restrict == 0.


>  			break;
>  		case 1: {
>  			const struct cred *cred;
> @@ -1679,7 +1724,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			 * Only print the real pointer value if the current
>  			 * process has CAP_SYSLOG and is running with the
>  			 * same credentials it started with. This is because
> -			 * access to files is checked at open() time, but %pK
> +			 * access to files is checked at open() time,
>  		but %p

Same here. This change makes the feeling that we check CAP_SYSLOG even
for plain %p but we actually do not do it.

>  			 * checks permission at read() time. We don't want to
>  			 * leak pointer values if a binary opens a file using
>  			 * %pK and then elevates privileges before reading it.
> @@ -1691,33 +1736,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  				ptr = NULL;
>  			break;
>  		}
> -		case 2:
> +		case 2: /* restrict only %pK */
> +		case 3: /* restrict all non-extensioned %p and %pK */
>  		default:
> -			/* Always print 0's for %pK */
>  			ptr = NULL;
>  			break;
>  		}
>  		break;


I would personally write this piece of code a more straightforward way,
for example:

	switch (*fmt) {
[...]
	case 'P':
		/* Always print an explicitly whitelisted kernel pointer. */
		break;
	case 'K':
		/* Always print %pK values when there are no restrictions. */
		if (!kptr_restrict)
			break;

		/* Cleanse %pK values for non-privileged users. */
		if (kptr_restrict == 1) {
			const struct cred *cred;

			/*
			 * kptr_restrict==1 cannot be used in IRQ context
			 * because its test for CAP_SYSLOG would be meaningless.
			 */
			if (in_irq() || in_serving_softirq() || in_nmi()) {
				if (spec.field_width == -1)
					spec.field_width = default_width;
				return string(buf, end, "pK-error", spec);
			}

			/*
			 * Only print the real pointer value if the current
			 * process has CAP_SYSLOG and is running with the
			 * same credentials it started with. This is because
			 * access to files is checked at open() time, but %p
			 * checks permission at read() time. We don't want to
			 * leak pointer values if a binary opens a file using
			 * %pK and then elevates privileges before reading it.
			 */
			cred = current_cred();
			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
			    !uid_eq(cred->euid, cred->uid) ||
			    !gid_eq(cred->egid, cred->gid))
				ptr = NULL;
			break;
		}

		/* Always cleanse %pK values in higher restrition levels. */
		ptr = NULL;
		break;

	default:
		/*
		 * Also plain pointers (%p) are always cleansed in higher
		 * restriction levels.
		 */
		if (kptr_restrict >= 3)
			ptr = NULL;
	}

Best Regards,
Petr
