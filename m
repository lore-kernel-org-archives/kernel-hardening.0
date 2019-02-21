MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-4-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-4-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 16:07:26 -0800
Message-ID: <CAGXu5jJ++_VufY8t3WYsGW8VN-3yJEbVpOi_67RxHPicCC-K6A@mail.gmail.com>
Subject: Re: [PATCH 3/6] lib/string: Use correct docstring format
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
>
> Currently the docstring comments for strscpy() are not in the correct
> format.  Prior to working on this file fix up the docstring.
>
> Use correct docstring format for strscpy().

Is this attached to "make htmldocs" anywhere? Maybe in the device
driver api doc? That's where I put refcount_t. See
driver-api/basics.rst and put something like:

String Handling
--------------------

.. kernel-doc:: lib/string.c
   :internal:

and add that chunk to this patch.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  lib/string.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/lib/string.c b/lib/string.c
> index 7f1d72db53c5..65969cf32f5d 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -159,11 +159,9 @@ EXPORT_SYMBOL(strlcpy);
>   * @src: Where to copy the string from
>   * @count: Size of destination buffer
>   *
> - * Copy the string, or as much of it as fits, into the dest buffer.
> - * The routine returns the number of characters copied (not including
> - * the trailing NUL) or -E2BIG if the destination buffer wasn't big enough.
> - * The behavior is undefined if the string buffers overlap.
> - * The destination buffer is always NUL terminated, unless it's zero-sized.
> + * Copy the string, or as much of it as fits, into the dest buffer.  The
> + * behavior is undefined if the string buffers overlap.  The destination
> + * buffer is always NUL terminated, unless it's zero-sized.
>   *
>   * Preferred to strlcpy() since the API doesn't require reading memory
>   * from the src string beyond the specified "count" bytes, and since
> @@ -175,6 +173,9 @@ EXPORT_SYMBOL(strlcpy);
>   * doesn't unnecessarily force the tail of the destination buffer to be
>   * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
>   * check the return size, then just memset() the tail of the dest buffer.
> + *
> + * Return: The number of characters copied (not including the trailing
> + *         NUL) or -E2BIG if the destination buffer wasn't big enough.
>   */
>  ssize_t strscpy(char *dest, const char *src, size_t count)
>  {
> --
> 2.20.1
>


-- 
Kees Cook
