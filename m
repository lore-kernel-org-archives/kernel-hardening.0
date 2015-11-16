Reply-To: kernel-hardening@lists.openwall.com
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
 <CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Message-ID: <56496AB0.5070905@gmail.com>
Date: Mon, 16 Nov 2015 00:33:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kWN9fOaUiggIhWukvlxMSoLBjTENPi7G3"
Subject: Re: [kernel-hardening]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kWN9fOaUiggIhWukvlxMSoLBjTENPi7G3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 15/11/15 03:59 PM, Richard Weinberger wrote:
> On Fri, Nov 13, 2015 at 4:43 PM, west suhanic <west.suhanic@gmail.com> =
wrote:
>> Hello All:
>>
>> I am a hardened gentoo user. How can we get the grsecurity code into t=
he
>> kernel?
>=20
> As soon all downsides and drawbacks are identified/resolved.
> Which basically means that we have to redo a lot (it not all).

You might not be familiar with the grsecurity/PaX features and their
implementations but lots of people are. It's not unexplored territory
without known trade-offs. It has active developers who are happy to
answer questions about it (within reason).

I think there's little that would need to be redone. There are many
things that would need to be renamed and refactored in order to present
them in a different light to deal with political issues. One good way to
upstream stuff would be presenting it from the angle that it's useful
for finding kernel bugs for *everyone* and just accepting that some of
it is going to be misrepresented (i.e. CONFIG_DEBUG_*).

Approaching this as if it's a technical issue is only going to lead to
failure. I really can't see Linus and others being okay with any GCC
plugins with alterations to the semantics of C rather than just codegen
like the KERNEXEC plugin. Dropping time into extracting stuff like that
rather than realistic things seems wasteful. If someone puts in the
effort to do it, submits it and hits a wall then I wouldn't expect them
to be motivated to do more.

I think there's plenty that could be landed but going directly upstream
may not be the way to go. I was considering spending time on doing most
of the small features and submitting them to AOSP. No politics to deal
with there, only technical issues. If something lands there, it becomes
a lot easier to upstream it because it becomes part of trying to get
Android to use a vanilla kernel. Android wants security features and
Linux isn't delivering, so it might as well start diverging more. For
example, they recently started improving their ASLR implementation
towards matching PaX (not there yet). I'm sure they'd take features like
USERCOPY as-is.


--kWN9fOaUiggIhWukvlxMSoLBjTENPi7G3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWSWq0AAoJEPnnEuWa9fIqP1wP/jAUoq7MWVLgVPmGDvxTYOQN
rscq5VwmOfEKsj5wuUHodsRnWjFKBhxaGd0zhIbGOAT4vuspdttUQCUF/kkfnh2+
Q/z9HxQzZvx89SBFoDPEvjYQCH0Whb/v5wIwlTIE48rfMbG8Oxdu0qzSyR/g2u0r
rib7z34U/qnLT3DwpUipXPEKvRceS+PLU9DQA1Qo85cx+nLg4rHS0rewkcEfEg1R
40iU+b6Qq/sB99xAjsNO+VGLFV9vfgSIRtsbXgu2ZY59gJYLV6GX+up+TTUg7HJ6
5/RwUACbhzb0VQ3sbdXLO2+sWiyf8LiCyG9cYtDOzxautHZBkPZl7AAsUIhXF9QJ
M0B4viqADTkYI89mw+/KbXauywMfl9+7ghGIH+vE1SarIcEUa4tdeeL8iEvW3OL0
FthWWF0/kXkmGzMxPttvoEXHH+qGzpZIJ4UYhJ4QgmynR1+wsldSIRQkQtCYjvqV
21ueoTP4I/c85Uc33RN8gZwbRfZsivcAtHd+dMFMKo6WiFi9WJIVGNnrUmBUjQl/
2jdtRU+xmOfHq54p/Qa88nMalR32Dr3sngUixNY368ZgYxZPH9s9fMmHHheasCrJ
y7V40VnpCMruK5gSoIwkHszCDK0Xnbwjl2t99OUVFIu2o3ojwfQWQqy/DcEtZJcA
b989yF1MrRg6r1H/d8R0
=4zsG
-----END PGP SIGNATURE-----

--kWN9fOaUiggIhWukvlxMSoLBjTENPi7G3--
