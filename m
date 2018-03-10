MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180310064059.12720-1-jmoreira@suse.de>
References: <20180310064059.12720-1-jmoreira@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 10 Mar 2018 07:27:21 -0800
Message-ID: <CAGXu5jJBQPPv1jr85wFFKAuLtacMWk+_P-=Yi0UR=E9yJ7nkow@mail.gmail.com>
Subject: Re: [PATCH] vgacon: fix function prototypes
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Joao Moreira <jmoreira@suse.de>, Greg KH <gregkh@linuxfoundation.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 9, 2018 at 10:40 PM, Joao Moreira <jmoreira@suse.de> wrote:
> It is possible to indirectly invoke functions with prototypes that do not
> match those of the respectively used function pointers by using void type=
s.
> Despite widely used as a feature for relaxing function invocation, this
> should be avoided when possible as it may prevent the use of heuristics
> such as prototype matching-based Control-Flow Integrity, which can be use=
d
> to prevent ROP-based attacks.
>
> Given the above, the current efforts to improve the Linux security, and t=
he
> upcoming kernel support to compilers with CFI features, fix prototypes in
> vgacon console driver.
>
> Another similar fix can be seen in [1].
>
> [1] https://android-review.googlesource.com/c/kernel/common/+/602010
>
> Signed-off-by:  Jo=C3=A3o Moreira <jmoreira@suse.de>

Whoops, I missed this one. :) Thanks! Greg, do you need this resent
directly to you?

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/video/console/vgacon.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgaco=
n.c
> index a17ba1465815..f00b630f6839 100644
> --- a/drivers/video/console/vgacon.c
> +++ b/drivers/video/console/vgacon.c
> @@ -1407,21 +1407,29 @@ static bool vgacon_scroll(struct vc_data *c, unsi=
gned int t, unsigned int b,
>   *  The console `switch' structure for the VGA based console
>   */
>
> -static int vgacon_dummy(struct vc_data *c)
> +static int vgacon_clear(struct vc_data *c)
>  {
>         return 0;
>  }
>
> -#define DUMMY (void *) vgacon_dummy
> +static void vgacon_putc(struct vc_data *c, int a, int b, int d)
> +{
> +       return;
> +}
> +
> +static void vgacon_putcs(struct vc_data *c, ushort *s, int a, int b, int=
 d)
> +{
> +       return;
> +}
>
>  const struct consw vga_con =3D {
>         .owner =3D THIS_MODULE,
>         .con_startup =3D vgacon_startup,
>         .con_init =3D vgacon_init,
>         .con_deinit =3D vgacon_deinit,
> -       .con_clear =3D DUMMY,
> -       .con_putc =3D DUMMY,
> -       .con_putcs =3D DUMMY,
> +       .con_clear =3D vgacon_clear,
> +       .con_putc =3D vgacon_putc,
> +       .con_putcs =3D vgacon_putcs,
>         .con_cursor =3D vgacon_cursor,
>         .con_scroll =3D vgacon_scroll,
>         .con_switch =3D vgacon_switch,
> --
> 2.13.6
>



--=20
Kees Cook
Pixel Security
