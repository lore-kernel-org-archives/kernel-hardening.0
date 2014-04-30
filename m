Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20140430150844.GA10621@mwanda>
References: <20140430150844.GA10621@mwanda>
Date: Wed, 30 Apr 2014 08:33:21 -0700
Message-ID: <CAGXu5jL+VLb_+ZJd6-L5P+Bdxmw+i7j2cLyPOT4rwfE6iqHuRA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [patch] lib: check for strcpy() overflows to fixed length buffers
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, devel@acpica.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 30, 2014 at 8:08 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> There are sometimes where we know that we are doing an strcpy() into a
> fixed length buffer.  In those cases, we could verify that the strcpy()
> doesn't overflow.  This patch introduces DEBUG_STRICT_SLOW_STRCPY_CHECKS
> if you want to check for that.  The downside is that it makes strcpy
> slower.
>
> I introduced __compiletime_size() to make this work.  It returns the
> size of the destination buffer or zero if the size isn't known.  The
> __compiletime_object_size() is similar but if you pass it a struct
> member then it returns the size of everything from there to the end of
> the struct.  Another difference is __compiletime_object_size() returns
> -1 for unknown sizes.
>
> If you pass a char pointer to __compiletime_size() then it returns zero.
>
> The strcpy() check ignores buffers with just one byte because people
> often use those for variable length strings at the end of a struct.
>
> I have tested this patch lightly and created some bugs for it to detect
> but I have not detected any real life overflows.

Cool, we should absolutely have this. And that's good news that it
didn't trip anything. :)

>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
> index e863dd5..5e0fc2b 100644
> --- a/include/acpi/platform/acenv.h
> +++ b/include/acpi/platform/acenv.h
> @@ -320,7 +320,7 @@
>  #define ACPI_STRSTR(s1,s2)      strstr((s1), (s2))
>  #define ACPI_STRCHR(s1,c)       strchr((s1), (c))
>  #define ACPI_STRLEN(s)          (acpi_size) strlen((s))
> -#define ACPI_STRCPY(d,s)        (void) strcpy((d), (s))
> +#define ACPI_STRCPY(d,s)        strcpy((d), (s))
>  #define ACPI_STRNCPY(d,s,n)     (void) strncpy((d), (s), (acpi_size)(n))
>  #define ACPI_STRNCMP(d,s,n)     strncmp((d), (s), (acpi_size)(n))
>  #define ACPI_STRCMP(d,s)        strcmp((d), (s))
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 2507fd2..1fb7fd0 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -16,6 +16,9 @@
>  #if GCC_VERSION >= 40100 && GCC_VERSION < 40600
>  # define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>  #endif
> +#if GCC_VERSION > 40600
> +# define __compiletime_size(obj) __builtin_object_size(obj, 3)
> +#endif
>
>  #if GCC_VERSION >= 40300
>  /* Mark functions as cold. gcc will assume any path leading to a call
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index ee7239e..b615964 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -318,6 +318,9 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  #ifndef __compiletime_object_size
>  # define __compiletime_object_size(obj) -1
>  #endif
> +#ifndef __compiletime_size
> +# define __compiletime_size(obj) 0
> +#endif
>  #ifndef __compiletime_warning
>  # define __compiletime_warning(message)
>  #endif
> diff --git a/include/linux/string.h b/include/linux/string.h
> index ac889c5..fc126a1 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -154,4 +154,13 @@ static inline const char *kbasename(const char *path)
>         return tail ? tail + 1 : path;
>  }
>
> +#if CONFIG_DEBUG_STRICT_SLOW_STRCPY_CHECKS
> +#define strcpy(dest, src) do {                                         \
> +       int len = __compiletime_size(dest);                             \
> +       if (len > 1 && strlen(src) >= len)                              \
> +               WARN_ONCE(1, "strcpy() overflow copying \"%s\"\n", src);        \

This should probably BUG. An overflowing strcpy shouldn't be allowed
to continue.

> +       strcpy(dest, src);                                              \
> +} while (0)
> +#endif
> +
>  #endif /* _LINUX_STRING_H_ */
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 819ac51..94db086 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1431,6 +1431,15 @@ config DEBUG_STRICT_USER_COPY_CHECKS
>
>           If unsure, say N.
>
> +config DEBUG_STRICT_SLOW_STRCPY_CHECKS
> +       bool "Strict checks for strcpy() overflows"
> +       depends on DEBUG_KERNEL
> +       help
> +         Enabling this option adds some extra sanity checks when strcpy() is
> +         called().  This will slow down the kernel a bit.

Isn't this an entirely compile-time check? I would expect it to be
entirely optimized by the compiler. In fact, could this be turned into
a build failure instead?

> +
> +         If unsure, say N.
> +
>  source kernel/trace/Kconfig
>
>  menu "Runtime Testing"

-Kees

-- 
Kees Cook
Chrome OS Security
