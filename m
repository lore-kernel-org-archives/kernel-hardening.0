Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477951334.8761.15.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 18:02:14 -0400
In-Reply-To: <8760o8ryh3.fsf@mid.deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	 <20161031162918.GA2994@pc.thejh.net> <87mvhks0vs.fsf@mid.deneb.enyo.de>
	 <1477947388.8761.3.camel@gmail.com> <1477947674.8761.4.camel@gmail.com>
	 <87ins8rzqm.fsf@mid.deneb.enyo.de> <1477948871.8761.9.camel@gmail.com>
	 <8760o8ryh3.fsf@mid.deneb.enyo.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-8kaCEivm//HN2xHpycpf"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-8kaCEivm//HN2xHpycpf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-31 at 22:38 +0100, Florian Weimer wrote:
> * Daniel Micay:
>=20
> > -fstack-stack is supposed to handle a single guard by default, and
> > that's all there is for thread stacks by default.
>=20
> Okay, then I'll really have to look at the probing offsets again.
> It's been on my to-do list since about 2012, and arguably, it *is* a
> user-space thing.

This is concerning too:

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D66479

It might be prevented for VLAs by using -fsanitize=3Dvla-bound -fsanitize-
trap=3Dvla-bound but probably not alloca (or the older -fsanitize-
undefined-trap-on-error for GCC,  since for some reason it doesn't seem
to have the new way).

> And I just realized that we should probably fail at dlopen time if
> some tries to open a DSO which needs an executable stack, rather than
> silently changing all thread stacks to executable. *sigh*
>=20
> > > > Note: talking about userspace after the entropy bit. The kernel
> > > > doesn't
> > > > really -fstack-check, at least in even slightly sane code...
> > >=20
> > > =C2=A0
> > > There used to be lots of discussions about kernel stack sizes ...
> >=20
> > It should just be banning VLAs, alloca and large stack frames
> > though, if
> > it's not already. There wasn't even support for guard pages with
> > kernel
> > stacks until recently outside grsecurity,
>=20
> Which is not surprising, considering that one prime motivation for
> small stacks was to conserve 32-bit address space.=C2=A0=C2=A0But I'm gla=
d that
> there is now a guard page.=C2=A0=C2=A0Hopefully, it does not affect perfo=
rmance,
> and on 64-bit, at least there isn't the address space limit to worry
> about.

I think it might actually improve performance overall.

> > and -fstack-check relies on them so it doesn't seem like a great
> > solution for the kernel.
>=20
> -fsplit-stack could enforce stack usage limits even without guard
> pages, but of course, there is some run-time overhead, and the limit
> has to come from somewhere (typically the TCB).

Yeah, that's how Rust provided stack safety on LLVM. They ended up
removing it and they only have stack safety on Windows now, since LLVM
doesn't yet provide stack probing outside Windows. So much for being a
memory safe language... it's ultimately LLVM's fault though. There were
actually working patches submitted for this by people working on Rust
but *it never landed* due to endless bikeshedding + scope creep.
--=-8kaCEivm//HN2xHpycpf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYF79mFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ip3dRAAlpp4GTtBXV/IyTSNPblsT7zzfLzk1nXCyGZz0LBHqLV83JviArHWCLny
20v8iKMPtK1QvJ7kTpP57Jqu6DR0CPgpL9JO10ydwZBUuYELUDgpQRaf8L9K3Kra
JmZBXG2Hr6FGc7D4rB2Zpwo9LqN8TyJjhLD6L+rGRn6+Uit7BGoIPVLyqMOJhosT
CWqkJrNHG9bMciEPJW7y9msEBjesFGFVxrwh5fDfY3+ADt8S9s5vBpHY28oVuNN+
XbKXsRQJ03bCKLP9KsxuGH5Uztv+W+qJGBPJGKmoaAUh8BIbYDE1aw8duiQfUQuy
HMlBGUwatl8GQFYrRBvEB0dYUvSANVkOvdavF39BQq8reaiKbeFm7bu4qZQCuX3d
BBuGMN8a3RivPD/qr1ei+mqGabenTE5oLpPQJD+8TmHFukqAxqWPU5tFNfJjPfoG
yciIy9/izoBtrQgYIo+A27vwEW9v6yGBgc9BGgWVBb8OUHuBa/wq64ZzaWrbauQu
N1Crca+T+PC8at+bJK7IAZmqRIcI8jawBcfrVLXDL8koLP17DrlPW1Voj2V7fW2I
18aVV1vmi0sp7Y1TG9V6g5MpIlemM7dQTX6XIfmmEfmk2GeV2NKGSJBXC/Rrvr2P
3/JJ4b2mCCtPDQlExUQDhBxLDhmzVyyEvS3HOV8LRhmHnjLGnRQ=
=rep3
-----END PGP SIGNATURE-----

--=-8kaCEivm//HN2xHpycpf--
