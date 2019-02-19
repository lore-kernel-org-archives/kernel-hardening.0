MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-7-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-7-tobin@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 Feb 2019 03:09:34 +0100
Message-ID: <CAG48ez0t4DJGnv6oVVtiEeR-m3Oz_Zt-JNNzrA2CD2aZWAamvA@mail.gmail.com>
Subject: Re: [PATCH 6/6] lib: Add function strscpy_from_user()
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 12:25 AM Tobin C. Harding <tobin@kernel.org> wrote:
> Currently we have strncpy_from_userspace().  If the user string is
> longer than the destination kernel buffer we get an error code -EFAULT.

No, see the other thread. If the user string is too long,
strncpy_from_userspace() fills the output buffer with non-null bytes
and returns the supplied length.

> We are unable to recover from here because this is the same error
> returned if the access to userspace fails totally.
>
> There is no reason we cannot continue execution with the user string
> truncated.
>
> Add a function strscpy_from_user() that guarantees the string written is
> null-terminated.  If user string is longer than destination buffer
> truncates the string.  Returns the number of characters written
> excluding the null-terminator.
>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  lib/strncpy_from_user.c | 43 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>
> diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> index 11fe9a4a00fd..6bd603ccec7a 100644
> --- a/lib/strncpy_from_user.c
> +++ b/lib/strncpy_from_user.c
> @@ -120,3 +120,46 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
>         return -EFAULT;
>  }
>  EXPORT_SYMBOL(strncpy_from_user);
> +
> +/**
> + * strscpy_from_user() - Copy a NUL terminated string from userspace.
> + * @dst:   Destination address, in kernel space.  This buffer must be at
> + *         least @count bytes long.
> + * @src:   Source address, in user space.
> + * @count: Maximum number of bytes to copy, including the trailing %NUL.
> + *
> + * Copies a NUL-terminated string from userspace to kernel space.  When
> + * the function returns @dst is guaranteed to be null terminated.
> + *
> + * Return: If access to userspace fails, returns -EFAULT.

That's wrong. Actually, you only return -EFAULT if the specified
source address points to an address outside the userspace address
range.

> Otherwise,
> + *         return the number of characters copied excluding the trailing
> + *         %NUL.
> + */
> +long strscpy_from_user(char *dst, const char __user *src, long count)
> +{
> +       unsigned long max_addr, src_addr;
> +
> +       if (unlikely(count <= 0))
> +               return 0;

The "supply a signed long and quietly bail out if it's smaller than
zero" pattern seems bad to me. If count is zero, you can't guarantee
that the buffer will be null-terminated, and if it's smaller than
zero, something has gone very wrong.

> +       max_addr = user_addr_max();
> +       src_addr = (unsigned long)src;
> +       if (likely(src_addr < max_addr)) {
> +               unsigned long max = max_addr - src_addr;
> +               long retval;
> +
> +               kasan_check_write(dst, count);
> +               check_object_size(dst, count, false);
> +               if (user_access_begin(src, max)) {
> +                       retval = do_strncpy_from_user(dst, src, count, max);
> +                       user_access_end();
> +                       if (retval == -EFAULT) {
> +                               dst[count-1] = '\0';
> +                               return count - 1;

Uh... this looks bad. If do_strncpy_from_user() gets a fault -
anywhere -, you just put a nullbyte at the end of the supplied buffer
and return? As far as I can tell, this means that the caller will
think that you've filled the entire buffer, but actually everything
except for the last byte might be uninitialized.

> +                       }
> +                       return retval;
> +               }
> +       }
> +       return -EFAULT;
> +}
> +EXPORT_SYMBOL(strscpy_from_user);
> --
> 2.20.1
>
