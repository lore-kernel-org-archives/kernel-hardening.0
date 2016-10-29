Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 29 Oct 2016 23:45:40 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161029214540.GD3827@amd>
References: <20161028172710.GA10309@amd>
 <d2f7dc1d-12ab-de12-cf73-7565fc27f5f7@gruss.cc>
 <20161029194224.GB3827@amd>
 <5f5741d5-0695-6a56-6c05-ebdaaa896f54@gruss.cc>
 <20161029210518.GC3827@amd>
 <571c5ef8-ccce-0b7a-b506-c69a024276a0@gruss.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <571c5ef8-ccce-0b7a-b506-c69a024276a0@gruss.cc>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Daniel Gruss <daniel@gruss.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2016-10-29 23:07:59, Daniel Gruss wrote:
> On 29.10.2016 23:05, Pavel Machek wrote:
> >So far I did bzip2 and kernel compilation. I believe I can prevent
> >flips in rowhammer-test with bzip2 going from 4 seconds to 5
> >seconds... let me see.
>=20
> can you prevent bitflips in this one?
> https://github.com/IAIK/rowhammerjs/tree/master/native

Thanks for the pointer. Unfortunately, my test machine has 64-bit
kernel, but 32-bit userland, so I can't compile it:

g++ -g -pthread -std=3Dc++11 -O3 -o rowhammer rowhammer.cc
rowhammer.cc: In function =E2=80=98int main(int, char**)=E2=80=99:
rowhammer.cc:243:57: error: inconsistent operand constraints in an
=E2=80=98asm=E2=80=99
   asm volatile ("rdtscp" : "=3Da" (a), "=3Dd" (d) : : "rcx");

I tried g++ -m64, but that does not seem to work here at all. I'll try
to find some way to compile it during the week.

(BTW any idea which version would be right for this cpu?

processor     : 1
vendor_id     : GenuineIntel
cpu family    : 6
model	      	: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz
stepping	: 10

Its Wolfdale-3M according to wikipedia... that seems older than
indy/sandy/haswell/skylake, so I'll just use the generic version...?)

> >Ok, let me try that. Problem is that the machine I'm testing on takes
> >20 minutes to produce bit flip...
>=20
> will be lots faster with my code above ;)

Yes, that will help :-).
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgVGIQACgkQMOfwapXb+vKCfACeKGMhNdiDZnq5nTS62oQacpjT
LHgAoKA/WAmjTzYh0WEfsUkCgF+k0d4B
=4xYW
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
