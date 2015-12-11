Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <CAGXu5jLU=tbyCm2Jjjj1RshygiFEYMKNtbwPs6p-seCkJ2Ajdw@mail.gmail.com>
References: <20151209172101.GA70633@davidb.org> <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com> <1449770155.8579.2.camel@gmail.com> <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com> <1449774477.8579.4.camel@gmail.com> <CAGXu5j+OhUjRZSfCoFZeAY23-rzGDQ_6cU886BNSr3PCzQ60Hw@mail.gmail.com> <99FC4B6EFCEFD44486C35F4C281DC6731F1DF8B1@ORSMSX107.amr.corp.intel.com>
 <CAGXu5jLU=tbyCm2Jjjj1RshygiFEYMKNtbwPs6p-seCkJ2Ajdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1449856475_2509P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Dec 2015 12:54:35 -0500
Message-ID: <6439.1449856475@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Self Introduction
To: kernel-hardening@lists.openwall.com
Cc: "Schaufler, Casey" <casey.schaufler@intel.com>, Catalin Marinas <catalin.marinas@arm.com>, PaX Team <pageexec@freemail.hu>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ralf Baechle <ralf@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1449856475_2509P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Dec 2015 11:45:35 -0800, Kees Cook said:
> On Thu, Dec 10, 2015 at 11:38 AM, Schaufler, Casey

> That's great! Thanks for speaking up. Another area that hasn't seen
> any traction yet is PAX_USERCOPY. Valdis seems to be MIA, so I'd love
> to see someone else take on that chunk of work.

Whoops. sorry.. I just didn't have anything in a state ready to share,
and I got sidetracked by a week in the hospital (am all OK now, thankfully).

Biggest problem is just taking one big 7M patch and teasing out just the
USERCOPY parts, and then re-arranging it into something that upstream will
be willing to take.  Just lots and lots of grunt work.

I don't suppose the grsecurity guys have a git repo where a lot of the
heavy duty lifting is already done? :)

--==_Exmh_1449856475_2509P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVmsN2wdmEQWDXROgAQIsJA//dmyVOfn0saHjuPtBMahX2sSeGS7U/LqO
ljYGQX9AUgGd3wjBf4753FTkb8CT3Qx+tbMJhzQbfIzbn/YJsZzN5xR2o7kgYm9/
A5s47U3t0ABnTqQqbL0IhVn3LW4ctyVXytjd9Z97+8CxUf9qwsLda2AaTXvc0AEF
y9gznA0Ho+54mQrJ5vJTDcmFu+qmJ+uqvXznyk8EdTx0hz/ViCKbF2s5MJ3+AplF
VuJ7E86FQSOFuP6u4m1e8oMYVWyvouNnUL/Hn0p9TNLekEqPS3Q+9qD8L8+bwEIZ
Q5jL7f324RLpJIy79+lkaSvCDWD4aU28U2rGrmZKqKcntcJIvjcIutGQZvKjeI+h
nJMXDGIGRnauNhZaEdabCvX4/LggoMDS9nbEJWL4TBKL2rhEMF4BkWbPwC9+gY1c
2+TxYvfXA5GBnkLYqtDBzyh3PwpaWonYQm/J3N/LD68cIRkFoaRqL44vvM5ipBvY
b2htmLtcpvOPbWwopjAyT6VvhUnYjllipo7kOSjqwSQeBPm7L1nx+svfBYuneyqI
LhORquR3gmV340CpDMsonqP4WGOJFsTJwbe9r03v0VoWURNWGLLl+1ypfrO+wvew
+49fYThxs78vIASi9rXdEycrr0dqMBydyDFza6+IRXp2a4VNHaL9mzVc8iKTftl4
I9G98VKbwew=
=QtRB
-----END PGP SIGNATURE-----

--==_Exmh_1449856475_2509P--
