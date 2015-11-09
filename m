Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <c3c5f9857a782b1d4405272f08ce5b3d@opensec.fr>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com> <n1iirh$q7o$1@ger.gmane.org> <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com> <n1khkt$lc7$1@ger.gmane.org> <87h9kvze0o.fsf@rasmusvillemoes.dk> <20151109103315.GB19735@chrystal.uk.oracle.com> <87bnb3ou1c.fsf@rasmusvillemoes.dk> <CAGXu5jLST1eoNU3YF-kLnTOHcq6iyD8YbS=oGr+3p2eFsz-X=A@mail.gmail.com>
 <c3c5f9857a782b1d4405272f08ce5b3d@opensec.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1447107624_2452P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 09 Nov 2015 17:20:24 -0500
Message-ID: <29498.1447107624@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Binary blobs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1447107624_2452P
Content-Type: text/plain; charset=us-ascii

On Mon, 09 Nov 2015 22:59:31 +0100, HacKurx said:
> The binary blobs are a potential for undetectable or irreparable
> security flaws (Andrews Jeremy "Interview: Theo de Raadt", KernelTrap).
>
> What is your point of view? Linux-libre kernel is the only reliable
> basis?

Closed source is by definition not easily examined for security issues (though
once you get to monsters like LibreOffice or Firefox, even open source code
is difficult to audit).

The problem is that at the current time, not all software is easily opened. For
example, the single biggest reason (among several) that NVidia has a binary
blob driver is that (simplifying *drastically* here) when SGI's graphics
division imploded, NVidia got all the engineers - but Microsoft snarfed up a
bunch of patents connected to OpenGL.  So NVidia had no realistic choice but to
license the intellectual property from Microsoft.

So out in the real world, you have to look at your threat model, and decide
how paranoid you are.  (Personally, I'd be more worried about the open-sourced
Firefox code than I would the NVidia binary blob.  The former has got a *huge*
attack surface compared to the latter....)

--==_Exmh_1447107624_2452P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVkEcKAdmEQWDXROgAQI7Gg/8D2BNUqIA+y63CykHA1ySFINIw0lopHIl
Mh7U2FECilAqkbU8MCj8wZU8JbLf6j6rfm/zbpwZSdqotYLc+Z2BNX+isWbUsY+I
vt6yOkvN2fzbgaKHAHotMAmNKkDt148rr7m7ySn92CUJpbCJRIP6pu1nY+kMnbhb
TR8+ucg/9wpQNH9VUHyr9xVfiRIAlYYD9sVSCRiZFFD8XtCx/OIZ37AnIEMs4vyg
HSkKmVyLc9biMjRZZ0BBg3bTs+TACNtTl8wb/TMIv6PRugsnAtazblBxwgCIp4Hw
F25LYlu7Q5vK0Hi2OYOimKFpAsDAZvDkvzf4S/BdYh2viGadth5ikPA9UPm6nmIN
S9Cur+ziNAfOZ6lyn2uJtgDaf4hOuHWMeMIa7B7a4ss7ISCTsJkUL3X/jmAw59TZ
pNQW6fBx+beKSIQqDzDFm3eo3YmavA8Uy/FrRd1JXG8E1CsK6WxQO8fhyzuL8CWs
VnbIJOJQtNQbhC+H8WTK2lONpKkL/Xb9J3ZiAVOb4U93kgeSo4s5yAkbtqeoKYbi
bY6HHh80nA2K37VQwuhv4W4tZ8gjqfFdLYZfM9bolSf5OuUsMR0nMrzeMAAxNsk/
WcjrRDwhTg9KdCICCT7gNsRvmM7nJzkJlZUG/x7zuz0Bpz7lGVBngkYGiWhkQvx9
cE/Lg5yeO6Q=
=Gtjt
-----END PGP SIGNATURE-----

--==_Exmh_1447107624_2452P--
