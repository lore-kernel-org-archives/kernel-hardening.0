MIME-Version: 1.0
In-Reply-To: <20170423072457.27120-1-matt@nmatt.com>
References: <20170423072457.27120-1-matt@nmatt.com>
From: Jann Horn <jannh@google.com>
Date: Sun, 23 Apr 2017 19:02:24 +0200
Message-ID: <CAG48ez2jc8NT1mtQrGjJkY-LMyYPzUf50zEh3UNDzs+NtCe2fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/2] tiocsti-restrict : Add owner user namespace to tty_struct
To: Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, corbet@lwn.net, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 23, 2017 at 9:24 AM, Matt Brown <matt@nmatt.com> wrote:
> This patch adds struct user_namespace *owner_user_ns to the tty_struct.
> Then it is set to current_user_ns() in the alloc_tty_struct function.
>
> This is done to facilitate capability checks against the original user
> namespace that allocated the tty.
>
> E.g. ns_capable(tty->owner_user_ns,CAP_SYS_ADMIN)
>
> This combined with the use of user namespace's will allow hardening
> protections to be built to mitigate container escapes that utilize TTY
> ioctls such as TIOCSTI.
>
> See: https://bugzilla.redhat.com/show_bug.cgi?id=1411256
>
> Signed-off-by: Matt Brown <matt@nmatt.com>
> ---
>  drivers/tty/tty_io.c | 1 +
>  include/linux/tty.h  | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index e6d1a65..e774385 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -3191,6 +3191,7 @@ struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
>         tty->index = idx;
>         tty_line_name(driver, idx, tty->name);
>         tty->dev = tty_get_device(tty);
> +       tty->owner_user_ns = current_user_ns();

Why are you not taking a reference to the userns?
