Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470330603.22643.120.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 13:10:03 -0400
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC560127DD18@ORSMSX103.amr.corp.intel.com>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
	 <1470329589.22643.117.camel@gmail.com>
	 <476DC76E7D1DF2438D32BFADF679FC560127DD18@ORSMSX103.amr.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-w48tkvJV4vAmt1j2rHCW"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH] [RFC] Introduce mmap randomization
To: kernel-hardening@lists.openwall.com, "jason@lakedaemon.net" <jason@lakedaemon.net>, "linux-mm@vger.kernel.org" <linux-mm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "nnk@google.com" <nnk@google.com>, "jeffv@google.com" <jeffv@google.com>, "salyzyn@android.com" <salyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-w48tkvJV4vAmt1j2rHCW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-08-04 at 16:55 +0000, Roberts, William C wrote:
> >=20
> > -----Original Message-----
> > From: Daniel Micay [mailto:danielmicay@gmail.com]
> > Sent: Thursday, August 4, 2016 9:53 AM
> > To: kernel-hardening@lists.openwall.com; jason@lakedaemon.net;
> > linux-
> > mm@vger.kernel.org; linux-kernel@vger.kernel.org; akpm@linux-
> > foundation.org
> > Cc: keescook@chromium.org; gregkh@linuxfoundation.org; nnk@google.co
> > m;
> > jeffv@google.com; salyzyn@android.com; dcashman@android.com
> > Subject: Re: [kernel-hardening] [PATCH] [RFC] Introduce mmap
> > randomization
> >=20
> > On Tue, 2016-07-26 at 11:22 -0700, william.c.roberts@intel.com
> > wrote:
> > >=20
> > > The recent get_random_long() change in get_random_range() and then
> > > the
> > > subsequent patches Jason put out, all stemmed from my tinkering
> > > with
> > > the concept of randomizing mmap.
> > >=20
> > > Any feedback would be greatly appreciated, including any feedback
> > > indicating that I am idiot.
> >=20
> > The RAND_THREADSTACK feature in grsecurity makes the gaps the way I
> > think
> > would be ideal, i.e. tracked as part of the appropriate VMA. It
> > would be
> > straightforward to make it more general purpose.
>=20
> I am not familiar with that, thanks for pointing it out. I'll take a
> look when my time
> frees up for this again.

I'm actually wrong about that now that I look more closely...
--=-w48tkvJV4vAmt1j2rHCW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXo3brFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ir4sQ/+J7vshcVOCjv7eE9xQWMcYMOS4mwHre0mxtQoJXW0HR2Eb7v7sscuz/sC
j26WbxmHOe23hkFKSGlXrLNzCBOH3lEKxChclH1Cp3dUBpaUd6vT1Ws7SMcnDxR0
SQSjnDNtuZcy+XvtSBDosU+tosptWlcD67ZkH4J9Qln2jWTpS2Krz4T+Ju5ejhMJ
HPYTT++Y6sZ1pu7ciYebo4LtjQonDb0P8NG6NJaTLciHI0e8hjB1WdcBBZp8OR8b
kbcNoIrLhRd+6YYLoCZazJXrYMv0rLcMQxL6HjRojsKAG4JIh/yEwFuZbkUT2TE5
b6nT8WGYjlpo5RiTPcuaMfNGYdayymh5S4uIqom6drR6sd0Jy/mIfxkWRyycNZuj
VIF35CHJwenqK+CqVqLVl1c0HX6FAN5HyaaFzlFWgb4F0t/kXyQ37NDPMYIrZ+6P
BrNJ6/c3qBCvpYbyb3n/P7MChOdzItHGDE6WoeA4s3CXAdMSI0wSiuiMfC4PoCkZ
VutgmuJ21WsHIw4Nnn0Vinv7do7xhXdnYfglrGaMAfNzeL3yje1cgTNJHL7zV3vb
9FE5CXuQCzaTv50LMBzOcIKT3MEOsQvu1Gck6GC9h1A7lrZqlZID7TIaPaHYO5oD
u+FIQfxV+Ff+TvsX605ht4gzm7IY+JwIn2cAUKWvvJASUEnMkGE=
=x0PY
-----END PGP SIGNATURE-----

--=-w48tkvJV4vAmt1j2rHCW--
