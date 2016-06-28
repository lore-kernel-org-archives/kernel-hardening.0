Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	<20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
Date: Tue, 28 Jun 2016 22:50:55 +0200
In-Reply-To: <20160628133645.8f3cac0df4fc363e308426ac@gmail.com> (Emese
	Revfy's message of "Tue, 28 Jun 2016 13:36:45 +0200")
Message-ID: <874m8dhwb4.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28 2016, Emese Revfy <re.emese@gmail.com> wrote:

> The nocapture gcc attribute can be on functions only.
> The attribute takes one or more unsigned integer constants as parameters
> that specify the function argument(s) of const char* type to initify.
> If the marked argument is a vararg then the plugin initifies
> all vararg arguments.
>
> I couldn't test the arm, arm64 and powerpc architectures.
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  arch/arm/include/asm/string.h     | 10 +++---
>  arch/arm64/include/asm/string.h   | 23 ++++++------
>  arch/powerpc/include/asm/string.h | 19 +++++-----
>  arch/x86/boot/string.h            |  4 +--
>  arch/x86/include/asm/string_32.h  | 21 +++++------
>  arch/x86/include/asm/string_64.h  | 18 +++++-----
>  arch/x86/kernel/hpet.c            |  2 +-
>  include/asm-generic/bug.h         |  6 ++--
>  include/linux/compiler-gcc.h      | 10 ++++--
>  include/linux/compiler.h          |  4 +++
>  include/linux/fs.h                |  5 +--
>  include/linux/printk.h            |  2 +-
>  include/linux/string.h            | 73 ++++++++++++++++++++-------------------
>  13 files changed, 107 insertions(+), 90 deletions(-)
>
> diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
> index cf4f3aa..3f68273 100644
> --- a/arch/arm/include/asm/string.h
> +++ b/arch/arm/include/asm/string.h
> @@ -7,19 +7,19 @@
>   */
>  
>  #define __HAVE_ARCH_STRRCHR
> -extern char * strrchr(const char * s, int c);
> +extern char * strrchr(const char * s, int c) __nocapture(1);
>  
>  #define __HAVE_ARCH_STRCHR
> -extern char * strchr(const char * s, int c);
> +extern char * strchr(const char * s, int c) __nocapture(1);
>  
>  #define __HAVE_ARCH_MEMCPY
> -extern void * memcpy(void *, const void *, __kernel_size_t);
> +extern void * memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
>  

Why not also mark he dest argument of the various strcpy/memcpy/memset
functions as nocapture? It's no use for the initify plugin, but a static
analysis tool could for example use it to (better) diagnose resource leaks
(e.g., a buffer is kmalloc'ed and initialized with some *cpy, but then
something goes wrong, and the buffer isn't freed on the error path).
>  
>  #define __HAVE_ARCH_STRLEN
>  extern __kernel_size_t strlen(const char *);

Why not also mark strlen? I know that gcc optimizes strlen("literal")
away, but, again, there might be other uses even when the argument is
not a literal. One example is the plugin itself, which could deduce (or
suggest) __nocapture for a given function parameter if the parameter is
only passed on as __nocapture arguments.

> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 6f96247..4cdf266 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -62,13 +62,13 @@ struct bug_entry {
>   * to provide better diagnostics.
>   */
>  #ifndef __WARN_TAINT
> -extern __printf(3, 4)
> +extern __printf(3, 4) __nocapture(1, 3, 4)
>  void warn_slowpath_fmt(const char *file, const int line,
>  		       const char *fmt, ...);
> -extern __printf(4, 5)
> +extern __printf(4, 5) __nocapture(1, 4, 5)
>  void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
>  			     const char *fmt, ...);

The 3,4 and 4,5 parts seem redundant when __printf automatically supplies those.

> -extern void warn_slowpath_null(const char *file, const int line);
> +extern __nocapture(1) void warn_slowpath_null(const char *file, const int line);
>  #define WANT_WARN_ON_SLOWPATH
>  #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
>  #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> index df88c0a..192cea4 100644
> --- a/include/linux/compiler-gcc.h
> +++ b/include/linux/compiler-gcc.h
> @@ -116,8 +116,10 @@
>   */
>  #define __pure			__attribute__((pure))
>  #define __aligned(x)		__attribute__((aligned(x)))
> -#define __printf(a, b)		__attribute__((format(printf, a, b)))
> -#define __scanf(a, b)		__attribute__((format(scanf, a, b)))
> +#define __printf(a, b)		__attribute__((format(printf, a, b))) \
> +				__nocapture(a, b)
> +#define __scanf(a, b)		__attribute__((format(scanf, a, b))) \
> +				__nocapture(a, b)

So obviously the output parameters for scanf are never going to be
string literals, but I've already argued that one might as well put the
__nocapture on all relevant pointer arguments while we're churning the
headers, so keep this.

>  
> -extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
> -extern const char *kstrdup_const(const char *s, gfp_t gfp);
> -extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
> -extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
> +extern char *kstrdup(const char *s, gfp_t gfp) __malloc __nocapture(1);
> +extern const char *kstrdup_const(const char *s, gfp_t gfp) __nocapture(1);

OK, so this one is pretty dangerous, and probably wrong. If one does

  foo->bar = kstrdup_const(a-macro-that-might-be-a-string-literal)

in an .init function, foo->bar will very likely become dangling. Come to
think of it, I guess this means that __nocapture arguments must not only
not be stashed anywhere, the return value cannot point (in)to the same
object, which in turn then also disqualifies at least strchr(), memchr()
and the haystack parameter of strstr(). And bummer, that kills my
suggestion to add __nocapture to the dst parameters of *cpy, since they
return that argument.

Rasmus
