Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 29 Oct 2016 23:05:18 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161029210518.GC3827@amd>
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
 <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Daniel Gruss <daniel@gruss.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Sat 2016-10-29 22:05:16, Daniel Gruss wrote:
> On 29.10.2016 21:42, Pavel Machek wrote:
> >Congratulations. Now I'd like to take away your toys :-).
>=20
> I'm would like you to do that, but I'm very confident you're not successf=
ul
> the way your starting ;)

:-). Lets see.

> >Not in my testing.
>=20
> Have you tried music/video reencoding? Games? Anything that works with a
> decent amount of memory but not too much hard disk i/o?
> Numbers are very clear there...

So far I did bzip2 and kernel compilation. I believe I can prevent
flips in rowhammer-test with bzip2 going from 4 seconds to 5
seconds... let me see.

If you have simple test that you'd like me to try, speak up. Best if
it takes cca 10 seconds to run.

> >First, I'm not at all sure lowest CPU speed would
> >make any difference at all
>=20
> It would. I've seen many bitflips but none where the CPU operated in the
> lower frequency range.

Ok, let me try that. Problem is that the machine I'm testing on takes
20 minutes to produce bit flip...

> >Second, going to lowest clock speed will reduce performance
>=20
> As does the countermeasure you propose...

Yes. But hopefully not quite _as_ drastically. (going to lowest clock
would make bzip2 go from 4 to 12 seconds or so, right?)

> Yes, Flip Feng Shui requires deduplication and does not work without.
> Disabling deduplication is what the authors recommend as a
> countermeasure.

Ok, Flip Feng Shui is easy, then. :-).

> >But it will be nowhere near complete fix, right?
> >
> >Will fix user attacking kernel, but not user1 attacking user2. You
> >could put each "user" into separate 2MB region, but then you'd have to
> >track who needs go go where. (Same uid is not enough, probably "can
> >ptrace"?)
>=20
> Exactly. But preventing user2kernel is already a good start, and you would
> prevent that without any doubt and without any cost.

Well, it is only good start if the result is mergeable, and can be
used to prevent all attacks we care about.

> >That'll still let remote server gain permissons of local user running
> >web server... using javascript exploit right?  And that's actually
> >attack that I find most scary. Local user to root exploit is bad, but
> >getting permissions of web browser from remote web server is very,
> >very, very bad.
>=20
> Rowhammer.js skips the browser... it goes JS to full phys. memory access.
> Anyway, preventing Rowhammer from JS should be easy because even the
> slightest slow down should be enough to prevent any Rowhammer attack from
> JS.

Are you sure? How much slowdown is enough to prevent the attack? (And
can I get patched chromium? Patched JVM? Patched qemu?) Dunno.. are
only just in time compilers affected? Or can I get for example pdf
document that does all the wrong memory accesses during rendering,
triggering buffer overrun in xpdf and arbitrary code execution?

Running userland on non-working machine is scary :-(.

Shall we introduce new syscall "get_mandatory_jit_slowdown()"?

I'd like kernel patch that works around rowhammer problem... in
kernel. I'm willing to accept some slowdown (say from 4 to 6 seconds
for common tasks). I'd prefer solution to be contained in kernel, and
present working (but slower) machine to userspace. I believe I can do
that.

> >>That is a simple fix that does not cost any runtime performance.
> >
> >Simple? Not really, I'm afraid. Feel free to try to implement it.
>=20
> I had a student who already implemented this in another OS, I'm confident=
 it
> can be done in Linux as well...

Well, I'm not saying its impossible. But I'd like to see the
implementation. Its definitely more work than nohammer.c. Order of
magnitude more, at least.

But yes, it will help with side channel attacks, etc. So yes, I'd like
to see the patch.

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgVDw4ACgkQMOfwapXb+vJxXwCdFlRny0SLPjYIdm3zjX/l7Eg8
bswAn07N/BiOcQ52h/djXlntR2gZD3Ur
=Io5S
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
