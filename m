Date: Tue, 6 Jun 2017 00:43:01 +0700
From: Pavel Labushev <pavel.labushev@runbox.no>
In-Reply-To: <CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
References: <20170603113007.GA1544@grsecurity.net>
	<CAGXu5j+YGaczVB7xE9t_M83dcGJjmQsr=weQwEG3NHsmHrK7SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Jun_2017_00_43_02_+0700_eMYOhGOIX78ZIzTz"
Message-Id: <E1dHw20-0007Bc-Tc@mailfront12.runbox.com>
Subject: Re: [kernel-hardening] Stop the plagiarism
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--Signature=_Tue__6_Jun_2017_00_43_02_+0700_eMYOhGOIX78ZIzTz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 4 Jun 2017 00:16:43 -0700
Kees Cook <keescook@chromium.org> wrote:

Hello, Kees.

> > https://lwn.net/SubscriberLink/724319/830a4de15663b8dd/
> > over a dozen mentions of various forms of "Cook's implementation"
>=20
> Let's see, the paragraph in the article that talks about the proposal
> credits PaX/grsecurity. Clicking through to my proposed series shows
> the first paragraph crediting PaX/grsecurity.

Did you actually ask people, i.e. the broader audience on the internet,
about their perception of the "crediting" done that way? Ever wonder if it
really fulfills its purpose, and why LWN articles, like the one linked
above, misattribute the code and ideas even further?

> You seem to be arguing semantics, rather than credit?

Let's see.

[quoted from the patch description]
> This is heavily based on the "__read_only" portion of the KERNEXEC
> infrastructure

"Heavily based" is ambiguous here. It's not clear if your patch set is just
inspired by KERNEXEC, or is it e.g. mostly a copy-paste.

[quoted from the LWN article]
> a mechanism based on similar functionality that exists in the
> PaX/grsecurity patch set

Don't you see how vague wording in the first place have turned it into a
"Cook's implementation"? Now it's not "heavily based", but just "based on
similar functionality".

This "evolution of meaning" doesn't end there. People will and do come up
with wonderful guesses that the original PaX/Grsecurity implementation had
some significant flaws that prevented it from upstreaming as is, and that
you have accomplished a great deal of work on actually fixing it, as in
re-implementing it properly.

Btw, instead of writing lengthy emails to defend yourself, you could spend
that time on writing more specific and correct patch set descriptions in
the first place and/or on speaking up publicly to prevent further spread of
misattribution of the code and ideas.

> > that was blindly copy+pasted from PaX (as evidenced by its bugs and
> > complete misunderstanding of how the original PaX code works since
> > it didn't copy+paste all the parts it needed).  And of course Kees
> > is nowhere to be found to correct the misattribution of the work because
> > it benefits him and his perceived security ability.  There's a word for
> > that: charlatan.
>=20
> Look, you need to stop this kind of personal attack.

The "personal attack", as you call it, consists of some valid points
that you just chose to downplay and ignore.

The most important one is misunderstanding of how the original PaX code
works. It is a major issue, in case you actually care about improving Linux
kernel security, not just your job security.

> And as I already said, it's not misattributed. You're just willfully
> misreading it.

Wording like "Cook's implementation" is ambiguous enough to interpret it in
many ways, willfully or not. And the surrounding (con)text, as well as your
patch set description in the first place, doesn't make it clear enough which
interpretation is the right one.

Also, people on the internet do misattribute the work when they read such
vague descriptions and their further "variations". And unless you deny that
fact, Brad is totally in his right to be furious.

> Make up your mind about how you want grsecurity attributed and maybe
> people will actually do it "right".

Could you point to some particular case of the conflicting requirements,
that you seem to imply there are?

> But you don't seem to actually want that, since you appear to just want
> to discourage anything that even looks like grsecurity from going upstrea=
m.

That is another concern, independent of the misattribution. And your
emotionally colored description of it is far from being accurate, to say
the least. Even though you're pretty much familiar with the opinions and
facts behind it, aren't you?

> If you think you're
> amply credited, you get mad that it's TOO MUCH credit because the
> resulting code is different from grsecurity and it's giving you a bad
> name somehow. If you think you're under credited, you go on these
> kinds of rants calling everyone a plagiarist.

The circumstances that make the proper crediting a somewhat difficult task
didn't emerge by themselves. After all, it's *your* decision to do the work
in a hurry, without gaining in-depth understanding of the code (not before,
not after). So it's no wonder that the results are of questionable quality.
And it's no wonder if Brad doesn't want his work, reputation or trademark
to be tainted by any unnecessarily broad associations with the security
theatre going on.

If only you and KSPP in general could be more rigorous and consistent in
following the declared goals, there would be so much less ground for the
controversies.

> I do not understand why you think there is a conspiracy against you. I
> have no time to try to figure out how to take "revenge", and even if I
> did, I'm not upset about being "cut off" from your work. As I
> mentioned already, making Linux more secure isn't all about
> grsecurity. Just ask arm64 system builders how useful grsecurity was
> for them.

Speaking of arm64, should you be reminded about when and why development of
grsec on ARM has been effectively stopped, by intention?

> > This is your last warning.  This is not a new problem and it needs to
> > end completely, or I will make sure it ends.
>=20
> You appear to be trying to bully people into not contributing to the
> upstream effort to make Linux more secure. Please stop.

It doesn't seem so. Nothing prevents people from contributing as long as
they're being careful with the copyright statements.

--Signature=_Tue__6_Jun_2017_00_43_02_+0700_eMYOhGOIX78ZIzTz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZNZgmAAoJEGrJjhq7qg7wAcYP/398HF9wWOGCnd/jtYteD3dO
LvkbysjzlarQsqo8iFDAVBrcWh+ngoCp9P9MAv8snHIYpktobsfuGAyl4vX2C0dD
1I6bxuZGrlRHFTn8iLMUl+/2DuuzNngA7XY4mSWwjkoj1vOAjdzMVXMry8VYspUc
JJeEd3ok8PtljD4FgehpNUg4O6DryIbv1cu4ZOVByA/fkOjUUh6BYLOWF0tUSuMU
/lZtevOakl2ydPiSlqiMF93RCFD5TUXMbxShkMzaR0K11sGngXjsFUi+Dzadygge
/sq3CIg0wrKgrk1PhzRBQxROUAhZQw9+C60JhCw/Qm8tN5hNnfoi2u4xW097xcwJ
nlbWucYexK2MGCnMEyaLlkXdI9km3WRqLsgxZi63T2TA9OMfUO0MOgSM6qdkfkH8
PykfxXmZiQLiIYNlGQG6b3Y/ho4hiQGyBlKfBqB0NsYdJ71+rpjKwA6WM71tsBQ5
iR0UqUlp14DVBGY1osW4eOLTlbEU28+iC8Gz/8qdP6enjdE8NrsLjZJogWKx/+f8
FJK5zHUnDBKEJKpuyhOIGZbVAjRgL0krgdQMbc6g3x9mPoF3BqaTfByMfp/jzLxc
jw4gDGlLuBXCMee0fjQxfK39o0kos/dA/r9fg1nJMrA8iG/8xlhJeIVWykA6O3V0
BThM3opUAY7KVbuH7GT/
=BLHl
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jun_2017_00_43_02_+0700_eMYOhGOIX78ZIzTz--
