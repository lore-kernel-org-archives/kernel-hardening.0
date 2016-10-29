Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 29 Oct 2016 21:42:24 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161029194224.GB3827@amd>
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
Subject: Re: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Daniel Gruss <daniel@gruss.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I think that this idea to mitigate Rowhammer is not a good approach.

Well.. it does not have to be good if it is the best we have.

> I wrote Rowhammer.js (we published a paper on that) and I had the first
> reproducible bit flips on DDR4 at both, increased and default refresh rat=
es
> (published in our DRAMA paper).

Congratulations. Now I'd like to take away your toys :-).

> We have researched the number of cache misses induced from different
> applications in the past and there are many applications that cause more
> cache misses than Rowhammer (published in our Flush+Flush paper) they just
> cause them on different rows.
> Slowing down a system surely works, but you could also, as a mitigation j=
ust
> make this CPU core run at the lowest possible frequency. That would likely
> be more effective than the solution you suggest.

Not in my testing. First, I'm not at all sure lowest CPU speed would
make any difference at all (even CPU at lowest clock is way faster
than DRAM). Second, going to lowest clock speed will reduce
performance

[But if you can test it and it works... it would be nice to know. It
is very simple to implement w/o kernel changes.]=20

> Now, every Rowhammer attack exploits not only the DRAM effects but also t=
he
> way the operating system organizes memory.
>=20
> Some papers exploit page deduplication and disabling page deduplication
> should be the default also for other reasons, such as information disclos=
ure
> attacks. If page deduplication is disabled, attacks like Dedup est Machina
> and Flip Feng Shui are inherently not possible anymore.

No, sorry, not going to play this particular whack-a-mole game. Linux
is designed for working hardware, and with bit flips, something is
going to break. (Does Flip Feng Shui really depend on dedup?)=20

> Most other attacks target page tables (the Google exploit, Rowhammer.js,
> Drammer). Now in Rowhammer.js we suggested a very simple fix, that is just
> an extension of what Linux already does.
> Unless out of memory page tables and user pages are not placed in the same
> 2MB region. We suggested that this behavior should be more strict even in
> memory pressure situations. If the OS can only find a page table that
> resides in the same 2MB region as a user page, the request should fail
> instead and the process requesting it should go out of memory. More
> generally, the attack surface is gone if the OS never places a page table=
 in
> proximity of less than 2MB to a user page.

But it will be nowhere near complete fix, right?

Will fix user attacking kernel, but not user1 attacking user2. You
could put each "user" into separate 2MB region, but then you'd have to
track who needs go go where. (Same uid is not enough, probably "can
ptrace"?)

But more importantly....

That'll still let remote server gain permissons of local user running
web server... using javascript exploit right? And that's actually
attack that I find most scary. Local user to root exploit is bad, but
getting permissions of web browser from remote web server is very,
very, very bad.

> That is a simple fix that does not cost any runtime performance.

Simple? Not really, I'm afraid. Feel free to try to implement it.

Best regards,

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgU+6AACgkQMOfwapXb+vIyqgCdHAyrKCh12BmZeJMwA47CeZCu
JVsAn0acrvilfl4OrIlKfrJM7IxJhHgn
=RKaX
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
