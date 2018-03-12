From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] vgacon: fix function prototypes
Date: Mon, 12 Mar 2018 15:06:12 +0100
Message-id: <4831767.IeJWIvYDSU@amdc3058>
In-reply-to: 
	<CAGXu5jJBQPPv1jr85wFFKAuLtacMWk+_P-=Yi0UR=E9yJ7nkow@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: quoted-printable
Content-type: text/plain; charset="iso-8859-1"
References: <20180310064059.12720-1-jmoreira@suse.de>
	<CAGXu5jJBQPPv1jr85wFFKAuLtacMWk+_P-=Yi0UR=E9yJ7nkow@mail.gmail.com>
	<CGME20180312140620epcas1p10db98576017a2e4ef9a6ada74eb5daf0@epcas1p1.samsung.com>
To: Kees Cook <keescook@chromium.org>
Cc: Joao Moreira <jmoreira@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, linux-fbdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Hi,

On Saturday, March 10, 2018 07:27:21 AM Kees Cook wrote:
> On Fri, Mar 9, 2018 at 10:40 PM, Joao Moreira <jmoreira@suse.de> wrot=
e:
> > It is possible to indirectly invoke functions with prototypes that =
do not
> > match those of the respectively used function pointers by using voi=
d types.
> > Despite widely used as a feature for relaxing function invocation, =
this
> > should be avoided when possible as it may prevent the use of heuris=
tics
> > such as prototype matching-based Control-Flow Integrity, which can =
be used
> > to prevent ROP-based attacks.
> >
> > Given the above, the current efforts to improve the Linux security,=
 and the
> > upcoming kernel support to compilers with CFI features, fix prototy=
pes in
> > vgacon console driver.
> >
> > Another similar fix can be seen in [1].
> >
> > [1] https://android-review.googlesource.com/c/kernel/common/+/60201=
0
> >
> > Signed-off-by:  Jo=E3o Moreira <jmoreira@suse.de>
>=20
> Whoops, I missed this one. :) Thanks! Greg, do you need this resent
> directly to you?

I would prefer for drivers/video/console/ changes to go through
fbdev tree (like suggested by scripts/get_maintainers.pl)..

However since Greg has already merged your CFI patches:

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> Acked-by: Kees Cook <keescook@chromium.org>
>=20
> -Kees
>=20
> > ---
> >  drivers/video/console/vgacon.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/video/console/vgacon.c b/drivers/video/console=
/vgacon.c
> > index a17ba1465815..f00b630f6839 100644
> > --- a/drivers/video/console/vgacon.c
> > +++ b/drivers/video/console/vgacon.c
> > @@ -1407,21 +1407,29 @@ static bool vgacon_scroll(struct vc_data *c=
, unsigned int t, unsigned int b,
> >   *  The console `switch' structure for the VGA based console
> >   */
> >
> > -static int vgacon_dummy(struct vc_data *c)
> > +static int vgacon_clear(struct vc_data *c)
> >  {
> >         return 0;
> >  }
> >
> > -#define DUMMY (void *) vgacon_dummy
> > +static void vgacon_putc(struct vc_data *c, int a, int b, int d)
> > +{
> > +       return;
> > +}
> > +
> > +static void vgacon_putcs(struct vc_data *c, ushort *s, int a, int =
b, int d)
> > +{
> > +       return;
> > +}
> >
> >  const struct consw vga_con =3D {
> >         .owner =3D THIS_MODULE,
> >         .con_startup =3D vgacon_startup,
> >         .con_init =3D vgacon_init,
> >         .con_deinit =3D vgacon_deinit,
> > -       .con_clear =3D DUMMY,
> > -       .con_putc =3D DUMMY,
> > -       .con_putcs =3D DUMMY,
> > +       .con_clear =3D vgacon_clear,
> > +       .con_putc =3D vgacon_putc,
> > +       .con_putcs =3D vgacon_putcs,
> >         .con_cursor =3D vgacon_cursor,
> >         .con_scroll =3D vgacon_scroll,
> >         .con_switch =3D vgacon_switch,
> > --
> > 2.13.6

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
