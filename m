From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3/3] leaking_addresses: Expand tilde in output file name
Date: Thu, 14 Feb 2019 09:50:39 +0000
Message-ID: <f775f497043e4e88a23a980c23d744b1@AcuMS.aculab.com>
References: <20190207225026.11723-1-tobin@kernel.org>
 <20190207225026.11723-4-tobin@kernel.org>
 <6aed136f16e8451dbcfa97f90c04438f@AcuMS.aculab.com>
 <20190213203033.GB31743@eros.localdomain>
In-Reply-To: <20190213203033.GB31743@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "'Tobin C. Harding'" <me@tobin.cc>
Cc: "'Tobin C. Harding'" <tobin@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Tobin C. Harding
> Sent: 13 February 2019 20:31
>=20
> On Wed, Feb 13, 2019 at 03:56:47PM +0000, David Laight wrote:
> > From: Tobin C. Harding
> > > Sent: 07 February 2019 22:50
> > >
> > > Currently if user passes an output file to the script via
> > > --output-raw we do not handle expansion of tilde.
> > >
> > > Use perl function glob() to expand tilde in output file name.
> >
> > What happens if glob() returns multiple files?
> > I'm guessing that it can...
>=20
> Thanks for taking a look at this David.  Surely glob() cannot return
> multiple values when expanding tilde?  If someone passes a '*' into the
> command as an input/output file then they are clearly mad :)

Yes, but the perl script will go horribly wrong.

Actually, how do they get a ~ in there?
Whatever shell generated perl's argv[] would be expected to handle it.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)
