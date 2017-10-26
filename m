Message-ID: <1508993843.10651.22.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 25 Oct 2017 21:57:23 -0700
In-Reply-To: <1508986436-31966-2-git-send-email-me@tobin.cc>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
	 <1508986436-31966-2-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V8 1/2] printk: remove tabular output for NULL pointer
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-10-26 at 13:53 +1100, Tobin C. Harding wrote:
> Currently pointer() checks for a NULL pointer argument and then if so
> attempts to print "(null)" with _some_ standard width. This width cannot
> correctly be ascertained here because many of the printk specifiers
> print pointers of varying widths.

I believe this is not a good change.
Only pointers without a <foo> extension call pointer()

> Remove the attempt to print NULL pointers with a correct width.

the correct width for a %p is the default width.
The correct width for %p<foo> is unknown.

> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  lib/vsprintf.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 86c3385b9eb3..16a587aed40e 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1710,15 +1710,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  {
>  	const int default_width = 2 * sizeof(void *);
>  
> -	if (!ptr && *fmt != 'K') {
> -		/*
> -		 * Print (null) with the same width as a pointer so it makes
> -		 * tabular output look nice.
> -		 */
> -		if (spec.field_width == -1)
> -			spec.field_width = default_width;
> +	if (!ptr && *fmt != 'K')
>  		return string(buf, end, "(null)", spec);
> -	}
>  
>  	switch (*fmt) {
>  	case 'F':
