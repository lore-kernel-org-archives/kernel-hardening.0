Message-ID: <cf545f1e8fb4d77b6ec675a7f78268dc22d9aa90.camel@surriel.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
From: Rik van Riel <riel@surriel.com>
Date: Wed, 12 Sep 2018 14:19:18 -0400
In-Reply-To: <20180912174540.GA222557@gmail.com>
References: <20180910191002.350195-1-kristen@linux.intel.com>
	 <20180911160614.GA736@sol.localdomain>
	 <1536773389.3240.4.camel@linux.intel.com>
	 <20180912174540.GA222557@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-JkInyJkqP1dWYerLZ/S0"
Mime-Version: 1.0
Sender: riel@shelob.surriel.com
To: Eric Biggers <ebiggers@kernel.org>, Kristen C Accardi <kristen@linux.intel.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-JkInyJkqP1dWYerLZ/S0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-09-12 at 10:45 -0700, Eric Biggers wrote:
> On Wed, Sep 12, 2018 at 10:29:49AM -0700, Kristen C Accardi wrote:
> > On Tue, 2018-09-11 at 09:06 -0700, Eric Biggers wrote:
> > > On Mon, Sep 10, 2018 at 12:10:02PM -0700, Kristen Carlson Accardi
> > > wrote:
> > > > This patch aims to make it harder to perform cache timing
> > > > attacks
> > > > on data
> > > > left behind by system calls. If we have an error returned from
> > > > a
> > > > syscall,
> > > > flush the L1 cache.
> > >=20
> > > Which L1 cache?  There's no guarantee the task stayed on the same
> > > CPU...
> >=20
> > While this is true, it is unlikely that the task switched CPUs for
> > this
> > type of flow (i.e. an error path, presumably caught early-ish),=20
>=20
> How you do know it's unlikely?  What degrees of freedom might an
> attacker have
> in controlling this?
>=20
> > worst case this would just mean we were wiping the wrong cache. I
> > can
> > add a comment to indicate this scenario.
> >=20
>=20
> IOW, the protection may be useless?

If the task gets moved to a different CPU, won't that
completely foil a timing attack?

In other words, this protection would protect against
an attack on the same CPU, and is unnecessary when a
task switches CPUs?

What am I missing?

--=20
All Rights Reversed.

--=-JkInyJkqP1dWYerLZ/S0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAluZWKcACgkQznnekoTE
3oM/2gf/RF5Eb9d46pzavzHtJVgSgjWQlOzNeRoOV7L2VXNKcnAIbjqTEqQ5FRkF
QAs0INQ12coZ4e0ctfNqOGXEwW9SX+2aMv+dv6vk7cSMc1SnU3ysvGoYHQWasQcT
/PdZMn+fgcrY0uUt3KHysRdiWJZLzJ0HAvggbfS9Vvd0jGSITBPekwiEYm8780sE
EHI+PW+uLQ/ePFcjKw+vt7HQtAjiea7CQDYAHvD0RIQUvY6BJP6jI0PieBqP7j5C
kXTZrqqwpUzXdrmYIjXdtmx4fcO6+iYQylcx2SuaKjCis5OFdlemZJu8Jn/YCelN
dfTq6Ht1tdlNbWpMiS2XsbS5LpYa3Q==
=GpG3
-----END PGP SIGNATURE-----

--=-JkInyJkqP1dWYerLZ/S0--
