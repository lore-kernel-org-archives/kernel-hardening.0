Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1484344621.3381.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 13 Jan 2017 16:57:01 -0500
In-Reply-To: <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
References: 
	<CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
	 <20170113082347.GJ20972@linaro.org>
	 <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
	 <5879219B.26854.33C60FDB@pageexec.freemail.hu>
	 <CAGXu5jJt7Kc9eH+=a11=ewem1E0GDo4+tu48OWGQ67Tu7fJfLA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7Z61fASns0F5wmYp/2UY"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Introduction
To: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>
Cc: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-7Z61fASns0F5wmYp/2UY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-01-13 at 11:06 -0800, Kees Cook wrote:
> On Fri, Jan 13, 2017 at 10:51 AM, PaX Team <pageexec@freemail.hu>
> wrote:
> > On 13 Jan 2017 at 9:54, Kees Cook wrote:
> >=20
> > > PaX Team, the heuristic for STRUCTLEAK appears to be "does the
> > > struct
> > > contain anything marked __user". Is this actually a meaningful
> > > information exposure case? It seems like there are a lot more
> > > cases
> > > for exposures where there is nothing marked __user. Is that the
> > > meaning of "much smaller coverage" compared to STACKLEAK in the
> > > Kconfig?
> >=20
> > STRUCTLEAK was written in response to a particular bug a few years
> > ago
> > where we didn't want to give the bug away but still wanted to fix it
> > during the embargo. the struct in question could be matched by this
> > heuristics, matching everything else (however little of it) is
> > really
> > just a free side effect. could coverage be improved? of course but
> > that
> > would take a whole lot more work (manual markups and/or data flow
> > analysis
> > in LTO mode).
>=20
> Out of curiosity, do you remember which bug? I'd be curious to compare
> it against others. It seems like adding structleak to upstream still
> has value, even if the coverage isn't as complete as stackleak.

There's the performance-oblivious approach of zeroing all locals early
in the compiler pipeline and relying on compiler optimizations to remove
it when it's not required. They're already pretty good at doing it.
There can be a scale of aggressiveness for a feature like this, with
very conservative heuristics on one end (like analysis to propagate from
copy_to_user) and no heuristics at all for the other. It would be
interesting to measure that to figure out the worst case performance
scenario, particularly if it's possible to narrow down areas where it
hurts and then work out some simple heuristics to reduce the cost. Maybe
most of the cost can be alleviated by not doing arrays or by having a
size limit, etc. Maybe there are only a few areas where it really hurts
and they could be marked. Need to test before conclusions about
heuristics can be drawn.

I'm doing it for Android's userspace via Clang. It's usually very cheap
and actually costs less than SSP for most code. The top of the stack is
inherently hot data and since it's not adding branches, the main cost is
probably code size. There are some cases where it can really hurt due to
arrays on the stack, but the kernel doesn't have as many of those
particularly with large arrays. I haven't implemented it for GCC so I
haven't had a chance to try it with the kernel yet. I expect it to be
more than cheap enough for my needs though.

If nothing else, it could be a useful way to uncover bugs via the option
of a non-zero byte value for debug builds rather than the production
oriented zeroing. AFAIK, the kernel doesn't have anything to do that on
the stack, and I haven't had much luck with MSan in userspace anyway.
--=-7Z61fASns0F5wmYp/2UY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlh5TS0WHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKnP/D/44vHosmL3kuR60sxlB9imc9RkP
pyGwoWPC7Kk+SS4x5kSEzE9UIfTCWEUYqwdSJ6JzpwkziLjALlGvOVfCS0X3sb6j
kDXCqppBdPHIxhcJ741HTk91nFIlfkO/UorO0sT4afQYVps8VqT1E72aBkF/bFhY
bWm6/ERmIE1z6a2VwalYPVmuz4rNPX0Avlw4e7Z1hl/Rb/R9OJdh4eZhNWSWyoDu
mw0i296zwOJs/gKjX4mKN9O/nwzWCdDHvLT4fo+qizyEfu2l6qD0h+s1b7b5vazo
5lfSR+8sAd5sjkPsDJZqwXD14bgd+HDMLvvvKPpkdl7GZbViDcKFydRedaSpZ92w
AKq3vN6K3EPyb0HDrw88zCA1nCEOzI10z+iADVRqqlQTl2oeL++40DMILtVPwE7/
ltkAr6ZpatqblAlRM8McMCjYHt6kLMnR83DXLS2UG0WZA0VOgyIaV3F5YV0PNVXL
bpFPnXTTvmuWxhSY2m529dYOooLV1xvP53m3dwrRyxWmq8Jl5SdvfkUR3x9bBDXQ
JXgHwTAokOheXrepULlreTScF3pzvXUarv7jwUM5FGZPELh82n3ECcjeYP5TRztg
8fwLXXOVu/Sd+galYXycWB42IxgK8aB6JEGSMQPOs1sx8pFVGk7Wlkapl070sY2C
2G1ORb05NV1MJvqY5g==
=XD9y
-----END PGP SIGNATURE-----

--=-7Z61fASns0F5wmYp/2UY--
