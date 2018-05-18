MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180411010330.17866-1-labbott@redhat.com>
References: <20180411010330.17866-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 18 May 2018 11:01:55 -0700
Message-ID: <CAGXu5jK-qTdkDi2bC7DZg-bR-tFjSGOZsNB9_b-F++qMgdcF+Q@mail.gmail.com>
Subject: Re: [PATCHv2] drm/i2c: tda998x: Remove VLA usage
Content-Type: text/plain; charset="UTF-8"
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Laura Abbott <labbott@redhat.com>, Russell King <linux@armlinux.org.uk>, David Airlie <airlied@linux.ie>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 10, 2018 at 6:03 PM, Laura Abbott <labbott@redhat.com> wrote:
> There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> turn on -Wvla. The vla in reg_write_range is based on the length of data
> passed. The one use of a non-constant size for this range is bounded by
> the size buffer passed to hdmi_infoframe_pack which is a fixed size.
> Switch to this upper bound.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Same question for this patch: who's best to take this?

Thanks!

-Kees

> ---
> v2: Switch to make the buffer size more transparent and add a bounds
> check.
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 9e67a7b4e3a4..c8b6029b7839 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -466,13 +466,22 @@ reg_read_range(struct tda998x_priv *priv, u16 reg, char *buf, int cnt)
>         return ret;
>  }
>
> +#define MAX_WRITE_RANGE_BUF 32
> +
>  static void
>  reg_write_range(struct tda998x_priv *priv, u16 reg, u8 *p, int cnt)
>  {
>         struct i2c_client *client = priv->hdmi;
> -       u8 buf[cnt+1];
> +       /* This is the maximum size of the buffer passed in */
> +       u8 buf[MAX_WRITE_RANGE_BUF + 1];
>         int ret;
>
> +       if (cnt > MAX_WRITE_RANGE_BUF) {
> +               dev_err(&client->dev, "Fixed write buffer too small (%d)\n",
> +                               MAX_WRITE_RANGE_BUF);
> +               return;
> +       }
> +
>         buf[0] = REG2ADDR(reg);
>         memcpy(&buf[1], p, cnt);
>
> @@ -679,7 +688,7 @@ static void
>  tda998x_write_if(struct tda998x_priv *priv, u8 bit, u16 addr,
>                  union hdmi_infoframe *frame)
>  {
> -       u8 buf[32];
> +       u8 buf[MAX_WRITE_RANGE_BUF];
>         ssize_t len;
>
>         len = hdmi_infoframe_pack(frame, buf, sizeof(buf));
> --
> 2.14.3
>



-- 
Kees Cook
Pixel Security
