Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1481846720.1054.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 15 Dec 2016 19:05:20 -0500
In-Reply-To: <20161215211807.GA13393@kroah.com>
References: <20161214185000.GA3930@kroah.com>
	 <20161214185052.GC4939@kroah.com>
	 <20161214202952.GV1555@brightrain.aerifal.cx>
	 <20161214205444.GA16183@kroah.com> <20161215175439.GA1172@kroah.com>
	 <1481835061.3477.5.camel@gmail.com> <20161215211807.GA13393@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/ttJtP+9hgkQLxW00/Ep"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 3/4] Make static usermode helper
 binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-/ttJtP+9hgkQLxW00/Ep
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Thanks for the explanation.=C2=A0=C2=A0I don't think we need to worry abo=
ut
> merging these strings, but I'll keep it in mind.
>=20
> However, the "folklore" of the kernel was to never do:
> 	char *foo =3D "bar";
> but instead do:
> 	char foo[] =3D "bar";
> to save on the extra variable that the former creates.=C2=A0=C2=A0Is that=
 no
> longer the case and we really should be using '*' to allow gcc to be
> smarter about optimizations?
>=20
> > The 'const' qualifier for pointers doesn't really do anything, it's
> > when
> > it's used on the variable (after the pointer) that it can do more
> > than
> > acting as a programming guide.
>=20
> Many thanks for the explanations,
>=20
> greg k-h

Can see what the compiler has to work with pretty easily from LLVM IR:

    char *const constant_string_constant =3D "string";
    char *const constant_string_constant2 =3D "string";
    char *non_constant_string_constant =3D "string";
    char *non_constant_string_constant2 =3D "string";
    char non_constant_string_array[] =3D "string";
    char non_constant_string_array2[] =3D "string";
    const char constant_string_array[] =3D "string";
    const char constant_string_array2[] =3D "string";

Becomes:

    @.str =3D private unnamed_addr constant [7 x i8] c"string\00", align 1
    @constant_string_constant =3D constant i8* getelementptr inbounds ([7 x=
 i8], [7 x i8]* @.str, i32 0, i32 0), align 8
    @constant_string_constant2 =3D constant i8* getelementptr inbounds ([7 =
x i8], [7 x i8]* @.str, i32 0, i32 0), align 8
    @non_constant_string_constant =3D global i8* getelementptr inbounds ([7=
 x i8], [7 x i8]* @.str, i32 0, i32 0), align 8
    @non_constant_string_constant2 =3D global i8* getelementptr inbounds ([=
7 x i8], [7 x i8]* @.str, i32 0, i32 0), align 8
    @non_constant_string_array =3D global [7 x i8] c"string\00", align 1
    @non_constant_string_array2 =3D global [7 x i8] c"string\00", align 1
    @constant_string_array =3D constant [7 x i8] c"string\00", align 1
    @constant_string_array2 =3D constant [7 x i8] c"string\00", align 1

And with optimization:

    @constant_string_constant =3D local_unnamed_addr constant i8* getelemen=
tptr inbounds ([7 x i8], [7 x i8]* @constant_string_array, i64 0, i64 0), a=
lign 8
    @constant_string_constant2 =3D local_unnamed_addr constant i8* geteleme=
ntptr inbounds ([7 x i8], [7 x i8]* @constant_string_array, i64 0, i64 0), =
align 8
    @non_constant_string_constant =3D local_unnamed_addr global i8* getelem=
entptr inbounds ([7 x i8], [7 x i8]* @constant_string_array, i64 0, i64 0),=
 align 8
    @non_constant_string_constant2 =3D local_unnamed_addr global i8* getele=
mentptr inbounds ([7 x i8], [7 x i8]* @constant_string_array, i64 0, i64 0)=
, align 8
    @non_constant_string_array =3D local_unnamed_addr global [7 x i8] c"str=
ing\00", align 1
    @non_constant_string_array2 =3D local_unnamed_addr global [7 x i8] c"st=
ring\00", align 1
    @constant_string_array =3D local_unnamed_addr constant [7 x i8] c"strin=
g\00", align 1
    @constant_string_array2 =3D local_unnamed_addr constant [7 x i8] c"stri=
ng\00", align 1

If they're static though, the compiler can see that nothing takes the
address (local_unnamed_addr =3D=3D unnamed_addr if it's internal) so it
doesn't need separate variables anyway:

    static char *const constant_string_constant =3D "string";
    static char *const constant_string_constant2 =3D "string";

    char *foo() {
      return constant_string_constant;
    }

    char *bar() {
      return constant_string_constant2;
    }

Becomes (with optimization):

@.str =3D private unnamed_addr constant [7 x i8] c"string\00", align 1

; Function Attrs: norecurse nounwind readnone uwtable
define i8* @foo() local_unnamed_addr #0 {
  ret i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0)
}

; Function Attrs: norecurse nounwind readnone uwtable
define i8* @bar() local_unnamed_addr #0 {
  ret i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i64 0, i64 0)
}

So for statics, I think `static const char *` wins due to allowing
merging (although it doesn't matter here). For non-statics, you end up
with extra pointer constants. Those could get removed, but Linux doesn't
have -fvisibility=3Dhidden and I'm not sure how clever linkers are. Maybe
setting up -fvisibility=3Dhidden to work with monolithic non-module-
enabled builds could actually be realistic. Expect it'd remove a fair
bit of bloat but not sure how much would need to be marked as non-hidden=
=20
other than the userspace ABI.
--=-/ttJtP+9hgkQLxW00/Ep
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlhTL8EWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKk/EEACVV13/COxQIwYbN63liowl0TmN
oyIkISr0UO6EgnIa3nXPxyUjHrq0Hezwr3lE9cTR+eKMLU2vJGC0mg8nilLqP7f4
pFYt/A3Zb8U5QYtGwXUzAGV4fIWDrXkLsiaI08qP5btfQpXgZeqPeuvPBRNE2acr
E+JwlRAIYnAbfTaKOV61BtuIWNMnb8mUFP9Qm3ClP7fewP0YzqeHXHb1Oa2yaHPf
EbaSDVNwQjNMD3AllYBlEbshB21dryYPzkQyxOt/jhwHGcBGWjrdmo/QLRXY1csx
LNgJ1WiRrb7FdiPyib5sPoHxePGIKFzs4O2Dael30q8VryPDnJqXqvpQ8LljQQwj
vCH+tjPsFDiTxC0H+JV7iSI1b3rE1+XsyszkjhaMfE3nmAUNOC5PCqyFywYF62qz
KEeHn4f6KhxLZNatzlpu+HwtZDVDYPvh+2LJRL3Z7bgCfI2MHe2ZfsHQCzT86Imn
joncHs5t0gWAjbBPzuRxK9HJzOrR709BJyaAWM4oYO7GFaXWX93cNPMgTt5UkezY
cQ6hROi/GOdA4TSjkbvAGRCftE0BGpRXhT46iWw6J9AmTQ0INyBmKQnKNw9ylys5
fa+2VuFUUgGHmZ1PJHSEE7OikEGriJQcjN52CGfNV2O7UjGgHYkzrE6kl9FIycDP
8+afUy/jzkvTYAb0dA==
=gr2E
-----END PGP SIGNATURE-----

--=-/ttJtP+9hgkQLxW00/Ep--
