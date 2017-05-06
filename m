MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170504142435.10175-1-danielmicay@gmail.com>
References: <20170504142435.10175-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 5 May 2017 19:12:33 -0700
Message-ID: <CAGXu5jLPfNEnBJZbbxw58u+d3punUx5MNo=XRN-AnhM8RxB=jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 4, 2017 at 7:24 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> This adds support for compiling with a rough equivalent to the glibc
> _FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
> overflow checks for string.h functions when the compiler determines the
> size of the source or destination buffer at compile-time. Unlike glibc,
> it covers buffer reads in addition to writes.
>
> GNU C __builtin_*_chk intrinsics are avoided because they're only
> designed to detect write overflows and are overly complex. A single
> inline branch works for everything but strncat while those intrinsics
> would force the creation of a bunch of extra non-inline wrappers that
> aren't able to receive the detected source buffer size.
>
> This detects various undefined uses of memcpy, etc. at compile-time
> outside of non-core kernel code, and in the arm64 vdso code, so there
> will need to be a series of fixes applied (mainly memcpy -> strncpy for
> copying string constants to avoid copying past the end of the source).
> It isn't particularly bad, but there are likely some issues that occur
> during regular use at runtime (none found so far).
>
> Future improvements left out of initial implementation for simplicity,
> as it's all quite optional and can be done incrementally:
>
> The fortified string functions should place a limit on reads from the
> source. For strcat/strcpy, these could just be a variant of strlcat /
> strlcpy using the size limit as a bound on both the source and
> destination, with the return value only reporting whether truncation
> occurred rather than providing the source length. It would be an easier
> API for developers to use too and not that it really matters but it
> would be more efficient for the case where truncation is intended.
>
> It should be possible to optionally use __builtin_object_size(x, 1) for
> some functions (C strings) to detect intra-object overflows (like
> glibc's _FORTIFY_SOURCE=2), but for now this takes the conservative
> approach to avoid likely compatibility issues.
>
> The error reporting could be made friendlier by splitting up the
> compile-time error for reads and writes. The runtime error could also
> directly report the buffer and copy sizes.
>
> It may make sense to have the compile-time checks in a separate
> configuration option since they wouldn't have a runtime performance cost
> if there was an ifdef for the runtime check. However, the runtime cost
> of these checks is already quite low (much lower than SSP) and as long
> as some people are using it with allyesconfig, the issues will be found
> for any in-tree code.
>
> Signed-off-by: Daniel Micay <danielmicay@gmail.com>
> ---
>  arch/x86/boot/compressed/misc.c |   5 ++
>  include/linux/string.h          | 161 ++++++++++++++++++++++++++++++++++++++++
>  lib/string.c                    |   8 ++
>  security/Kconfig                |   6 ++
>  4 files changed, 180 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index b3c5a5f030ce..43691238a21d 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -409,3 +409,8 @@ asmlinkage __visible void *extract_kernel(void *rmode, memptr heap,
>         debug_putstr("done.\nBooting the kernel.\n");
>         return output;
>  }
> +
> +void fortify_panic(const char *name)
> +{
> +       error("detected buffer overflow");
> +}
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 26b6f6a66f83..3bd429c9593a 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -169,4 +169,165 @@ static inline const char *kbasename(const char *path)
>         return tail ? tail + 1 : path;
>  }
>
> +#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inline))
> +#define __RENAME(x) __asm__(#x)
> +
> +void fortify_panic(const char *name) __noreturn __cold;

To avoid a warning about the compressed boot fortify_panic() not
returning, this annotation is needed:

diff --git a/arch/x86/boot/compressed/error.h b/arch/x86/boot/compressed/error.h
index 2e59dac07f9e..d732e608e3af 100644
--- a/arch/x86/boot/compressed/error.h
+++ b/arch/x86/boot/compressed/error.h
@@ -1,7 +1,9 @@
 #ifndef BOOT_COMPRESSED_ERROR_H
 #define BOOT_COMPRESSED_ERROR_H

+#include <linux/compiler.h>
+
 void warn(char *m);
-void error(char *m);
+void error(char *m) __noreturn;

 #endif /* BOOT_COMPRESSED_ERROR_H */


-Kees

-- 
Kees Cook
Pixel Security
