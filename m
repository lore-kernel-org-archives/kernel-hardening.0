Date: Sat, 3 Jun 2017 10:21:10 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20170603142110.GA7578@grsecurity.net>
References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <1496498027.22395.1.camel@gmail.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Daniel Micay <danielmicay@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

commit 813d0df7042a8430481d245618cbab39b76876fc
Author: Brad Spengler <spender@grsecurity.net>
Date:   Sat Jul 25 11:28:15 2015 -0400

    Implement modify_ldt sysctl toggle from https://lkml.org/lkml/2015/7/25=
/103,
    make it not depend on CONFIG_MODIFY_LDT_SYSCALL, force modify_ldt to off
    regardless of config setting if grsec is enabled (with the allowance to
    turn it on at runtime), and harden up the implementation a bit
   =20
    Conflicts:
   =20
        arch/x86/Kconfig
        kernel/sysctl.c


It's right there in the changelogs (which you can still find online).  Here=
's a
google cache entry for the link:
https://webcache.googleusercontent.com/search?q=3Dcache:2IlruFKV2RIJ:https:=
//lkml.org/lkml/2015/7/25/103+&cd=3D1&hl=3Den&ct=3Dclnk&gl=3Dus
I did not and have never removed someone's copyright notice and added my
own to the copy+pasted code, as is the case of what's happening here
that I'm complaining about and that I had to complain about in the past
when Intel did it.

Unlike you and the KSPP, our security reputation isn't entirely based on
the work of others.  If properly crediting work is such a difficult problem
that you don't want to be bothered with, there's a very simple solution:
come up with your own ideas and write your own code!

-Brad

On Sat, Jun 03, 2017 at 09:53:47AM -0400, Daniel Micay wrote:
> > "a value linux-hardened and grsecurity have used for a long time now"
> > Rik, you're giving credit to a project that didn't even exist a couple
> > weeks ago, yet they've somehow used it "for a long time", even though
> > it only exists there because it was copy+pasted from grsecurity?
>=20
> You're going out of the way to misinterpret that wording.
>=20
> You don't document where changes came from in the PaX and grsecurity
> patches. There's code written by other people in there, and there's
> neither a Git repository crediting them in a commit history or with a
> few exceptions inline credit given to those people. When I extract
> something from the PaX or grsecurity patches or base code on the ideas
> there, I can't state with certainty who authored the code. I've been
> stating 'extracted from PaX' or 'extracted from grsecurity' for code not
> part of PaX and documenting changes from the implementation there. Code
> being from PaX or grsecurity isn't necessarily 'code authored by the PaX
> Team or Brad Spengler'. It could be code written by Emese, minipli,
> someone else who contributed code to you or a patch that you took from
> elsewhere that was ignored / rejected by upstream. How is anyone else
> supposed to know?
>=20
> People were given credit in the original PaX changelogs at the top of
> the patches in most cases but all but the latest patch for kernel
> branches was taken down. Similarly, the grsecurity changelogs gave
> credit but are all taken down and it's not like many people actually
> looked at those at the time.
>=20
> For example, the MODIFY_LDT sysctl in grsecurity is someone else's code.
> It isn't stated in grsecurity where it came from. That's true to an even
> larger extent when it comes to ideas rather than implementation. You
> give credit to Willy Tarreau for NO_SIMULT_CONNECT but not that
> MODIFY_LDT one, and I can think of a bunch of other examples.
>=20
> It looks to me like people contributing these changes upstream have been
> more consistently giving credit than the grsecurity patches do. When the
> grsecurity patches are not mentioning who wrote changes or came up with
> the idea how are people supposed to know who to credit... ? It applies
> to an even larger extent to ideas rather than code. Most of the code and
> ideas there are from the PaX Team and yourself, sure, but not all.
>=20
> Maybe stop calling me a plagiarist when I'm trying my best to give
> credit and actually do a better job than you do in practice.
>=20
> >   Is
> > that what we do now, credit plagiarists instead of the actual authors
> > of
> > the work?  Sorry, but the "work" of struggling to understand code that
> > isn't yours doesn't suddenly make it your code.
>=20
> These commits reference the PaX implementation there. You've told me to
> stop doing that but rather reference the specific PaX version in the
> future which I intend to do.=20
>=20
> https://github.com/thestinger/linux-hardened/commit/4c355f98910e01256ee2b=
01dd1a02ac08dd316b2.patch
> https://github.com/thestinger/linux-hardened/commit/711e5650589c9d3c99706=
c6a5d52d2659519dc74.patch
> https://github.com/thestinger/linux-hardened/commit/cd9cdbff4bc69d2e88b37=
d106e6ee8ef33a3a1b8.patch
>=20
> The Linux kernel is GPL2 and grsecurity is a derivative work. I'm not
> sure how it's plagiarism to tweak the upstream implementation of ASLR
> based on the PaX implementation while describing the differences with
> the PaX implementation which I'm trying to do in depth:
>=20
> Making the stack entropy depend on the mainline mmap sysctl isn't based
> on PaX and therefore doesn't reference it.
>=20
> I needed to move the ET_DYN base on arm64 to 4G because the address
> range overlapped when using the sysctl for the stack which I noticed in
> testing. I then did x86_64 and the 32-bit architectures. I don't know
> how the values were chosen in PaX and they don't meet the compatibility
> requirements that I need on 64-bit where there are projects using 32-bit=
=20
> pointers by mapping certain things in the lower 32 bits of the address
> space and they cannot necessarily cope with any fragmentation there.
>=20
> https://gist.github.com/thestinger/b43b460cfccfade51b5a2220a0550c35

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJZMsXPAAoJEETRwPglJf5JgqkP/3dBt7M1/Aj0Ea4VzprfwJpq
8HAEx2RlwQhq1Dp0FjUjxAR8sRaZ5yamRVyc9URgukAK6guTiV1eRLfSW+eAajKj
Ul4QnkquWy8aj/0IBCjy6ruQN0cJ6kAleLFSbeV0T7XWm8EHYd0eDWM1yjpeI7DV
eBgSMJNy09JXR6WO7CxY5Y3rgO43yU7M+oCoGsHrk+efssiDT3nwPXMXHrV/qJ5W
4pEL522os5lBW44ZHJCHeCoaQ3Wvo2bvF0G9jCPB0aHJ7t5nM9NE6HsqM5IVKjeq
qrDxlioW2CL/CovlEgo8pQdtb972pcYBF/zdujdHgrmTqrfjHMOQ8U9rldKEEKnL
tJuw6wLV8q4ShSkmG4xhlUaic9P2MJaQlg4TU32sVaRQmVcafW5i0odRJCSPAIim
Xt3J1YMkkkprO5D2tSa3nnN2qiYtmepuhOLyM55Ux4UZ6D3SoaylwNTQLMiQDQOd
82mrL4iMOx4P/UJWUcWlRWFRI/l6eVoaqZhIaPvk6rOjRvlkg+hWF+VIQC1TcoKE
06dSMNMFIKV7AYKJtG3JR7xbujZzgTODUAl9ePsIU5XrTYUieRDrqV5VUbNoWARV
Du8l+9RZZ+iu8HCEKP3ShCi+eRtDHcjCAH3oUQsFaFtbEUboKkZYA2HXNYvsQylK
v9bo6yFhmJIrKgSiXbFM
=WyF8
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
