Date: Wed, 7 Mar 2018 15:40:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: Remove accidental VLA usage
Message-Id: <20180307154019.e39890b5f8aa98cf25532cf1@linux-foundation.org>
In-Reply-To: <20180307230714.GA20797@beast>
References: <20180307230714.GA20797@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 7 Mar 2018 15:07:14 -0800 Kees Cook <keescook@chromium.org> wrote:

> The "sym" calculation is actually a fixed size, but since the max()
> macro uses some extensive tricks for safety, it ends up looking like a
> variable size. This replaces max() with a simple max macro which is
> sufficient for the calculation of the array size.
> 
> Seen with -Wvla. Fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621
> 
> ...
>
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -744,8 +744,9 @@ char *resource_string(char *buf, char *end, struct resource *res,
>  #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
>  #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
>  #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
> -	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
> -		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
> +#define SIMPLE_MAX(x, y)	((x) > (y) ? (x) : (y))
> +	char sym[SIMPLE_MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
> +			    2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
>  
>  	char *p = sym, *pend = sym + sizeof(sym);
>  	int decode = (fmt[0] == 'R') ? 1 : 0;

A year from now I'll be receiving an email titled

	[patch] lib/vsprintf.c: use standard max() macro

won't I?

--- a/lib/vsprintf.c~vsprintf-remove-accidental-vla-usage-fix
+++ a/lib/vsprintf.c
@@ -754,6 +754,7 @@ char *resource_string(char *buf, char *e
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
+/* regular max() tricks gcc into creating a variable length array */
 #define SIMPLE_MAX(x, y)	((x) > (y) ? (x) : (y))
 	char sym[SIMPLE_MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 			    2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
_
