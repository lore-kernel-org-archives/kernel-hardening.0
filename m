MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180409210647.3718-1-labbott@redhat.com>
References: <20180409210647.3718-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 18 May 2018 10:58:40 -0700
Message-ID: <CAGXu5jLcRqjk17BqprGsWJXqGusoR6nRSf8986w7chQ9UONKMA@mail.gmail.com>
Subject: Re: [PATCH] drm/gma500: Remove VLA
Content-Type: text/plain; charset="UTF-8"
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Laura Abbott <labbott@redhat.com>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, David Airlie <airlied@linux.ie>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 9, 2018 at 2:06 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. Switch to a reasonable upper bound for the VLAs in
> the gma500 driver.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Daniel, can this go via you, or what's the best path for this patch?

Thanks!

-Kees

> ---
> This was a little hard to figure out but I think 32 should be a
> comfortable upper bound based on all the structures I saw. Of course I
> can't test it.
> ---
>  drivers/gpu/drm/gma500/psb_intel_sdvo.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/gma500/psb_intel_sdvo.c b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
> index 84507912be84..3d4fa9f6b94c 100644
> --- a/drivers/gpu/drm/gma500/psb_intel_sdvo.c
> +++ b/drivers/gpu/drm/gma500/psb_intel_sdvo.c
> @@ -429,13 +429,20 @@ static const char *cmd_status_names[] = {
>         "Scaling not supported"
>  };
>
> +#define MAX_ARG_LEN 32
> +
>  static bool psb_intel_sdvo_write_cmd(struct psb_intel_sdvo *psb_intel_sdvo, u8 cmd,
>                                  const void *args, int args_len)
>  {
> -       u8 buf[args_len*2 + 2], status;
> -       struct i2c_msg msgs[args_len + 3];
> +       u8 buf[MAX_ARG_LEN*2 + 2], status;
> +       struct i2c_msg msgs[MAX_ARG_LEN + 3];
>         int i, ret;
>
> +       if (args_len > MAX_ARG_LEN) {
> +               DRM_ERROR("Need to increase arg length\n");
> +               return false;
> +       }
> +
>         psb_intel_sdvo_debug_write(psb_intel_sdvo, cmd, args, args_len);
>
>         for (i = 0; i < args_len; i++) {
> --
> 2.14.3
>



-- 
Kees Cook
Pixel Security
