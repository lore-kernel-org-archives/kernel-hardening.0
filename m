Message-ID: <1513555454.31581.43.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Sun, 17 Dec 2017 16:04:14 -0800
In-Reply-To: <1513554812-13014-3-git-send-email-me@tobin.cc>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
	 <1513554812-13014-3-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/3] vsprintf: print <no-symbol> if symbol not found
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-12-18 at 10:53 +1100, Tobin C. Harding wrote:
> Depends on: commit bd6b239cdbb2 ("kallsyms: don't leak address when
> symbol not found")
> 
> Currently vsprintf for specifiers %p[SsB] relies on the behaviour of
> kallsyms (sprint_symbol()) and prints the actual address if a symbol is
> not found. Previous patch changes this behaviour so tha sprint_symbol()

tha->that

> returns an error if symbol not found. With this patch in place we can
> print a sanitized message '<no-symbol>' instead of leaking the address.
> 
> Print '<no-symbol>' for printk specifier %s[sSB] if no symbol is found.

%s->%ps

> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
[]
> @@ -460,6 +460,8 @@ char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
>  extern __printf(2, 0)
>  const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
>  
> +extern int string_is_no_symbol(const char *s);
> +
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> 
> +#define PRINTK_NO_SYMBOL_STR "<no-symbol>"

"<symbol unavailable>" ?  "not found"?

[]

> +int string_is_no_symbol(const char *s)
> +{
> +	return !!strstr(s, PRINTK_NO_SYMBOL_STR);
> +}
> +EXPORT_SYMBOL(string_is_no_symbol);

Why should string_is_no_symbol be exported?
