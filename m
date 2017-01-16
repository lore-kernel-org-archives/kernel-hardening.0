Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1484593697.1277.7.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 16 Jan 2017 14:08:17 -0500
In-Reply-To: <20170116152425.GG5908@leverpostej>
References: <20170113220256.GA57663@beast>
	 <5879F762.32059.37092152@pageexec.freemail.hu>
	 <20170116152425.GG5908@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-uAH36+THkXAWkukf+KRF"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack
 initialization
To: Mark Rutland <mark.rutland@arm.com>, PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>


--=-uAH36+THkXAWkukf+KRF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2017-01-16 at 15:24 +0000, Mark Rutland wrote:
> Hi,
>=20
> On Sat, Jan 14, 2017 at 11:03:14AM +0100, PaX Team wrote:
> > On 13 Jan 2017 at 14:02, Kees Cook wrote:
> >=20
> > > +config GCC_PLUGIN_STRUCTLEAK_VERBOSE
> > > +	bool "Report initialized variables"
> > > +	depends on GCC_PLUGIN_STRUCTLEAK
> > > +	depends on !COMPILE_TEST
> > > +	help
> > > +	=C2=A0=C2=A0This option will cause a warning to be printed each
> > > time the
> > > +	=C2=A0=C2=A0structleak plugin finds a variable it thinks needs to
> > > be
> > > +	=C2=A0=C2=A0initialized. Since not all existing initializers are
> > > detected
> > > +	=C2=A0=C2=A0by the plugin, this can produce false positive
> > > warnings.
> >=20
> > there are no false positives, a variable either has a constructor or
> > it does not ;)
>=20
> ... or it has no constructor, but is clobbered by a memset before it
> is
> possibly copied. ;)
>=20
> For example:
>=20
> arch/arm64/kernel/fpsimd.c: In function 'do_fpsimd_exc':
> arch/arm64/kernel/fpsimd.c:106:12: note: userspace variable will be
> forcibly initialized
> =C2=A0 siginfo_t info;
>=20
> ... where the code looks like:
>=20
> void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
> {
> 	siginfo_t info;
> 	unsigned int si_code =3D 0;
>=20
> 	if (esr & FPEXC_IOF)
> 		si_code =3D FPE_FLTINV;
> 	else if (esr & FPEXC_DZF)
> 		si_code =3D FPE_FLTDIV;
> 	else if (esr & FPEXC_OFF)
> 		si_code =3D FPE_FLTOVF;
> 	else if (esr & FPEXC_UFF)
> 		si_code =3D FPE_FLTUND;
> 	else if (esr & FPEXC_IXF)
> 		si_code =3D FPE_FLTRES;
>=20
> 	memset(&info, 0, sizeof(info));
> 	info.si_signo =3D SIGFPE;
> 	info.si_code =3D si_code;
> 	info.si_addr =3D (void __user *)instruction_pointer(regs);
>=20
> 	send_sig_info(SIGFPE, &info, current);
> }
>=20
> ... so it's clear to a human that info is initialised prior to use,
> though not by an explicit field initializer.

It's obvious to the compiler too, not just a human. The compiler can
optimize it out when it's so clearly not required, although translation
units will get in the way without LTO. There's existing sophisticated
analysis for automatic initialization with full coverage. That's part of
why I think it makes sense to have a toggle for heuristics vs. full
coverage (incl. non-function-scope locals, that's just a heuristic too).

> > > +/* unused C type flag in all versions 4.5-6 */
> > > +#define TYPE_USERSPACE(TYPE) TYPE_LANG_FLAG_5(TYPE)
> >=20
> > FYI, this is a sort of abuse/hack of tree flags and should not be
> > implemented this
> > way in the upstream kernel as it's a finite resource and needs
> > careful verification
> > against all supported gcc versions (these flags are meant for
> > language fronteds, i
> > kinda got lucky to have a few of them unusued but it's not a robust
> > future-proof
> > approach). instead an attribute should be used to mark these types.
> > whether that
> > can/should be __user itself is a good question since that's another
> > hack where the
> > plugin 'hijacks' a sparse address space atttribute (for which gcc
> > 4.6+ has its own
> > facilities and that the checker gcc plugin makes use of thus it's
> > not compatible
> > with structleak as is).
>=20
> To me, it seems that the __user annotation can only be an indicator of
> an issue by chance. We have structures with __user pointers in structs
> that will never be copied to userspace, and conversely we have structs
> that don't contain a __user field, but will be copied to userspace.
>=20
> Maybe it happens that structs in more complex systems are more likely
> to
> contain some __user pointer. Was that part of the rationale?
>=20
> I wonder if there's any analysis we can do of data passing into
> copy_to_user() and friends. I guess we can't follow the data flow
> across
> compilation units, but we might be able to follow it well enough if we
> added a new attribute that described whether data was to be copied to
> userspace.
>=20
> Thanks,
> Mark.


--=-uAH36+THkXAWkukf+KRF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlh9GiEWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKhlrD/9R5Ec1AAHYKAuPOSNzxneGPVD0
3saZHvqp86Ie25DkfXzyJ2Beg6CvqXWg7BIdP1dMTZRDj9iesdtjTdtCn1hI6jj5
9KsF7XRmyU/9zOHkEcVH1aUOZvfiZG2NDnXc1Y5524Wnq841gNetfv9HkpwQVMdC
JtElW0dZPr5X8OD5V1S8kieu2iiToagPGaubw83y0v6o4u0xuv5oSUsvh4sh5CWM
PLGOqIq9ypTXijW2pDv+wsH663Mh+NkkG74GCeFtCym3HzbFDPdlfb/Tp6Bk0xzu
rcpI+P9gmsjhOpTHjaZL01L323V3TR4afKsCFXSw4gKDHlEWx7PTHJ/ANHsu6nch
LnmH4a/CvVOYj7TM7mlGl6TfC9ZDAWksEnMQV4jJ1dcljZf2H40OFABdaL9lffa6
nSeifOLwPkzlUCc9FHJUfNX/JTy2J0jF2vd91PVFmw3crOGB3NhCVV+xp3+IEiU+
oHp+JId1hxoD6KCx/6DqK6M0l6jPdEAMcx3bzwbiq1yBiFC5nuCtX8Kpts4FbkDG
lontss+AHeOTX6+pWVnJd1eki1eAZG0B7xegHRIjsGLlMXrzZSCRpXGIsei9/bmy
GIAnUAAwtgZVxVp15cAgIffDE6adMDGWO9znxz+gz0gjS+OBqf3Th3S/U0iDIF7y
h5BpgoTiDODvGvj3sA==
=qQyc
-----END PGP SIGNATURE-----

--=-uAH36+THkXAWkukf+KRF--
