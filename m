Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 14:14:50 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161031131450.GA2836@pc.thejh.net>
References: <14b76703-8185-dadb-7605-10496331452c@redhat.com>
 <20161031112236.GA6816@openwall.com>
 <1477914064.3558.4.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <1477914064.3558.4.camel@gmail.com>
Subject: Re: [kernel-hardening] Re: Stack guard canary massaging
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[-CC oss-security, this is just about kernel stuff]

On Mon, Oct 31, 2016 at 07:41:04AM -0400, Daniel Micay wrote:
> On Mon, 2016-10-31 at 12:22 +0100, Solar Designer wrote:
> > On Mon, Oct 31, 2016 at 11:48:45AM +0100, Florian Weimer wrote:
> > > Sorry for cross-posting.
> >=20
> > Sorry to bikeshed, but I think this isn't a kernel-hardening topic at
> > all, so the thread should continue on oss-security only, please.
> >=20
> > Florian, if there's a reason why you think it's kernel-hardening
> > related, please let me know.=A0=A0To me, it looks like userspace harden=
ing
> > that is not even kernel-assisted (at least not directly in this place,
> > even though the kernel may have helped provide the random numbers).
> >=20
> > If your cross-posting was to reach more of the right people, then you
> > have already done so, and they can join oss-security now. ;-)
> >=20
> > Alexander
>=20
> The kernel supports SSP but it doesn't appear to do the same thing.
>=20
> arch/*/include/asm/stackprotector.h
>=20
> Why do the non-x86 implementations XOR in LINUX_VERSION_CODE though? Is
> it supposed to be a placeholder for a random at compile-time value? :\

Only for the init task though.
For the others, it's chosen in dup_task_struct() (in kernel/fork.c),
using get_random_int() - which returns a 32-bit number, either straight
=66rom RDRAND or from an MD5-based RNG using percpu state.

As far as I can tell, this means that the init task is the only one
that can have a 64-bit canary (e.g. on amd64); all the others have
canaries where the more significant half is all zeroes. Although
bruteforcing 32 bits isn't exactly easy, this should probably be fixed.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYF0PKAAoJED4KNFJOeCOogKwQANWpcCY+h5U7E6to/I322kBz
us/8yOp5q2hA1t7hfTjyFJVuuNwt3omVyn15k9t+ahImGdFoSdijyrHV/qHsm5ya
ssU1luBRUk0wqpRecTAjon/RLjN96gMHcu/giiVUChwdc0McF11UrgkCHZTZEht/
2vdBcIevhqS1k37KCuHzCwHSaK58thAXhl/yopGK0B8jspecs4SW5uqO3O+3zfgF
cO+Q7NwZ2eoEGU6E9Gw+LUSj90ntlpksKmQsSsEkWHsyeFED0FcbTNqq1zmYdb7Q
rfHnlxP97MB7MfpvVE/fRivyYYgKY2/4tDgnjTvmKeAFLcuP22lI/7xnQBsR9cC3
AhnR7HxfXJfMlpKVB438PyXNYZ6jykdm1D9/OHuuqQ5C6qCXr4dQEAx4DlDIt6ki
eHAbdNA1FYhBBL8vgEhcuGLRf/rqfiYMzoUsVzTGwQlO+s7CihWYwaXyfEOfH805
x6B3ElRxfJY8Yi40YK8NnDCzQyw2gVOM+LK6RkDZ+dG9FKMsGtpqVD7xuzrfhg3F
MwA9r5kYU8GiX/IUY4OY6IgWXQ7BpsVWY7DAERcdIPHdYpIwqJSABAtXFeEfZjwG
tcj7xccXQ/ZMy3bquE81xxE7O0fujTf/z5OX4Xiy+Z9vdw0HNfYFAN+ZY6XIJYZb
h7occbLANa++t0GeqZDU
=PZ0D
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
