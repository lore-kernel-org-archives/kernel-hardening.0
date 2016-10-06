Reply-To: kernel-hardening@lists.openwall.com
From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Thu, 6 Oct 2016 13:23:42 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC561CD145C8@ORSMSX103.amr.corp.intel.com>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <87eg3umsbs.fsf@rasmusvillemoes.dk>
In-Reply-To: <87eg3umsbs.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict level 3
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> Sent: Wednesday, October 5, 2016 4:53 PM
> To: Roberts, William C <william.c.roberts@intel.com>
> Cc: kernel-hardening@lists.openwall.com; corbet@lwn.net; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
>=20
> On Wed, Oct 05 2016, william.c.roberts@intel.com wrote:
>=20
> > From: William Roberts <william.c.roberts@intel.com>
> >
> > Some out-of-tree modules do not use %pK and just use %p, as it's the
> > common C paradigm for printing pointers. Because of this,
> > kptr_restrict has no affect on the output and thus, no way to contain
> > the kernel address leak.
> >
> > Introduce kptr_restrict level 3 that causes the kernel to treat %p as
> > if it was %pK and thus always prints zeros.
> >
> > Sample Output:
> > kptr_restrict =3D=3D 2:
> > p: 00000000604369f4
> > pK: 0000000000000000
> >
> > kptr_restrict =3D=3D 3:
> > p: 0000000000000000
> > pK: 0000000000000000
> >
> > Signed-off-by: William Roberts <william.c.roberts@intel.com>
> > ---
> >  Documentation/sysctl/kernel.txt |   3 ++
> >  kernel/sysctl.c                 |   3 +-
> >  lib/vsprintf.c                  | 107 ++++++++++++++++++++++++--------=
--------
>=20
> That's a lot of changed lines. Why isn't this just

I moved the nested case into a static local function, I thought it was easi=
er to read than the existing
nested switches. The other reason was so we didn't have kptr_restrict litte=
ring that code
and it was contained within the default and K values of the switch.

>=20
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1719,6 +1719,8 @@ char *pointer(const char *fmt, char *buf, char *end=
,
> void *ptr,
>         case 'G':
>                 return flags_string(buf, end, ptr, fmt);
>         }
> +       if (kptr_restrict =3D=3D 3)
> +               ptr =3D NULL;
>         spec.flags |=3D SMALL;
>         if (spec.field_width =3D=3D -1) {
>                 spec.field_width =3D default_width;
>=20
> ?
