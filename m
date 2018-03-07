MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1520400451-11475-3-git-send-email-me@tobin.cc>
References: <1520400451-11475-1-git-send-email-me@tobin.cc> <1520400451-11475-3-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 6 Mar 2018 21:46:02 -0800
Message-ID: <CAGXu5jKgQsg8e4N2oqZc6g6EdvcEA45hoK8Gu63=bwNuJwZrig@mail.gmail.com>
Subject: Re: [RFC 2/2] lustre: use VLA_SAFE
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 6, 2018 at 9:27 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Currently lustre uses a VLA to store a string on the stack.  We can use
> the newly define VLA_SAFE macro to make this declaration safer.
>
> Use VLA_SAFE to declare VLA.

VLA_SAFE implements a max, which is nice, but I think we're just
digging ourselves into a bigger hole with this, since now all the
maxes must be validated (which isn't done here, what happens if
VLA_DEFAULT_MAX is smaller than the strlen() math? We'll overflow the
stack buffer in the later sprintf).

>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  drivers/staging/lustre/lustre/llite/xattr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
> index 532384c91447..6f4099cd4afa 100644
> --- a/drivers/staging/lustre/lustre/llite/xattr.c
> +++ b/drivers/staging/lustre/lustre/llite/xattr.c
> @@ -36,6 +36,7 @@
>  #include <linux/mm.h>
>  #include <linux/xattr.h>
>  #include <linux/selinux.h>
> +#include <linux/vla.h>
>
>  #define DEBUG_SUBSYSTEM S_LLITE
>
> @@ -87,12 +88,13 @@ ll_xattr_set_common(const struct xattr_handler *handler,
>                     const char *name, const void *value, size_t size,
>                     int flags)
>  {
> -       char fullname[strlen(handler->prefix) + strlen(name) + 1];
>         struct ll_sb_info *sbi = ll_i2sbi(inode);
>         struct ptlrpc_request *req = NULL;
>         const char *pv = value;
>         __u64 valid;
>         int rc;
> +       int size = strlen(handler->prefix) + strlen(name) + 1;
> +       VLA_SAFE(char, fullname, size, VLA_DEFAULT_MAX);
>
>         if (flags == XATTR_REPLACE) {
>                 ll_stats_ops_tally(ll_i2sbi(inode), LPROC_LL_REMOVEXATTR, 1);

In the lustre case, I think it's better to just remove the stack
allocation entirely. (See separate patch...)

-Kees

-- 
Kees Cook
Pixel Security
